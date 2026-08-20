import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../domain/entities/available_announcement_entity.dart';
import '../../../domain/entities/family_member_entity.dart';
import '../../../domain/helpers/app_constants.dart';
import '../../../main/factories/pages/new_scholarship_request/new_scholarship_request_presenter_factory.dart';
import '../../../main/factories/usecases/schools/load_school_grades_factory.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../main/routes/routes.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'dev_navigation_overrides.dart';
import 'new_scholarship_request_presenter.dart';
import 'steps/candidate/candidate_add_page.dart';
import 'steps/candidate/candidate_step.dart';
import 'steps/documents/document_group_detail_page.dart';
import 'steps/documents/document_group_item.dart';
import 'steps/documents/documents_step.dart';
import 'steps/expenses/expenses_step.dart';
import 'steps/family/family_step.dart';
import 'steps/family/member_registration_page.dart';
import 'steps/housing/housing_step.dart';
import 'widgets/scholarship_step_indicator.dart';

class NewScholarshipRequestPage extends StatefulWidget {
  final NewScholarshipRequestPresenter? presenter;
  final String processPeriodId;
  final List<AnnouncementSchoolEntity> announcementSchools;
  final int? processYear;

  const NewScholarshipRequestPage({
    super.key,
    this.presenter,
    required this.processPeriodId,
    this.announcementSchools = const [],
    this.processYear,
  });

  @override
  State<NewScholarshipRequestPage> createState() =>
      _NewScholarshipRequestPageState();
}

class _NewScholarshipRequestPageState extends State<NewScholarshipRequestPage> {
  int _currentStep = 1;
  int _currentSubStep = 0;
  bool _isInitializing = true;

  late final NewScholarshipRequestPresenter _presenter;
  final GlobalKey<ExpensesStepState> _expensesStepKey =
      GlobalKey<ExpensesStepState>();
  final GlobalKey<CandidateStepState> _candidateStepKey =
      GlobalKey<CandidateStepState>();
  final GlobalKey<DocumentsStepState> _documentsStepKey =
      GlobalKey<DocumentsStepState>();

  List<Map<String, dynamic>> _registeredCandidates = [];
  final Map<String, Set<String>> _uploadedDocumentIds = {};

  static const int _totalSteps = 5;

  // ---------------------------------------------------------------------------
  // TODO(dev): ATALHO TEMPORÁRIO — documente/remova ao finalizar a tela Documentos
  // true  => no hot restart, abre direto na etapa 5 (Documentos)
  // false => fluxo normal (começar na etapa 1)
  // Só vale em debug (kDebugMode); release/prod ignoram.
  // ---------------------------------------------------------------------------
  static const bool _kDebugJumpToDocumentsStep = false;

