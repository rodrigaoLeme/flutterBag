import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../domain/entities/notice_entity.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../components/additive_term_card.dart';
import '../../components/notice_card.dart';
import '../../components/searchable_options_bottom_sheet.dart';
import '../../helpers/themes/app_colors.dart';
import '../../helpers/themes/app_text_styles.dart';
import 'notice_document_page.dart';
import 'notices_terms_presenter.dart';

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

  const NoticesTermsPage({
    super.key,
    required this.presenter,
  });

  @override
  State<NoticesTermsPage> createState() => _NoticesTermsPageState();
}

class _NoticesTermsPageState extends State<NoticesTermsPage> {
  late StreamSubscription<List<NoticeEntity>> _noticesSubscription;
  List<NoticeEntity> _notices = [];
  bool _hasAppliedFilters = false;
  bool _isLoading = false;
  String? _locationMessage;

  _NoticeFilterOption? _selectedYear;
  _NoticeFilterOption? _selectedCity;
  _NoticeFilterOption? _selectedUnit;

  final List<_NoticeFilterOption> _years = const [
    _NoticeFilterOption(id: '2026', label: '2026'),
    _NoticeFilterOption(id: '2025', label: '2025'),
    _NoticeFilterOption(id: '2024', label: '2024'),
    _NoticeFilterOption(id: '2023', label: '2023'),
  ];

  final Map<String, List<_NoticeFilterOption>> _citiesByYear = {
    '2026': const [
      _NoticeFilterOption(
        id: 'Engenheiro Coelho - SP',
        label: 'Engenheiro Coelho - SP',
      ),
      _NoticeFilterOption(id: 'São Paulo - SP', label: 'São Paulo - SP'),
    ],
    '2025': const [
      _NoticeFilterOption(
        id: 'Engenheiro Coelho - SP',
        label: 'Engenheiro Coelho - SP',
      ),
      _NoticeFilterOption(
          id: 'Rio de Janeiro - RJ', label: 'Rio de Janeiro - RJ'),
    ],
    '2024': const [
      _NoticeFilterOption(id: 'São Paulo - SP', label: 'São Paulo - SP'),
    ],
    '2023': const [
      _NoticeFilterOption(
          id: 'Rio de Janeiro - RJ', label: 'Rio de Janeiro - RJ'),
    ],
  };

  final Map<String, List<_NoticeFilterOption>> _unitsByCity = {
    'Engenheiro Coelho - SP': const [
      _NoticeFilterOption(id: 'UNASP - EC', label: 'UNASP - EC'),
    ],
    'São Paulo - SP': const [
      _NoticeFilterOption(id: 'UNASP - SP', label: 'UNASP - SP'),
    ],
    'Rio de Janeiro - RJ': const [
      _NoticeFilterOption(
        id: 'Colégio Adventista - RJ',
        label: 'Colégio Adventista - RJ',
      ),
    ],
  };

  List<_NoticeFilterOption> get _availableCities =>
      _selectedYear == null ? [] : (_citiesByYear[_selectedYear!.id] ?? []);

  List<_NoticeFilterOption> get _availableUnits =>
      _selectedCity == null ? [] : (_unitsByCity[_selectedCity!.id] ?? []);

  bool get _areFiltersComplete =>
      _selectedYear != null && _selectedCity != null && _selectedUnit != null;

  @override
  void initState() {
    super.initState();
    _subscribeToNotices();
    _requestLocationPermission();
  }

  void _subscribeToNotices() {
    _noticesSubscription = widget.presenter.noticesStream.listen((notices) {
      if (mounted) {
        setState(() {
          _notices = notices;
          _isLoading = false;
        });
      }
    });
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

  void _onYearChanged(_NoticeFilterOption? value) {
    setState(() {
      _selectedYear = value;
      _selectedCity = null;
      _selectedUnit = null;
    });
    _clearResults();
    _applyFiltersIfComplete();
  }

  void _onCityChanged(_NoticeFilterOption? value) {
    setState(() {
      _selectedCity = value;
      _selectedUnit = null;
    });
    _clearResults();
    _applyFiltersIfComplete();
  }

  void _onUnitChanged(_NoticeFilterOption? value) {
    setState(() {
      _selectedUnit = value;
    });
    _clearResults();
    _applyFiltersIfComplete();
  }

  void _applyFiltersIfComplete() {
    if (_areFiltersComplete) {
      _applyFilters();
    }
  }

  void _applyFilters() {
    if (_areFiltersComplete) {
      setState(() {
        _hasAppliedFilters = true;
        _isLoading = true;
      });
      widget.presenter.fetchNotices(
        year: _selectedYear!.id,
        city: _selectedCity!.id,
        unit: _selectedUnit!.id,
      );
    }
  }

  void _openDocument({required String title, required String description}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoticeDocumentPage(
          title: title,
          description: description,
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
    if (_selectedYear == null) return;
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
    if (_selectedCity == null) return;
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
          enabled: enabled,
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
  void dispose() {
    _noticesSubscription.cancel();
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appStrings.noticesTermsTitle,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
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

              /// CITY FILTER
              _buildSelectorField(
                hint: appStrings.noticesTermsSelectCity,
                value: _selectedCity,
                enabled: _selectedYear != null && _availableCities.isNotEmpty,
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
              const SizedBox(height: 32),

              if (!_areFiltersComplete)
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
                Text(
                  appStrings.noticesTermsNoResultsMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
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
                        NoticeCard(
                          notice: notice,
                          onViewPressed: () {
                            _openDocument(
                              title: notice.name,
                              description: appStrings
                                  .noticesTermsDocumentNoticeDescription,
                            );
                          },
                        ),
                        if (notice.additiveTerms != null &&
                            notice.additiveTerms!.isNotEmpty)
                          ...notice.additiveTerms!.map(
                            (term) => AdditiveTermCard(
                              additiveTerm: term,
                              onViewPressed: () {
                                _openDocument(
                                  title: term.name,
                                  description: appStrings
                                      .noticesTermsDocumentAdditiveTermDescription,
                                );
                              },
                            ),
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
