import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../domain/entities/proof_slot_submission.dart';
import '../../../../../domain/entities/scholarship_proof_entity.dart';
import '../../../../../domain/usecases/documents/upload_proof_document_usecase.dart';
import '../../../../../main/factories/usecases/enrollment/enrollment_usecase_factories.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../../main/routes/routes.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';
import '../../widgets/scholarship_step_indicator.dart';
import '../family/widgets/member_registration_sub_step_nav.dart';
import 'document_group_item.dart';
import 'document_proof_preview_page.dart';
import 'document_proof_send_page.dart';

class DocumentGroupDetailPage extends StatefulWidget {
  final List<DocumentGroupItem> groups;
  final int initialIndex;
  final DateTime? submissionDeadline;
  final Map<String, List<ScholarshipProofEntity>> proofsByGroup;
  final String scholarshipId;
  final Future<Map<String, List<ScholarshipProofEntity>>> Function() onRefresh;

  const DocumentGroupDetailPage({
    super.key,
    required this.groups,
    required this.initialIndex,
    required this.scholarshipId,
    required this.onRefresh,
    this.submissionDeadline,
    this.proofsByGroup = const {},
  });

  @override
  State<DocumentGroupDetailPage> createState() =>
      _DocumentGroupDetailPageState();
}

class _DocumentGroupDetailPageState extends State<DocumentGroupDetailPage> {
  late int _currentIndex;
  late Map<String, List<ScholarshipProofEntity>> _proofsByGroup;
  final _uploadProofDocument = makeRemoteUploadProofDocument();

  DocumentGroupItem get _currentGroup => widget.groups[_currentIndex];

