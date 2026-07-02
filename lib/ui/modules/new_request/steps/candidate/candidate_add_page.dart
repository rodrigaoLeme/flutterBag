import 'package:flutter/material.dart';

import '../../../../../domain/entities/available_announcement_entity.dart';
import '../../../../../domain/entities/enrollment_enums.dart';
import '../../../../../domain/entities/school_grade_entity.dart';
import '../../../../../domain/usecases/schools/load_school_grades.dart';
import '../../../../../infra/repositories/schools/remote_load_school_grades_usecase.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/searchable_options_bottom_sheet.dart';
import '../../../../helpers/themes/themes.dart';
import '../../widgets/scholarship_step_indicator.dart';

class CandidateFamilyMemberOption {
  final String id;
  final String name;
  final String? cpf;

  const CandidateFamilyMemberOption({
    required this.id,
    required this.name,
    this.cpf,
  });
}

class CandidateAddPage extends StatefulWidget {
  final List<CandidateFamilyMemberOption> eligibleMembers;
  final List<AnnouncementSchoolEntity> announcementSchools;
  final List<String> excludedMemberIds;
  final int processYear;
  final LoadSchoolGradesUsecase loadSchoolGradesUsecase;
  final Map<String, dynamic>? initialData;

  const CandidateAddPage({
    super.key,
    required this.eligibleMembers,
    required this.announcementSchools,
    required this.processYear,
    required this.loadSchoolGradesUsecase,
    this.excludedMemberIds = const [],
    this.initialData,
  });

  @override
  State<CandidateAddPage> createState() => _CandidateAddPageState();
}

class _CandidateAddPageState extends State<CandidateAddPage> {
  CandidateFamilyMemberOption? _selectedMember;
  GuardianRelationshipType? _selectedRelationship;
  AnnouncementSchoolEntity? _selectedSchool;
  SchoolGradeEntity? _selectedGrade;

  List<SchoolGradeEntity> _grades = [];
  bool _isLoadingGrades = false;
  String? _gradesError;

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

  void _restoreInitialData() {
    final data = widget.initialData;
    if (data == null) return;

    final memberId = data['familyMemberId']?.toString();
    try {
      _selectedMember =
          widget.eligibleMembers.firstWhere((m) => m.id == memberId);
    } catch (_) {}

    _selectedRelationship =
        GuardianRelationshipType.fromValue(data['guardianRelationship'] as int?);

    final schoolId = data['schoolId']?.toString();
    try {
      _selectedSchool =
          widget.announcementSchools.firstWhere((s) => s.id == schoolId);
    } catch (_) {}

    if (_selectedSchool != null) {
      _loadGrades(_selectedSchool!.id, preselectGradeId: data['gradeId']);
    }
  }

  bool get _canSave => !_isLoadingGrades;

