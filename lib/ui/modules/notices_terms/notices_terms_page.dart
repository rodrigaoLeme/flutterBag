import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/entities/notice_entity.dart';
import '../../../domain/entities/school_entity.dart';
import '../../../domain/helpers/app_constants.dart';
import '../../../main/factories/pages/notices_terms/notice_document_page_factory.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../components/additive_term_card.dart';
import '../../components/components.dart';
import '../../components/notice_card.dart';
import '../../helpers/app_assets.dart';
import '../../helpers/themes/app_colors.dart';
import '../../helpers/themes/app_text_styles.dart';
import 'notice_document_page.dart';
import 'notices_terms_presenter.dart';
import 'notices_terms_view_model.dart';

class _NoticeFilterOption {
  final String id;
  final String label;

  const _NoticeFilterOption({required this.id, required this.label});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _NoticeFilterOption && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class NoticesTermsPage extends StatefulWidget {
  final NoticesTermsPresenter presenter;
  final bool showAppBar;

  const NoticesTermsPage({
    super.key,
    required this.presenter,
    this.showAppBar = true,
  });

  @override
  State<NoticesTermsPage> createState() => _NoticesTermsPageState();
}

class _NoticesTermsPageState extends State<NoticesTermsPage> {
  late StreamSubscription<List<NoticeEntity>> _noticesSubscription;
  late StreamSubscription<NoticesTermsViewModel> _viewModelSubscription;

  List<NoticeEntity> _notices = [];
  bool _hasAppliedFilters = false;
  bool _isLoading = false;
  String? _locationMessage;

  _NoticeFilterOption? _selectedYear;
  _NoticeFilterOption? _selectedCity;
  _NoticeFilterOption? _selectedUnit;

  List<_NoticeFilterOption> _years = [];
  List<_NoticeFilterOption> _cities = [];
  List<_NoticeFilterOption> _units = [];
  bool _isLoadingSchools = false;
  String? _schoolsError;

  List<_NoticeFilterOption> get _availableCities => _cities;

  List<_NoticeFilterOption> get _availableUnits => _units;

  bool get _areFiltersComplete =>
      _selectedYear != null && _selectedCity != null && _selectedUnit != null;

  EducationLevel? _selectedEducationLevel;
  bool _isEad = false;
  int _eadSearchToken = 0;

  List<SchoolEntity> _currentUnits = [];

  @override
  void initState() {
    super.initState();

    _viewModelSubscription = widget.presenter.viewModelStream.listen((vm) {
      if (!mounted) return;
      setState(() {
        _years =
            vm.years.map((y) => _NoticeFilterOption(id: y, label: y)).toList();
        _cities =
            vm.cities.map((c) => _NoticeFilterOption(id: c, label: c)).toList();
        _isLoadingSchools = vm.isLoadingSchools;
        _schoolsError = vm.schoolsError;
      });
    });

    _noticesSubscription = widget.presenter.noticesStream.listen((notices) {
      if (!mounted || _isEad) return;
      setState(() {
        _notices = notices;
        _isLoading = false;
      });
    });

    widget.presenter.loadInitialData();
    _requestLocationPermission();
  }

  @override
  void dispose() {
    _viewModelSubscription.cancel();
    _noticesSubscription.cancel();
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

  ({_NoticeFilterOption city, _NoticeFilterOption unit})? _findEadSchool() {
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
      city: _NoticeFilterOption(
        id: school.cityState,
        label: school.cityState,
      ),
      unit: _NoticeFilterOption(
        id: school.id,
        label: school.name ?? AppConstants.eadUnitDisplayLabel,
      ),
    );
  }

