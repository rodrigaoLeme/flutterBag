import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/available_announcement_entity.dart';
import '../../../domain/entities/school_entity.dart';
import '../../../domain/helpers/app_constants.dart';
import '../../../main/factories/pages/notices_terms/notice_document_page_factory.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import '../../helpers/app_assets.dart';
import '../../helpers/themes/app_colors.dart';
import '../../helpers/themes/app_text_styles.dart';
import '../new_request/new_scholarship_request_page.dart';
import '../notices_terms/notice_document_page.dart';
import 'new_scholarship_presenter.dart';
import 'new_scholarship_view_model.dart';

class _FilterOption {
  final String id;
  final String label;

  const _FilterOption({required this.id, required this.label});

  @override
  bool operator ==(Object other) => other is _FilterOption && other.id == id;

  @override
  int get hashCode => id.hashCode;
}

class NewScholarshipPage extends StatefulWidget {
  final NewScholarshipPresenter presenter;
  final int lockedYear;
  const NewScholarshipPage({
    super.key,
    required this.presenter,
    required this.lockedYear,
  });

  @override
  State<NewScholarshipPage> createState() => _NewScholarshipPageState();
}

class _NewScholarshipPageState extends State<NewScholarshipPage> {
  late StreamSubscription<NewScholarshipViewModel> _viewModelSubscription;
  late StreamSubscription<List<AvailableAnnouncementEntity>>
      _announcementsSubscription;

  _FilterOption? _selectedCity;
  _FilterOption? _selectedUnit;

  List<_FilterOption> _cities = [];
  List<_FilterOption> _units = [];
  List<SchoolEntity> _currentUnits = [];
  EducationLevel? _selectedEducationLevel;

  List<AvailableAnnouncementEntity> _activeAnnouncements = [];
  List<AvailableAnnouncementEntity> _expiredAnnouncements = [];

  bool _isLoadingSchools = false;
  bool _isLoadingAnnouncements = false;
  String? _schoolsError;
  bool _isEad = false;
  bool _showExpired = false;
  bool _hasAppliedFilters = false;
  int _eadSearchToken = 0;

  bool get _areFiltersComplete =>
      _selectedCity != null && _selectedUnit != null;

  @override
  void initState() {
    super.initState();

    _viewModelSubscription = widget.presenter.viewModelStream.listen((vm) {
      if (!mounted) return;
      setState(() {
        _cities = vm.cities.map((c) => _FilterOption(id: c, label: c)).toList();
        _isLoadingSchools = vm.isLoadingSchools;
        _schoolsError = vm.schoolsError;
      });
    });

    _announcementsSubscription =
        widget.presenter.announcementsStream.listen((announcements) {
      if (!mounted || _isEad) return;
      setState(() {
        _activeAnnouncements = announcements.where((a) => a.isActive).toList();
        _expiredAnnouncements =
            announcements.where((a) => !a.isActive).toList();
        _isLoadingAnnouncements = false;
      });
    });

    widget.presenter.loadInitialData(widget.lockedYear);
  }

  @override
  void dispose() {
    _viewModelSubscription.cancel();
    _announcementsSubscription.cancel();
    widget.presenter.dispose();
    super.dispose();
  }

  String _normalize(String value) => value
      .toLowerCase()
      .replaceAll('–', '-')
      .replaceAll('—', '-')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  bool _matchesEadCity(SchoolEntity school) {
    final city = _normalize(school.city ?? '');
    final cityState = _normalize(school.cityState);
    return city.contains('engenheiro coelho') ||
        cityState.contains('engenheiro coelho');
  }

  bool _matchesEadUnit(SchoolEntity school) {
    final name = _normalize(school.name ?? '');
    if (name.contains(_normalize(AppConstants.eadUnitLabel))) return true;
    if (name.contains(_normalize(AppConstants.eadUnitDisplayLabel))) {
      return true;
    }
    if (!name.contains('unasp')) return false;
    return name.contains('ead') ||
        RegExp(r'(^|[^a-z])ec([^a-z]|$)').hasMatch(name);
  }

  ({_FilterOption city, _FilterOption unit})? _findEadSchool() {
    final schools = widget.presenter.allSchools;
    if (schools.isEmpty) return null;

    final preferred =
        schools.where((s) => _matchesEadCity(s) && _matchesEadUnit(s)).toList();
    final matched = preferred.isNotEmpty
        ? preferred
        : schools.where(_matchesEadUnit).toList();
    if (matched.isEmpty) return null;

    final school = matched.first;
    return (
      city: _FilterOption(id: school.cityState, label: school.cityState),
      unit: _FilterOption(
        id: school.id,
        label: school.name ?? AppConstants.eadUnitDisplayLabel,
      ),
    );
  }