  List<ScholarshipProofEntity> get _currentProofs =>
      _proofsByGroup[_currentGroup.id] ?? const <ScholarshipProofEntity>[];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.groups.length - 1);
    _proofsByGroup = Map.of(widget.proofsByGroup);
  }

  void _popToDocuments() => Navigator.of(context).pop();

  String? get _formattedDeadline {
    final deadline = widget.submissionDeadline;
    if (deadline == null) return null;

    final day = deadline.day.toString().padLeft(2, '0');
    final month = deadline.month.toString().padLeft(2, '0');
    return '$day/$month/${deadline.year}';
  }

  void _goToGroup(int index) {
    if (index < 0 || index >= widget.groups.length) return;
    setState(() => _currentIndex = index);
  }

  Future<void> _confirmGoHome() async {
    final i18n = AppI18n.current;
    final deadline = _formattedDeadline;
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

  String _appBarTitle(AppI18n i18n) {
    return switch (_currentGroup.type) {
      DocumentGroupType.candidate => i18n.candidateStepTitle,
      DocumentGroupType.member => i18n.kinshipLabel,
      DocumentGroupType.family => _currentGroup.title,
    };
  }

  Future<List<DocumentProofPreviewResult>> _pickFiles() async {
    final source = await _showPickSourceSheet();
    if (source == null || !mounted) return const [];
    switch (source) {
      case _ProofPickSource.camera:
        return _pickFromCamera();
      case _ProofPickSource.gallery:
        return _pickFromGallery();
      case _ProofPickSource.documents:
        return _pickFromDocuments();
    }
  }

  Future<_ProofPickSource?> _showPickSourceSheet() {
    final i18n = AppI18n.current;

    return showModalBottomSheet<_ProofPickSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _PickSourceCard(
                        icon: AppIcons.cameraIcon,
                        label: i18n.documentProofTakePhoto,
                        onTap: () =>
                            Navigator.of(ctx).pop(_ProofPickSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickSourceCard(
                        icon: AppIcons.imageIcon,
                        label: i18n.documentProofSelectImage,
                        onTap: () =>
                            Navigator.of(ctx).pop(_ProofPickSource.gallery),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickSourceCard(
                        icon: AppIcons.pdfFileIcon,
                        label: i18n.documentProofSelectDocument,
                        onTap: () =>
                            Navigator.of(ctx).pop(_ProofPickSource.documents),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<List<DocumentProofPreviewResult>> _pickFromCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return const [];
    try {
      final pictures =
          await _withLoader(() => CunningDocumentScanner.getPictures());
      if (pictures == null) return const [];
      return [
        for (final p in pictures)
          DocumentProofPreviewResult(fileName: p.split('/').last, filePath: p),
      ];
    } catch (_) {
      return const [];
    }
  }

  Future<List<DocumentProofPreviewResult>> _pickFromGallery() async {
    final result = await _withLoader(() => FilePicker.pickFiles(
          type: FileType.image,
          allowMultiple: true,
        ));
    if (result == null) return const [];
    return [
      for (final f in result.files)
        DocumentProofPreviewResult(fileName: f.name, filePath: f.path),
    ];
  }

  Future<List<DocumentProofPreviewResult>> _pickFromDocuments() async {
    final result = await _withLoader(() => FilePicker.pickFiles(
          type: FileType.custom,
          allowedExtensions: const ['pdf'],
          allowMultiple: true,
        ));
    if (result == null) return const [];
    return [
      for (final f in result.files)
        DocumentProofPreviewResult(fileName: f.name, filePath: f.path),
    ];
  }

  Future<T> _withLoader<T>(Future<T> Function() action) async {
    final navigator = Navigator.of(context, rootNavigator: true);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
    try {
      return await action();
    } finally {
      navigator.pop();
    }
  }

  Future<bool> _uploadSlot(
    String proofDocumentId,
    ProofSlotSubmission submission,
  ) async {
    final result = await _uploadProofDocument.upload(UploadProofDocumentParams(
      scholarshipId: widget.scholarshipId,
      proofDocumentId: proofDocumentId,
      documentId: submission.documentId,
      acceptTerm: submission.acceptTerm,
      attachments: submission.attachments,
    ));
    return result.archived;
  }

  Future<void> _refreshProofs() async {
    try {
      final updated = await widget.onRefresh();
      if (!mounted) return;
      setState(() => _proofsByGroup = updated);
    } catch (_) {}
  }

  Future<void> _onSendDocument(ScholarshipProofEntity proof) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DocumentProofSendPage(
          proof: proof,
          onPickFiles: _pickFiles,
          onUploadSlot: _uploadSlot,
        ),
      ),
    );
    if (!mounted) return;
    // Sempre recarrega: cobre sucesso, envio parcial e o header de arquivamento
    await _refreshProofs();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final canGoBack = _currentIndex > 0;
    final canGoForward = _currentIndex < widget.groups.length - 1;
    final proofs = _currentProofs;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        _popToDocuments();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
            onPressed: _popToDocuments,
          ),
          title: Text(_appBarTitle(i18n)),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: _confirmGoHome,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ScholarshipStepIndicator(
                  currentStep: 5,
                  completedStep: 5,
                  onStepTap: (_) {},
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: MemberRegistrationSubStepNav(
                        navTitle: _currentGroup.title,
                        canGoBack: canGoBack,
                        canGoForward: canGoForward,
                        onBack: () => _goToGroup(_currentIndex - 1),
                        onForward: () => _goToGroup(_currentIndex + 1),
                      ),
                    ),
                    for (var i = 0; i < proofs.length; i++) ...[
                      _DocumentRequirementRow(
                        proof: proofs[i],
                        onSend: () => _onSendDocument(proofs[i]),
                      ),
                      const Divider(
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: Color(0xFFCAC4D0)),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: EbolsaButton(
                  onPressed: _popToDocuments,
                  label: i18n.documentsBackToDocumentsAction,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentRequirementRow extends StatelessWidget {
  final ScholarshipProofEntity proof;
  final VoidCallback onSend;

  const _DocumentRequirementRow({
    required this.proof,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final isComplete = proof.isComplete;
    final needsReview = proof.needsReview;
    final showProgress = proof.totalSlots > 1 && !isComplete;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        children: [
          EbolsaCheckProofsIcons(
            needsReview: needsReview,
            isComplete: isComplete,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  proof.proofName ?? '',
                  style: AppTextStyles.bodyLarge,
                ),
                if (proof.referenceDescription != null)
                  Text(
                    proof.referenceDescription!,
                    style: AppTextStyles.bodySmall,
                  ),
                if (showProgress)
                  Text(
                    '${proof.uploadedSlots}/${proof.totalSlots}',
                    style: AppTextStyles.bodySmall,
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: onSend,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.onSurface,
              minimumSize: const Size(0, 40),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: const BorderSide(color: Color(0xFFB9BDC6)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            child: Text(
              isComplete ? i18n.documentEditAction : i18n.documentSendAction,
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PickSourceCard extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _PickSourceCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.backgroundLight,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.primaryOutline,
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                icon,
                width: 24,
                height: 24,
                color: AppColors.onSurface,
              ),
              const SizedBox(height: 20),
              Text(
                label,
                textAlign: TextAlign.left,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _ProofPickSource { camera, gallery, documents }