  Future<void> _runEadSearch() async {
    final year = _selectedYear;
    if (year == null) return;

    final token = ++_eadSearchToken;
    setState(() {
      _isLoading = true;
      _hasAppliedFilters = false;
      _notices = [];
      _selectedEducationLevel = EducationLevel.higher;
    });

    await widget.presenter.loadSchools(year.id);
    if (!mounted || !_isEad || token != _eadSearchToken) return;

    final match = _findEadSchool();
    if (match == null) {
      setState(() {
        _isLoading = false;
        _hasAppliedFilters = true;
        _notices = [];
      });
      return;
    }

    setState(() {
      _selectedCity = match.city;
      _selectedUnit = match.unit;
      _currentUnits = widget.presenter.getUnitsForCity(match.city.id);
      _units = _currentUnits
          .map((s) => _NoticeFilterOption(id: s.id, label: s.name ?? ''))
          .toList();
    });

    final notices = await widget.presenter.fetchNotices(
      year: year.id,
      city: match.city.id.split(' - ').first,
      schoolId: match.unit.id,
      educationLevel: EducationLevel.higher,
    );

    if (!mounted || !_isEad || token != _eadSearchToken) return;

    setState(() {
      _notices = notices;
      _isLoading = false;
      _hasAppliedFilters = true;
    });
  }

  void _onYearChanged(_NoticeFilterOption? value) {
    setState(() {
      _selectedYear = value;
      _schoolsError = null;
      _cities = [];
      _units = [];
      _currentUnits = [];

      if (_isEad) {
        _selectedCity = const _NoticeFilterOption(
          id: AppConstants.eadCityLabel,
          label: AppConstants.eadCityDisplayLabel,
        );
        _selectedUnit = const _NoticeFilterOption(
          id: AppConstants.eadUnitLabel,
          label: AppConstants.eadUnitDisplayLabel,
        );
        _selectedEducationLevel = EducationLevel.higher;
      } else {
        _selectedCity = null;
        _selectedUnit = null;
        _selectedEducationLevel = null;
      }
    });
    _clearResults();

    if (value == null) return;

    if (_isEad) {
      _runEadSearch();
    } else {
      widget.presenter.loadSchools(value.id);
    }
  }