  Future<void> _runEadSearch() async {
    final token = ++_eadSearchToken;
    setState(() {
      _isLoadingAnnouncements = true;
      _hasAppliedFilters = false;
      _activeAnnouncements = [];
      _expiredAnnouncements = [];
      _selectedEducationLevel = EducationLevel.higher;
    });

    if (widget.presenter.allSchools.isEmpty) {
      await widget.presenter.loadSchools(widget.lockedYear.toString());
    }
    if (!mounted || !_isEad || token != _eadSearchToken) return;

    final match = _findEadSchool();
    if (match == null) {
      setState(() {
        _isLoadingAnnouncements = false;
        _hasAppliedFilters = true;
        _activeAnnouncements = [];
        _expiredAnnouncements = [];
      });
      return;
    }

    setState(() {
      _selectedCity = match.city;
      _selectedUnit = match.unit;
      _currentUnits = widget.presenter.getUnitsForCity(match.city.id);
      _units = _currentUnits
          .map((s) => _FilterOption(id: s.id, label: s.name ?? ''))
          .toList();
    });

    final announcements = await widget.presenter.fetchAnnouncements(
      year: widget.lockedYear.toString(),
      city: match.city.id.split(' - ').first,
      schoolId: match.unit.id,
      educationLevel: EducationLevel.higher,
    );

    if (!mounted || !_isEad || token != _eadSearchToken) return;

    setState(() {
      _activeAnnouncements = announcements.where((a) => a.isActive).toList();
      _expiredAnnouncements = announcements.where((a) => !a.isActive).toList();
      _isLoadingAnnouncements = false;
      _hasAppliedFilters = true;
    });
  }

  void _onEadChanged(bool value) {
    if (value) {
      setState(() {
        _isEad = true;
        _selectedEducationLevel = EducationLevel.higher;
      });
      _clearResults();
      _runEadSearch();
      return;
    }

    _eadSearchToken++;
    setState(() {
      _isEad = false;
      _selectedCity = null;
      _selectedUnit = null;
      _selectedEducationLevel = null;
      _units = [];
      _currentUnits = [];
      _isLoadingAnnouncements = false;
    });
    _clearResults();
  }

  void _onCityChange(_FilterOption? value) {
    if (_isEad) return;

    setState(() {
      _selectedCity = value;
      _selectedUnit = null;
      _units = [];
    });

    _clearResults();

    if (value != null) {
      _currentUnits = widget.presenter.getUnitsForCity(value.id);
      setState(() {
        _units = _currentUnits
            .map((s) => _FilterOption(id: s.id, label: s.name ?? ''))
            .toList();
      });
    }
    _applyIfComplete();
  }

  void _onUnitChanged(_FilterOption? value) {
    if (_isEad || value == null) return;

    setState(() {
      _selectedUnit = value;
      final school = _currentUnits.firstWhere(
        (s) => s.id == value.id,
        orElse: () => _currentUnits.first,
      );
      _selectedEducationLevel = school.educationLevel;
    });
    _clearResults();
    _applyIfComplete();
  }

  void _clearResults() {
    widget.presenter.clearAnnouncements();
    setState(() {
      _activeAnnouncements = [];
      _expiredAnnouncements = [];
      _hasAppliedFilters = false;
    });
  }

  void _applyIfComplete() {
    if (!_areFiltersComplete || _isEad) return;

    setState(() {
      _hasAppliedFilters = true;
      _isLoadingAnnouncements = true;
    });
    widget.presenter.fetchAnnouncements(
      year: widget.lockedYear.toString(),
      city: _selectedCity!.id.split(' - ').first,
      schoolId: _selectedUnit!.id,
      educationLevel: _selectedEducationLevel,
    );
  }

  Future<void> _openCitySelector() async {
    if (_isEad) return;
    final appStrings = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<_FilterOption>(
      context: context,
      title: appStrings.noticesTermsSelectCity,
      options: _cities,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _selectedCity,
      labelBuilder: (item) => item.label,
      searchTextBuilder: (item) => item.label,
    );
    if (selected != null) _onCityChange(selected);
  }

  Future<void> _openUnitSelector() async {
    if (_isEad || _selectedCity == null) return;
    final appStrings = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<_FilterOption>(
      context: context,
      title: appStrings.noticesTermsSelectUnit,
      options: _units,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _selectedUnit,
      labelBuilder: (item) => item.label,
      searchTextBuilder: (item) => item.label,
    );
    if (selected != null) _onUnitChanged(selected);
  }

