import 'dart:async';

import 'package:flutter/material.dart';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/available_announcement_entity.dart';
import '../../../domain/entities/school_entity.dart';
import '../../../main/factories/pages/notices_terms/notice_document_page_factory.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import '../../helpers/themes/app_text_styles.dart';
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

  List<AvailableAnnouncementEntity> _announcements = [];
  List<AvailableAnnouncementEntity> _activeAnnouncements = [];
  List<AvailableAnnouncementEntity> _expiredAnnouncements = [];

  bool _isLoadingSchools = false;
  String? _schoolsError;
  bool _showExpired = false;
  bool _hasAppliedFilters = false;

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
      if (!mounted) return;
      setState(() {
        _announcements = announcements;
        _activeAnnouncements = announcements.where((a) => a.isActive).toList();
        _expiredAnnouncements =
            announcements.where((a) => !a.isActive).toList();
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

  void _onCityChange(_FilterOption? value) {
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
    setState(() {
      _selectedUnit = value;
      if (value != null) {
        final school = _currentUnits.firstWhere(
          (s) => s.id == value.id,
          orElse: () => _currentUnits.first,
        );
        _selectedEducationLevel = school.educationLevel;
      }
    });
    _clearResults();
    _applyIfComplete();
  }

  void _clearResults() {
    widget.presenter.clearAnnouncements();
    setState(() {
      _announcements = [];
      _activeAnnouncements = [];
      _expiredAnnouncements = [];
      _hasAppliedFilters = false;
    });
  }

  void _applyIfComplete() {
    if (_areFiltersComplete) {
      _hasAppliedFilters = true;
      widget.presenter.fetchAnnouncements(
        year: widget.lockedYear.toString(),
        city: _selectedCity!.id.split(' - ').first,
        schoolId: _selectedUnit!.id,
        educationLevel: _selectedEducationLevel,
      );
    }
  }

  Future<void> _openCitySelector() async {
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
    if (_selectedCity == null) return;
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
      title: AppI18n.current.noticesTermsScholarshipApplication,
      description:
          AppI18n.current.noticesTermsScholarshipApplicationDescription,
      actions: [
        EbolsaDialogAction(
          label: AppI18n.current.newScholarshipDialogCancel,
          onPressed: () {},
        ),
        EbolsaDialogAction(
          label: AppI18n.current.newScholarshipDialogContinue,
          isPrimary: true,
          onPressed: () {
            // TODO: Navegar para a etapa 1
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
        title: Text(appStrings.newScholarshipTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.newScholarshipSubtitle,
              style: AppTextStyles.ebolsaHeadlineSmall,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              appStrings.newScholarshipDescription,
              style: AppTextStyles.ebolsaBodyMedium,
            ),
            const SizedBox(
              height: 40,
            ),

            // Ano
            InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabled: false,
              ),
              child: Text(
                widget.lockedYear.toString(),
                style: AppTextStyles.ebolsaBodyLarge,
              ),
            ),
            const SizedBox(
              height: 24,
            ),

            if (_schoolsError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: EbolsaErrorBanner(message: _schoolsError!),
              ),

            // Cidade
            _buildSelectorField(
              hint: appStrings.noticesTermsSelectCity,
              value: _selectedCity,
              enabled: _cities.isNotEmpty && !_isLoadingSchools,
              onTap: _openCitySelector,
            ),
            const SizedBox(
              height: 24,
            ),

            // Unidade Escolar
            _buildSelectorField(
              hint: appStrings.noticesTermsSelectUnit,
              value: _selectedUnit,
              enabled: _units.isNotEmpty,
              onTap: _openUnitSelector,
            ),
            const SizedBox(
              height: 8,
            ),

            // Switch para exibir expirados
            if (_hasAppliedFilters && _expiredAnnouncements.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    appStrings.newScholarshipShowExpired,
                    style: AppTextStyles.ebolsaBodyMedium,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Switch(
                    value: _showExpired,
                    onChanged: (v) => setState(() => _showExpired = v),
                  ),
                ],
              ),
            const SizedBox(
              height: 8,
            ),

            // Cards
            if (_hasAppliedFilters && displayList.isEmpty)
              EBolsaWarningBanner(
                title: appStrings.noticesTermsNoResultsTitle,
                message: appStrings.noticesTermsNoResultsMessage,
              )
            else
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