  void _onCityChanged(_NoticeFilterOption? value) {
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
            .map((s) => _NoticeFilterOption(id: s.id, label: s.name ?? ''))
            .toList();
      });
    }
    _applyFiltersIfComplete();
  }

  void _onUnitChanged(_NoticeFilterOption? value) {
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
    _applyFiltersIfComplete();
  }

  void _onEadChanged(bool value) {
    if (value) {
      setState(() {
        _isEad = true;
        _selectedEducationLevel = EducationLevel.higher;
        _selectedCity = const _NoticeFilterOption(
          id: AppConstants.eadCityLabel,
          label: AppConstants.eadCityDisplayLabel,
        );
        _selectedUnit = const _NoticeFilterOption(
          id: AppConstants.eadUnitLabel,
          label: AppConstants.eadUnitDisplayLabel,
        );
      });
      _clearResults();
      if (_selectedYear != null) {
        _runEadSearch();
      }
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
    });
    _clearResults();
  }

  void _applyFilters() {
    if (!_areFiltersComplete || _isEad) return;

    setState(() {
      _hasAppliedFilters = true;
      _isLoading = true;
    });
    widget.presenter.fetchNotices(
      year: _selectedYear!.id,
      city: _selectedCity!.id.split(' - ').first,
      schoolId: _selectedUnit!.id,
      educationLevel: _selectedEducationLevel,
    );
  }

  Future<void> _requestLocationPermission() async {
    final appStrings = AppI18n.current;
    final status = await Permission.locationWhenInUse.request();

    if (!mounted) return;

    setState(() {
      if (status.isGranted) {
        _locationMessage = null;
      } else if (status.isPermanentlyDenied) {
        _locationMessage = appStrings.noticesTermsLocationDeniedPermanently;
      } else {
        _locationMessage = appStrings.noticesTermsLocationDenied;
      }
    });
  }

  void _clearResults() {
    widget.presenter.clearNotices();
    setState(() {
      _hasAppliedFilters = false;
      _isLoading = false;
      _notices = [];
    });
  }

  void _applyFiltersIfComplete() {
    if (_areFiltersComplete) {
      _applyFilters();
    }
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

  Future<void> _openYearSelector() async {
    final appStrings = AppI18n.current;
    final selected =
        await SearchableOptionsBottomSheet.show<_NoticeFilterOption>(
      context: context,
      title: appStrings.noticesTermsSelectYear,
      options: _years,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _selectedYear,
      labelBuilder: (item) => item.label,
      searchTextBuilder: (item) => item.label,
    );
    if (selected != null) _onYearChanged(selected);
  }

  Future<void> _openCitySelector() async {
    if (_isEad || _selectedYear == null) return;
    final appStrings = AppI18n.current;
    final selected =
        await SearchableOptionsBottomSheet.show<_NoticeFilterOption>(
      context: context,
      title: appStrings.noticesTermsSelectCity,
      options: _availableCities,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _selectedCity,
      labelBuilder: (item) => item.label,
      searchTextBuilder: (item) => item.label,
    );
    if (selected != null) _onCityChanged(selected);
  }

  Future<void> _openUnitSelector() async {
    if (_isEad || _selectedCity == null) return;
    final appStrings = AppI18n.current;
    final selected =
        await SearchableOptionsBottomSheet.show<_NoticeFilterOption>(
      context: context,
      title: appStrings.noticesTermsSelectUnit,
      options: _availableUnits,
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

  Widget _buildSelectorField({
    required String hint,
    required _NoticeFilterOption? value,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    final textStyle = value == null
        ? AppTextStyles.ebolsaBodyLargeOutline
        : AppTextStyles.ebolsaBodyLarge;

    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          // Mantém o texto legível quando o campo está bloqueado com valor (EAD).
          enabled: enabled || value != null,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
        ),
        child: Text(
          value?.label ?? hint,
          style: textStyle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(
                appStrings.noticesTermsTitle,
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
              iconTheme: const IconThemeData(color: Colors.white),
            )
          : null,
      body: SingleChildScrollView(
        child: Padding(
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

              if (_locationMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _locationMessage!,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              /// YEAR FILTER
              _buildSelectorField(
                hint: appStrings.noticesTermsSelectYear,
                value: _selectedYear,
                enabled: true,
                onTap: _openYearSelector,
              ),
              const SizedBox(height: 16),

              if (_schoolsError != null) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: EbolsaErrorBanner(message: _schoolsError!),
                ),
                const SizedBox(height: 8),
              ],

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
                /// CITY FILTER
                _buildSelectorField(
                  hint: appStrings.noticesTermsSelectCity,
                  value: _selectedCity,
                  enabled: _selectedYear != null &&
                      _availableCities.isNotEmpty &&
                      !_isLoadingSchools,
                  onTap: _openCitySelector,
                ),
                const SizedBox(height: 16),

                /// UNIT FILTER
                _buildSelectorField(
                  hint: appStrings.noticesTermsSelectUnit,
                  value: _selectedUnit,
                  enabled: _selectedCity != null && _availableUnits.isNotEmpty,
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
              const SizedBox(height: 32),

              if (_isEad && _selectedYear == null)
                Text(
                  appStrings.noticesTermsIncompleteFiltersMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                )
              else if (!_areFiltersComplete && !_isEad)
                Text(
                  appStrings.noticesTermsIncompleteFiltersMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                )
              else if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_hasAppliedFilters && _notices.isEmpty)
                EBolsaWarningBanner(
                  title: appStrings.noticesTermsNoResultsTitle,
                  message: appStrings.noticesTermsNoResultsMessage,
                )
              else if (_hasAppliedFilters)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _notices.length,
                  itemBuilder: (context, index) {
                    final notice = _notices[index];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (notice.additiveTerms.isNotEmpty)
                          ...notice.additiveTerms.map(
                            (term) => AdditiveTermCard(
                              additiveTerm: term,
                              onViewPressed: () {
                                _openDocument(
                                  announcementId: term.id,
                                  title: term.title,
                                );
                              },
                            ),
                          ),
                        NoticeCard(
                          notice: notice,
                          onViewPressed: () {
                            _openDocument(
                              announcementId: notice.id,
                              title: notice.title,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