  void _onApplyPressed(AvailableAnnouncementEntity announcement) {
    EbolsaDialogWithCancel.show(
      context: context,
      barrierDismissible: true,
      title: AppI18n.current.scholarshipApplicationTitle,
      description:
          AppI18n.current.noticesTermsScholarshipApplicationDescription,
      actions: [
        EbolsaDialogAction(
          label: AppI18n.current.newScholarshipDialogCancel,
          onPressed: () {},
        ),
        EbolsaDialogAction(
          label: AppI18n.current.continueAction,
          isPrimary: true,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => NewScholarshipRequestPage(
                  processPeriodId: announcement.processPeriod!.id,
                  announcementSchools: announcement.schools,
                  processYear: widget.lockedYear,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _openDocument({required String announcementId, required String title}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoticeDocumentPage(
          presenter: makeNoticeDocumentPresenter(),
          announcementId: announcementId,
          title: title,
        ),
      ),
    );
  }

  Widget _buildSelectorField({
    required String hint,
    required _FilterOption? value,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          enabled: enabled,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        child: Text(
          value?.label ?? hint,
          style: value == null
              ? AppTextStyles.ebolsaBodyLargeOutline
              : AppTextStyles.bodyLarge,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    final displayList = _showExpired
        ? [..._activeAnnouncements, ..._expiredAnnouncements]
        : _activeAnnouncements;

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.newProcess),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.noticesTermsTitle,
              style: AppTextStyles.ebolsaHeadlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              appStrings.noticesTermsDescription,
              style: AppTextStyles.ebolsaBodyMedium,
            ),
            const SizedBox(height: 24),
            OptionCardEAD(
              icon: AppIcons.calendar,
              title: widget.lockedYear.toString(),
            ),
            const SizedBox(height: 16),

            if (_schoolsError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EbolsaErrorBanner(message: _schoolsError!),
              ),

            if (_isEad) ...[
              OptionCardEAD(
                icon: AppIcons.escola,
                title: AppConstants.eadCityDisplayLabel,
              ),
              const SizedBox(height: 16),
              OptionCardEAD(
                icon: AppIcons.capelo,
                title: AppConstants.eadUnitDisplayLabel,
              ),
            ] else ...[
              _buildSelectorField(
                hint: appStrings.noticesTermsSelectCity,
                value: _selectedCity,
                enabled: _cities.isNotEmpty && !_isLoadingSchools,
                onTap: _openCitySelector,
              ),
              const SizedBox(height: 16),
              _buildSelectorField(
                hint: appStrings.noticesTermsSelectUnit,
                value: _selectedUnit,
                enabled: _units.isNotEmpty,
                onTap: _openUnitSelector,
              ),
            ],
            const SizedBox(height: 16),

            /// EAD TOGGLE
            Row(
              children: [
                Expanded(
                  child: Text(
                    appStrings.noticesTermsEadLabel,
                    style: AppTextStyles.ebolsaBodyLarge,
                  ),
                ),
                Switch(
                  value: _isEad,
                  onChanged: _onEadChanged,
                  activeTrackColor: AppColors.primary,
                  activeThumbColor: Colors.white,
                ),
              ],
            ),

            /// EXIBIR ENCERRADOS TOGGLE
            Row(
              children: [
                Expanded(
                  child: Text(
                    appStrings.newScholarshipShowExpired,
                    style: AppTextStyles.ebolsaBodyLarge,
                  ),
                ),
                Switch(
                  value: _showExpired,
                  onChanged: (v) => setState(() => _showExpired = v),
                  activeTrackColor: AppColors.primary,
                  activeThumbColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Cards
            if (_isLoadingAnnouncements)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_hasAppliedFilters && displayList.isEmpty)
              EBolsaWarningBanner(
                title: appStrings.noticesTermsNoResultsTitle,
                message: _isEad
                    ? appStrings.newScholarshipEadNoResultsMessage(
                        year: widget.lockedYear.toString(),
                        city: AppConstants.eadCityDisplayLabel,
                        unit: AppConstants.eadUnitDisplayLabel,
                      )
                    : appStrings.noticesTermsNoResultsMessage,
              )
            else if (_hasAppliedFilters)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: displayList.length,
                itemBuilder: (context, index) {
                  final announcement = displayList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AvailableAnnouncementCard(
                      announcement: announcement,
                      onViewPressed: () {
                        _openDocument(
                          announcementId: announcement.id,
                          title: announcement.title ?? 'Documento',
                        );
                      },
                      onApplyPressed: announcement.canApply
                          ? () => _onApplyPressed(announcement)
                          : null,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
