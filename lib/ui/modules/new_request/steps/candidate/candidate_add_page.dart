import 'package:flutter/material.dart';

import '../../../../../domain/entities/academic_course_entity.dart';
import '../../../../../domain/entities/enrollment_enums.dart';
import '../../../../../domain/entities/school_entity.dart';
import '../../../../../domain/usecases/candidate/load_academic_courses_usecase.dart';
import '../../../../../main/factories/usecases/enrollment/enrollment_usecase_factories.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/searchable_options_bottom_sheet.dart';
import '../../../../helpers/themes/themes.dart';
import '../../widgets/scholarship_step_indicator.dart';

class CandidateFamilyMemberOption {
  final String id;
  final String name;
  final String? cpf;
  final DateTime? birthDate;

  const CandidateFamilyMemberOption({
    required this.id,
    required this.name,
    this.cpf,
    this.birthDate,
  });
}

class CandidateAddPage extends StatefulWidget {
  final List<CandidateFamilyMemberOption> eligibleMembers;
  final List<SchoolEntity> schools;
  final List<String> excludedMemberIds;
  final int processYear;
  final Map<String, dynamic>? initialData;
  final String processPeriodId;
  final bool isHigherEducation;

  const CandidateAddPage({
    super.key,
    required this.eligibleMembers,
    required this.schools,
    required this.processYear,
    required this.processPeriodId,
    required this.isHigherEducation,
    this.excludedMemberIds = const [],
    this.initialData,
  });

  @override
  State<CandidateAddPage> createState() => _CandidateAddPageState();
}

class _CandidateAddPageState extends State<CandidateAddPage> {
  final _loadCourses = makeRemoteLoadAcademicCourses();

  SchoolEntity? _selectedSchool;
  AcademicCourseEntity? _selectedCourse;
  List<AcademicCourseEntity> _courses = [];
  bool _isLoadingCourses = false;
  CandidateFamilyMemberOption? _selectedMember;
  GuardianRelationshipType? _selectedRelationship;

  List<SchoolEntity> get _schools => widget.schools;

  List<CandidateFamilyMemberOption> get _availableMembers {
    if (widget.initialData != null) {
      return widget.eligibleMembers;
    }
    return widget.eligibleMembers
        .where((m) => !widget.excludedMemberIds.contains(m.id))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _restoreInitialData();
  }