  @override
  void initState() {
    super.initState();
    _presenter = widget.presenter ??
        makeNewRequestPresenter(processPeriodId: widget.processPeriodId);
    _presenter.stepSubSteps;
    _presenter.currentStepStream.listen((s) => setState(() {
          _currentStep = s;
          _isInitializing = false;
        }));
    _presenter.currentSubStepStream
        .listen((s) => setState(() => _currentSubStep = s));

    // TODO(dev): remover junto com `_kDebugJumpToDocumentsStep` acima
    if (kDebugMode && _kDebugJumpToDocumentsStep) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _presenter.goToStep(5);
      });
    }
  }

  void _goToStep(int step) {
    _presenter.goToStep(step);
  }

  void _handleNext() {
    if (DevNavigationOverrides.allowAdvanceWithoutFill) {
      _presenter.next();
      return;
    }

    if (_currentStep == 3 &&
        !_expensesStepKey.currentState!.validateCurrentSubStep()) {
      return;
    }
    if (_currentStep == 4) {
      _handleCandidateStepNext();
      return;
    }
    _presenter.next();
  }

  String _familyMemberId(FamilyMemberEntity member) =>
      member.id ?? member.personCpf ?? member.name ?? '';

  List<FamilyMemberEntity> _requiredScholarshipCandidates() =>
      _presenter.familyMembers.where((m) => m.isCandidate == true).toList();

  List<FamilyMemberEntity> _missingScholarshipCandidates() {
    final addedIds =
        _candidateStepKey.currentState?.addedMemberIds.toSet() ?? {};
    return _requiredScholarshipCandidates()
        .where((member) => !addedIds.contains(_familyMemberId(member)))
        .toList();
  }

  Future<void> _handleCandidateStepNext() async {
    final missing = _missingScholarshipCandidates();
    if (missing.isNotEmpty) {
      await _showMissingCandidatesDialog(missing);
      return;
    }

    final acknowledged = await _showCandidateAwarenessDialog();
    if (acknowledged == true && mounted) {
      _syncRegisteredCandidates();
      _presenter.next();
    }
  }

  void _syncRegisteredCandidates() {
    final stepCandidates = _candidateStepKey.currentState?.candidates;
    if (stepCandidates != null) {
      _registeredCandidates = List<Map<String, dynamic>>.from(stepCandidates);
    }
  }

  Future<void> _showMissingCandidatesDialog(
    List<FamilyMemberEntity> missing,
  ) async {
    final i18n = AppI18n.current;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                i18n.candidateMissingDialogIntro,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              for (final member in missing)
                Padding(
                  padding: const EdgeInsets.only(left: 8, bottom: 4),
                  child: Text(
                    '• ${member.personCpf ?? '-'} - ${member.name ?? ''}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              i18n.familyConfirmDialogReview,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showCandidateAwarenessDialog() {
    final i18n = AppI18n.current;

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '• ${i18n.candidateAwareDialogBullet1}',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            Text(
              '• ${i18n.candidateAwareDialogBullet2}',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              i18n.createAccountDialogDoneButton,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int get _processYear {
    if (widget.processYear != null) return widget.processYear!;
    final now = DateTime.now();
    return now.month >= AppConstants.initialMonthForEditalRelease
        ? now.year + 1
        : now.year;
  }

  List<CandidateFamilyMemberOption> _eligibleFamilyMembers() {
    return _requiredScholarshipCandidates()
        .map(
          (member) => CandidateFamilyMemberOption(
            id: _familyMemberId(member),
            name: member.name ?? '',
            cpf: member.personCpf,
          ),
        )
        .toList();
  }

  List<DocumentGroupItem> _buildDocumentGroups() {
    final i18n = AppI18n.current;
    final groups = <DocumentGroupItem>[
      DocumentGroupItem(
        id: 'family-group',
        title: i18n.familyInfoGroupTitle,
        type: DocumentGroupType.family,
        totalDocuments: 6,
      ),
    ];

    final candidates = _registeredCandidates;
    final candidateIds = <String>{};

    for (final candidate in candidates) {
      final id = candidate['familyMemberId']?.toString() ??
          candidate['name']?.toString() ??
          '';
      candidateIds.add(id);
      groups.add(
        DocumentGroupItem(
          id: id,
          title: candidate['name']?.toString() ?? '',
          type: DocumentGroupType.candidate,
          totalDocuments: 5,
        ),
      );
    }

    for (final member in _presenter.familyMembers) {
      final memberId = _familyMemberId(member);
      if (member.isCandidate == true || candidateIds.contains(memberId)) {
        continue;
      }

      groups.add(
        DocumentGroupItem(
          id: memberId,
          title: member.name ?? '',
          type: DocumentGroupType.member,
          totalDocuments: 3,
        ),
      );
    }

    if (groups.length == 1) {
      return _mockDocumentGroups();
    }

    return groups.map(_withUploadProgress).toList();
  }

  int _uploadedCount(String groupId) =>
      _uploadedDocumentIds[groupId]?.length ?? 0;

  DocumentGroupItem _withUploadProgress(DocumentGroupItem group) =>
      group.copyWith(uploadedDocuments: _uploadedCount(group.id));

  List<DocumentGroupItem> _mockDocumentGroups() {
    final i18n = AppI18n.current;

    return [
      DocumentGroupItem(
        id: 'family-group',
        title: i18n.familyInfoGroupTitle,
        type: DocumentGroupType.family,
        totalDocuments: 6,
      ),
      const DocumentGroupItem(
        id: 'candidate-ana',
        title: 'Ana Silva',
        type: DocumentGroupType.candidate,
        totalDocuments: 5,
      ),
      const DocumentGroupItem(
        id: 'candidate-andre',
        title: 'André Silva',
        type: DocumentGroupType.candidate,
        totalDocuments: 5,
      ),
      const DocumentGroupItem(
        id: 'member-maria',
        title: 'Maria Silva',
        type: DocumentGroupType.member,
        totalDocuments: 3,
      ),
      const DocumentGroupItem(
        id: 'member-joao',
        title: 'João Silva',
        type: DocumentGroupType.member,
        totalDocuments: 3,
      ),
    ].map(_withUploadProgress).toList();
  }

  DateTime? get _submissionDeadline => DateTime(2026, 4, 1);

  String? get _formattedSubmissionDeadline {
    final deadline = _submissionDeadline;
    if (deadline == null) return null;

    final day = deadline.day.toString().padLeft(2, '0');
    final month = deadline.month.toString().padLeft(2, '0');
    return '$day/$month/${deadline.year}';
  }

  void _sendAllDocuments() {
    // TODO: integrar envio de documentos com API
  }

  Future<void> _confirmDocumentsBack() async {
    final i18n = AppI18n.current;

    await EbolsaDialogWithCancel.show(
      context: context,
      title: i18n.familyConfirmDialogTitle,
      description:
          '${i18n.documentsBackDialogBody}\n\n${i18n.documentsBackDialogQuestion}',
      actions: [
        EbolsaDialogAction(
          label: i18n.answerNo,
          onPressed: () {},
        ),
        EbolsaDialogAction(
          label: i18n.documentsBackDialogConfirm,
          isDanger: true,
          onPressed: _presenter.previous,
        ),
      ],
    );
  }

  Future<void> _confirmDocumentsGoHome() async {
    final i18n = AppI18n.current;
    final deadline = _formattedSubmissionDeadline;
    if (deadline == null) return;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: Text.rich(
          TextSpan(
            style: AppTextStyles.bodyMedium,
            children: [
              TextSpan(text: i18n.documentsHomeDialogBodyPrefix),
              TextSpan(
                text: deadline,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextSpan(text: i18n.documentsHomeDialogBodySuffix),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Modular.to.navigate(Routes.home);
            },
            child: Text(
              i18n.documentsHomeDialogConfirm,
              style: AppTextStyles.m3LabelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAppBarBackPressed() {
    if (_currentStep == 5) {
      _confirmDocumentsBack();
      return;
    }
    if (_currentStep > 1) {
      _presenter.previous();
      return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _openDocumentGroupDetail(DocumentGroupItem group) async {
    final groups = _buildDocumentGroups();
    final index = groups.indexWhere((item) => item.id == group.id);
    if (index < 0) return;

    final result = await Navigator.of(context).push<Map<String, Set<String>>>(
      MaterialPageRoute(
        builder: (_) => DocumentGroupDetailPage(
          groups: groups,
          initialIndex: index,
          submissionDeadline: _submissionDeadline,
          uploadedIdsByGroup: {
            for (final entry in _uploadedDocumentIds.entries)
              entry.key: Set<String>.from(entry.value),
          },
        ),
      ),
    );

    if (result == null || !mounted) return;
    setState(() {
      for (final entry in result.entries) {
        _uploadedDocumentIds[entry.key] = Set<String>.from(entry.value);
      }
    });
  }

  Future<void> _openCandidateAddPage(
      {Map<String, dynamic>? initialData}) async {
    final result = await Navigator.of(context).push<Map<String, dynamic>?>(
      MaterialPageRoute(
        builder: (_) => CandidateAddPage(
          eligibleMembers: _eligibleFamilyMembers(),
          announcementSchools: widget.announcementSchools,
          processYear: _processYear,
          loadSchoolGradesUsecase: makeRemoteLoadSchoolGrades(),
          excludedMemberIds: _candidateStepKey.currentState?.addedMemberIds
                  .where(
                    (id) => id != initialData?['familyMemberId']?.toString(),
                  )
                  .toList() ??
              const [],
          initialData: initialData,
        ),
      ),
    );

    if (!mounted || result == null) return;

    if (initialData != null) {
      _candidateStepKey.currentState?.updateCandidate(result);
    } else {
      _candidateStepKey.currentState?.addCandidate(result);
    }
    _syncRegisteredCandidates();
    setState(() {});
  }

  bool _canAdvanceCurrentStep() {
    if (DevNavigationOverrides.allowAdvanceWithoutFill) return true;

    switch (_currentStep) {
      case 1:
        return _presenter.isStep1Complete();
      case 2:
        return _presenter.familyMembers.isNotEmpty;
      case 3:
        return _expensesStepKey.currentState?.canAdvanceCurrentSubStep() ??
            false;
      default:
        return true;
    }
  }

  Widget _buildReactiveStepFooter() {
    if (_currentStep == 1) {
      return ListenableBuilder(
        listenable: Listenable.merge([
          _presenter.cepListenable,
          _presenter.numberListenable,
          _presenter.addressListenable,
          _presenter.neighborhoodListenable,
          _presenter.cityListenable,
          _presenter.stateListenable,
          _presenter.residenceAreaListenable,
          _presenter.housingTypeListenable,
        ]),
        builder: (context, _) => _buildStepFooter(),
      );
    }

    return _buildStepFooter();
  }

  Widget _buildStepFooter() {
    if (_currentStep == 5) {
      final canSend =
          _documentsStepKey.currentState?.canSendAllDocuments ?? false;

      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _confirmDocumentsBack,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFFB9BDC6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Voltar',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: EbolsaButton(
                onPressed: canSend ? _sendAllDocuments : null,
                label: AppI18n.current.documentsSendAllAction,
              ),
            ),
          ],
        ),
      );
    }

    if (_currentStep == 2 || _currentStep == 3 || _currentStep == 4) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _presenter.previous,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFFB9BDC6)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  'Voltar',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: EbolsaButton(
                onPressed: _canAdvanceCurrentStep() ? _handleNext : null,
                label: 'Avançar',
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: EbolsaButton(
        onPressed: _canAdvanceCurrentStep()
            ? () {
                if (_currentStep == 1) {
                  _presenter.submitStep1();
                } else {
                  _presenter.next();
                }
              }
            : null,
        label: _currentStep < _totalSteps ? 'Avançar' : 'Finalizar',
        isSecondary: false,
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return ValueListenableBuilder<Map<String, String?>>(
          valueListenable: _presenter.fieldErrorsListenable,
          builder: (context, errors, _) {
            return HousingStep(
              currentSubStep: _currentSubStep,
              cepController: _presenter.cepController,
              numberController: _presenter.numberController,
              complementController: _presenter.complementController,
              addressController: _presenter.addressController,
              neighborhoodController: _presenter.neighborhoodController,
              cityController: _presenter.cityController,
              stateListenable: _presenter.stateListenable,
              residenceAreaListenable: _presenter.residenceAreaListenable,
              housingTypeListenable: _presenter.housingTypeListenable,
              onStateChanged: _presenter.updateStateValue,
              onResidenceAreaChanged: _presenter.updateResidenceArea,
              onHousingTypeChanged: (v) => _presenter.updateHousingTypeEnum(v),
              onZipCodeComplete: _presenter.lookupZipCode,
              onClearAddressFields: _presenter.clearAddressFields,
              cepError: errors['cep'],
              numberError: errors['number'],
              addressError: errors['address'],
              neighborhoodError: errors['neighborhood'],
              cityError: errors['city'],
              stateError: errors['state'],
              residenceAreaError: errors['residenceArea'],
              housingTypeError: errors['housingType'],
              isPopulating: _presenter.isPopulating,
            );
          },
        );

      case 2:
        return FamilyStep(
          currentSubStep: _currentSubStep,
          onAddMember: () async {
            final result = await Navigator.of(context).push<Object?>(
              MaterialPageRoute(
                builder: (_) => MemberRegistrationPage(
                  scholarshipId: _presenter.form.id ?? '',
                  processPeriodId: widget.processPeriodId,
                  initialFamilyMembers: _presenter.form.familyMembers,
                ),
              ),
            );
            if (!mounted) return;
            if (result == kAdvanceToExpensesResult) {
              _presenter.goToStep(3);
              return;
            }
            setState(() {});
          },
        );

      case 3:
        return ExpensesStep(
          key: _expensesStepKey,
          currentSubStep: _currentSubStep,
          onPrevious: _presenter.previous,
          onNext: _handleNext,
          onFormChanged: () => setState(() {}),
        );

      case 4:
        return CandidateStep(
          key: _candidateStepKey,
          onCandidatesChanged: () {
            _syncRegisteredCandidates();
            setState(() {});
          },
          onAddCandidate: _openCandidateAddPage,
          onEditCandidate: (candidate) =>
              _openCandidateAddPage(initialData: candidate),
        );

      case 5:
        return DocumentsStep(
          key: _documentsStepKey,
          groups: _buildDocumentGroups(),
          submissionDeadline: _submissionDeadline,
          onGroupTap: _openDocumentGroupDetail,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDocumentsStep = _currentStep == 5;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: _onAppBarBackPressed,
        ),
        title: Text(
          isDocumentsStep
              ? AppI18n.current.documentsStepTitle
              : AppI18n.current.newProcess,
        ),
        centerTitle: true,
        actions: [
          if (isDocumentsStep)
            IconButton(
              onPressed: _confirmDocumentsGoHome,
              icon: SvgPicture.asset(
                AppIcons.houseIcon,
                width: 24,
                height: 24,
                color: Colors.white,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: ValueListenableBuilder<int>(
                  valueListenable: _presenter.completedStepListenable,
                  builder: (context, completedStep, _) {
                    return ScholarshipStepIndicator(
                      currentStep: _currentStep,
                      completedStep: completedStep,
                      onStepTap: _goToStep,
                    );
                  }),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: _buildCurrentStep(),
              ),
            ),
            StreamBuilder<String?>(
              stream: _presenter.uiErrorStream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: EbolsaErrorBanner(message: snapshot.data!),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            _buildReactiveStepFooter(),
          ],
        ),
      ),
    );
  }
}