  Future<void> _loadGrades(
    String schoolId, {
    String? preselectGradeId,
  }) async {
    setState(() {
      _isLoadingGrades = true;
      _gradesError = null;
      _grades = [];
      if (preselectGradeId == null) {
        _selectedGrade = null;
      }
    });

    try {
      final grades = await widget.loadSchoolGradesUsecase.load(
        LoadSchoolGradesParams(
          schoolId: schoolId,
          year: widget.processYear,
        ),
      );

      if (!mounted) return;

      setState(() {
        _grades = grades;
        _isLoadingGrades = false;
        if (preselectGradeId != null) {
          try {
            _selectedGrade =
                grades.firstWhere((g) => g.id == preselectGradeId);
          } catch (_) {}
        }
      });
    } on LoadSchoolGradesException catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingGrades = false;
        _gradesError = e.message;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _isLoadingGrades = false;
        _gradesError = AppI18n.current.errorUnexpected;
      });
    }
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
    final options = [
      i18n.guardianRelationshipFather,
      i18n.guardianRelationshipMother,
      i18n.guardianRelationshipGuardianship,
    ];

    final selectedLabel = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.guardianRelationshipLabel,
      options: options,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedRelationship != null
          ? _relationshipLabel(_selectedRelationship!)
          : null,
    );

    if (selectedLabel == null) return;

    setState(() {
      _selectedRelationship = _relationshipFromLabel(selectedLabel);
    });
  }

  String _relationshipLabel(GuardianRelationshipType type) {
    final i18n = AppI18n.current;
    return switch (type) {
      GuardianRelationshipType.father => i18n.guardianRelationshipFather,
      GuardianRelationshipType.mother => i18n.guardianRelationshipMother,
      GuardianRelationshipType.legalGuardian =>
        i18n.guardianRelationshipGuardianship,
    };
  }

  GuardianRelationshipType? _relationshipFromLabel(String label) {
    final i18n = AppI18n.current;
    if (label == i18n.guardianRelationshipFather) {
      return GuardianRelationshipType.father;
    }
    if (label == i18n.guardianRelationshipMother) {
      return GuardianRelationshipType.mother;
    }
    if (label == i18n.guardianRelationshipGuardianship) {
      return GuardianRelationshipType.legalGuardian;
    }
    return null;
  }

  Future<void> _openSchoolSelector() async {
    final i18n = AppI18n.current;
    final options =
        widget.announcementSchools.map((s) => s.name ?? s.id).toList();

    final selectedName = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.unitOfInterestLabel,
      options: options,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedSchool?.name ?? _selectedSchool?.id,
    );

    if (selectedName == null) return;

    final school = widget.announcementSchools.firstWhere(
      (s) => (s.name ?? s.id) == selectedName,
    );

    setState(() {
      _selectedSchool = school;
      _selectedGrade = null;
      _grades = [];
    });

    await _loadGrades(school.id);
  }

  Future<void> _openGradeSelector() async {
    if (_selectedSchool == null || _grades.isEmpty) return;

    final i18n = AppI18n.current;
    final options = _grades.map((g) => g.displayName).toList();

    final selectedName = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.intendedCourseLabel(widget.processYear),
      options: options,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedGrade?.displayName,
    );

    if (selectedName == null) return;

    setState(() {
      _selectedGrade = _grades.firstWhere((g) => g.displayName == selectedName);
    });
  }

  void _saveAndReturn() {
    if (_isLoadingGrades) return;

    Navigator.of(context).pop({
      'familyMemberId':
          _selectedMember?.id ?? 'mock-member-${DateTime.now().millisecondsSinceEpoch}',
      'name': _selectedMember?.name ?? 'Candidato',
      'cpf': _selectedMember?.cpf,
      'guardianRelationship': _selectedRelationship?.value,
      'guardianRelationshipLabel': _selectedRelationship != null
          ? _relationshipLabel(_selectedRelationship!)
          : null,
      'schoolId': _selectedSchool?.id ?? 'mock-school-id',
      'schoolName': _selectedSchool?.name,
      'gradeId': _selectedGrade?.id ?? 'mock-grade-id',
      'gradeName': _selectedGrade?.displayName,
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
                      color:
                          enabled ? AppColors.onSurface : AppColors.outline,
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      onTap: _availableMembers.isEmpty ? null : _openMemberSelector,
                      enabled: _availableMembers.isNotEmpty,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectorField(
                      hint: i18n.guardianRelationshipLabel,
                      value: _selectedRelationship != null
                          ? _relationshipLabel(_selectedRelationship!)
                          : null,
                      onTap: _openRelationshipSelector,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectorField(
                      hint: i18n.unitOfInterestLabel,
                      value: _selectedSchool?.name ?? _selectedSchool?.id,
                      onTap: widget.announcementSchools.isEmpty
                          ? null
                          : _openSchoolSelector,
                      enabled: widget.announcementSchools.isNotEmpty,
                    ),
                    const SizedBox(height: 12),
                    _buildSelectorField(
                      hint: i18n.intendedCourseLabel(widget.processYear),
                      value: _isLoadingGrades
                          ? null
                          : _selectedGrade?.displayName,
                      onTap: _selectedSchool != null &&
                              !_isLoadingGrades &&
                              _grades.isNotEmpty
                          ? _openGradeSelector
                          : null,
                      enabled: _selectedSchool != null &&
                          !_isLoadingGrades &&
                          _grades.isNotEmpty,
                    ),
                    if (_isLoadingGrades) ...[
                      const SizedBox(height: 12),
                      const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ],
                    if (_gradesError != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _gradesError!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
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
                      color: _canSave ? Colors.white : AppColors.outline,
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