  Future<void> _onSchoolSelected(SchoolEntity school) async {
    setState(() {
      _selectedSchool = school;
      _selectedCourse = null;
      _courses = [];
      _isLoadingCourses = true;
    });

    try {
      final courses = await _loadCourses.load(LoadAcademicCoursesParams(
        processPeriodId: widget.processPeriodId,
        schoolId: school.id,
      ));
      if (!mounted) return;
      setState(() {
        _courses = courses;
        _isLoadingCourses = false;
      });
    } on LoadAcademicCoursesException catch (e) {
      if (!mounted) return;
      setState(() => _isLoadingCourses = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  void _restoreInitialData() {
    final data = widget.initialData;
    if (data == null) return;

    final memberId = data['familyMemberId']?.toString();
    try {
      _selectedMember =
          widget.eligibleMembers.firstWhere((m) => m.id == memberId);
    } catch (_) {}

    _selectedRelationship = GuardianRelationshipType.fromValue(
        data['guardianRelationship'] as int?);

    final schoolId = data['schoolId']?.toString();
    try {
      _selectedSchool = _schools.firstWhere((s) => s.id == schoolId);
    } catch (_) {}
  }

  Future<void> _openMemberSelector() async {
    final i18n = AppI18n.current;
    final options = _availableMembers.map((m) => m.name).toList();

    final selectedName = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.selectCandidateLabel,
      options: options,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedMember?.name,
      showSearchInput: false,
    );

    if (selectedName == null) return;

    setState(() {
      _selectedMember = _availableMembers.firstWhere(
        (m) => m.name == selectedName,
      );
    });
  }

  Future<void> _openRelationshipSelector() async {
    final i18n = AppI18n.current;
    final options = GuardianRelationshipType.values
        .where((t) =>
            t != GuardianRelationshipType.candidate || widget.isHigherEducation)
        .toList();

    final selected =
        await SearchableOptionsBottomSheet.show<GuardianRelationshipType>(
      context: context,
      title: i18n.guardianRelationshipLabel,
      options: options,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedRelationship,
      labelBuilder: (t) => t.label,
      searchTextBuilder: (t) => t.label,
      showSearchInput: false,
    );

    if (selected != null) setState(() => _selectedRelationship = selected);
  }

  Future<void> _openSchoolSelector() async {
    final i18n = AppI18n.current;

    final selected = await SearchableOptionsBottomSheet.show<SchoolEntity>(
      context: context,
      title: i18n.unitOfInterestLabel,
      options: _schools,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedSchool,
      labelBuilder: (s) => s.displayName,
      searchTextBuilder: (s) => s.displayName,
    );

    if (selected != null) await _onSchoolSelected(selected);
  }

  Future<void> _openCourseSelector() async {
    if (_isLoadingCourses || _courses.isEmpty) return;

    final i18n = AppI18n.current;

    final selected =
        await SearchableOptionsBottomSheet.show<AcademicCourseEntity>(
      context: context,
      title: i18n.intendedCourseLabel(widget.processYear),
      options: _courses,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedCourse,
      labelBuilder: (c) => c.name ?? '',
      showSearchInput: false,
    );

    if (selected != null) setState(() => _selectedCourse = selected);
  }

  bool get _canSave =>
      _selectedMember != null &&
      _selectedRelationship != null &&
      _selectedSchool != null &&
      _selectedCourse != null &&
      !_isLoadingCourses;

  void _saveAndReturn() {
    Navigator.of(context).pop({
      'familyMemberId': _selectedMember?.id ??
          'mock-member-${DateTime.now().millisecondsSinceEpoch}',
      'name': _selectedMember?.name ?? 'Candidato',
      'cpf': _selectedMember?.cpf,
      'guardianRelationship': _selectedRelationship?.value,
      'guardianRelationshipLabel': _selectedRelationship?.label,
      'schoolId': _selectedSchool?.id ?? 'mock-school-id',
      'schoolName': _selectedSchool?.name,
      'gradeId': _selectedCourse?.id ?? '',
      'gradeName': _selectedCourse?.name ?? '',
    });
  }

  Widget _buildSelectorField({
    required String hint,
    required String? value,
    required VoidCallback? onTap,
    bool enabled = true,
  }) {
    final isPlaceholder = value == null;

    return SizedBox(
      height: 56,
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          isEmpty: isPlaceholder,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 0,
            ),
            filled: true,
            fillColor: enabled ? Colors.white : AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryOutline),
            ),
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: enabled ? null : AppColors.outline,
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              value ?? hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: isPlaceholder
                  ? AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onSurface.withValues(alpha: 0.6),
                    )
                  : AppTextStyles.bodyMedium.copyWith(
                      color: enabled ? AppColors.onSurface : AppColors.outline,
                    ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(i18n.newProcess),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: ScholarshipStepIndicator(
                currentStep: 4,
                completedStep: 4,
                onStepTap: (_) {},
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(i18n.candidateStepTitle,
                        style: AppTextStyles.titleLarge),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(
                        style: AppTextStyles.bodyMedium,
                        children: [
                          TextSpan(text: i18n.candidateStepDescriptionPrefix),
                          TextSpan(
                            text: i18n.candidateStepDescriptionEmphasis,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: i18n.candidateStepDescriptionSuffix),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildSelectorField(
                      hint: i18n.selectCandidateLabel,
                      value: _selectedMember?.name,
                      onTap: _availableMembers.isEmpty
                          ? null
                          : _openMemberSelector,
                      enabled: _availableMembers.isNotEmpty,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectorField(
                      hint: i18n.guardianRelationshipLabel,
                      value: _selectedRelationship?.label,
                      onTap: _openRelationshipSelector,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectorField(
                      hint: i18n.unitOfInterestLabel,
                      value: _selectedSchool?.name ?? _selectedSchool?.id,
                      onTap: _openSchoolSelector,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectorField(
                      hint: i18n.intendedCourseLabel(widget.processYear),
                      value: _isLoadingCourses
                          ? 'Carregando...'
                          : _selectedCourse?.name,
                      onTap:
                          _selectedSchool == null ? null : _openCourseSelector,
                      enabled: _selectedSchool != null && !_isLoadingCourses,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _canSave ? _saveAndReturn : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _canSave ? AppColors.primary : AppColors.dividerLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: Text(
                    i18n.addCandidateAction,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
