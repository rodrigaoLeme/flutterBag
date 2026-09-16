import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../../main/routes/routes.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';
import '../../widgets/scholarship_step_indicator.dart';
import '../family/widgets/member_registration_sub_step_nav.dart';
import 'document_group_item.dart';
import 'document_proof_preview_page.dart';
import 'document_proof_submit_page.dart';
import 'document_requirement_item.dart';
import 'document_requirements.dart';
import 'document_upload_record.dart';

class DocumentGroupDetailPage extends StatefulWidget {
  final List<DocumentGroupItem> groups;
  final int initialIndex;
  final DateTime? submissionDeadline;
  final Map<String, Map<String, DocumentUploadRecord>> uploadedDocumentsByGroup;

  const DocumentGroupDetailPage({
    super.key,
    required this.groups,
    required this.initialIndex,
    this.submissionDeadline,
    this.uploadedDocumentsByGroup = const {},
  });

  @override
  State<DocumentGroupDetailPage> createState() =>
      _DocumentGroupDetailPageState();
}

class _DocumentGroupDetailPageState extends State<DocumentGroupDetailPage> {
  late int _currentIndex;
  late List<DocumentRequirementItem> _requirements;
  late final Map<String, Map<String, DocumentUploadRecord>>
      _uploadedDocumentsByGroup;

  DocumentGroupItem get _currentGroup => widget.groups[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.groups.length - 1);
    _uploadedDocumentsByGroup = {
      for (final entry in widget.uploadedDocumentsByGroup.entries)
        entry.key: Map<String, DocumentUploadRecord>.from(entry.value),
    };
    _loadRequirements();
  }

  void _loadRequirements() {
    final uploaded = _uploadedDocumentsByGroup[_currentGroup.id] ?? {};
    _requirements = [
      for (final item in documentRequirementsForGroup(_currentGroup))
        item.copyWith(isUploaded: uploaded.containsKey(item.id)),
    ];
  }

  DocumentUploadRecord? _recordFor(String requirementId) =>
      _uploadedDocumentsByGroup[_currentGroup.id]?[requirementId];

  void _saveRecord(String requirementId, DocumentUploadRecord record) {
    _uploadedDocumentsByGroup.putIfAbsent(
      _currentGroup.id,
      () => <String, DocumentUploadRecord>{},
    )[requirementId] = record;
    setState(_loadRequirements);
  }

  void _popToDocuments() {
    Navigator.of(context).pop(_uploadedDocumentsByGroup);
  }

  String? get _formattedDeadline {
    final deadline = widget.submissionDeadline;
    if (deadline == null) return null;

    final day = deadline.day.toString().padLeft(2, '0');
    final month = deadline.month.toString().padLeft(2, '0');
    return '$day/$month/${deadline.year}';
  }

  void _goToGroup(int index) {
    if (index < 0 || index >= widget.groups.length) return;
    setState(() {
      _currentIndex = index;
      _loadRequirements();
    });
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

  Future<DocumentProofPreviewResult?> _pickFile() async {
    final source = await _showPickSourceSheet();
    if (source == null || !mounted) return null;

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
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _PickSourceCard(
                        icon: Icons.photo_camera_outlined,
                        label: i18n.documentProofTakePhoto,
                        onTap: () =>
                            Navigator.of(ctx).pop(_ProofPickSource.camera),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickSourceCard(
                        icon: Icons.image_outlined,
                        label: i18n.documentProofSelectImage,
                        onTap: () =>
                            Navigator.of(ctx).pop(_ProofPickSource.gallery),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _PickSourceCard(
                        icon: Icons.picture_as_pdf_outlined,
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

  Future<DocumentProofPreviewResult?> _pickFromCamera() async {
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) return null;

    try {
      final pictures = await CunningDocumentScanner.getPictures(noOfPages: 1);
      if (pictures == null || pictures.isEmpty) return null;
      final path = pictures.first;
      return DocumentProofPreviewResult(
        fileName: path.split('/').last,
        filePath: path,
      );
    } catch (_) {
      return null;
    }
  }

  Future<DocumentProofPreviewResult?> _pickFromGallery() async {
    final photosStatus = await Permission.photos.request();
    final hasAccess = photosStatus.isGranted || photosStatus.isLimited;
    if (!hasAccess) return null;

    final result = await FilePicker.pickFiles(type: FileType.image);
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    return DocumentProofPreviewResult(
      fileName: file.name,
      filePath: file.path,
    );
  }

  Future<DocumentProofPreviewResult?> _pickFromDocuments() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result == null || result.files.isEmpty) return null;
    final file = result.files.single;
    return DocumentProofPreviewResult(
      fileName: file.name,
      filePath: file.path,
    );
  }

  Future<void> _openPreviewForEdit(DocumentRequirementItem item) async {
    final existing = _recordFor(item.id);
    if (existing == null || !existing.hasFile) return;

    if (item.id == 'me-epp-proof') {
      final i18n = AppI18n.current;
      final submitted = await Navigator.of(context).push<DocumentUploadRecord>(
        MaterialPageRoute(
          builder: (_) => DocumentProofSubmitPage(
            documentTitle: item.title,
            documentId: item.id,
            uploadOptions: [
              i18n.documentMeEppDecoreLabel,
              i18n.documentMeEppDefisLabel,
              i18n.documentMeEppDasLabel,
            ],
            autoConfirmOnPick: true,
            initialRecord: existing,
          ),
        ),
      );
      if (submitted != null && mounted) {
        _saveRecord(item.id, submitted);
      }
      return;
    }

    if (item.id == 'address-proof' || item.id == 'no-work-card') {
      await _openSubmitFlow(item, initialRecord: existing);
      return;
    }

    final previewTitle = existing.selectedDocumentType ?? item.title;
    final result = await Navigator.of(context).push<DocumentProofPreviewResult>(
      MaterialPageRoute(
        builder: (_) => DocumentProofPreviewPage(
          documentTitle: previewTitle,
          fileName: existing.fileName,
          filePath: existing.filePath,
          onReplace: _pickFile,
        ),
      ),
    );

    if (result != null && mounted) {
      _saveRecord(
        item.id,
        existing.copyWith(
          fileName: result.fileName,
          filePath: result.filePath,
        ),
      );
    }
  }

  Future<void> _openSubmitFlow(
    DocumentRequirementItem item, {
    DocumentUploadRecord? initialRecord,
  }) async {
    final i18n = AppI18n.current;
    final isPersonDocument =
        _currentGroup.type == DocumentGroupType.candidate ||
            _currentGroup.type == DocumentGroupType.member;

    DocumentUploadRecord? submitted;

    if (item.id == 'address-proof') {
      submitted = await Navigator.of(context).push<DocumentUploadRecord>(
        MaterialPageRoute(
          builder: (_) => DocumentProofSubmitPage(
            documentTitle: item.title,
            documentTypeOptions: [
              i18n.documentTypeInternet,
              i18n.documentTypeElectricity,
              i18n.documentTypeCableTv,
              i18n.documentTypePipedGas,
              i18n.documentTypeWaterLastMonth,
              i18n.documentTypeLandline,
            ],
            requireValue: true,
            initialRecord: initialRecord,
          ),
        ),
      );
    } else if (item.id == 'me-epp-proof') {
      submitted = await Navigator.of(context).push<DocumentUploadRecord>(
        MaterialPageRoute(
          builder: (_) => DocumentProofSubmitPage(
            documentTitle: item.title,
            documentId: item.id,
            uploadOptions: [
              i18n.documentMeEppDecoreLabel,
              i18n.documentMeEppDefisLabel,
              i18n.documentMeEppDasLabel,
            ],
            autoConfirmOnPick: true,
            initialRecord: initialRecord,
          ),
        ),
      );
    } else if (item.id == 'no-work-card') {
      submitted = await Navigator.of(context).push<DocumentUploadRecord>(
        MaterialPageRoute(
          builder: (_) => DocumentProofSubmitPage(
            documentTitle: item.title,
            documentId: item.id,
            documentTypeOptions: [
              i18n.documentNoWorkCardTypeNoCtps,
              i18n.documentNoWorkCardTypePublicRpps,
            ],
            showDeclarationModelDownload: true,
            openPreviewAfterPick: true,
            initialRecord: initialRecord,
          ),
        ),
      );
    } else {
      submitted = await Navigator.of(context).push<DocumentUploadRecord>(
        MaterialPageRoute(
          builder: (_) => DocumentProofSubmitPage(
            documentTitle: item.title,
            documentId: item.id,
            description: isPersonDocument
                ? i18n.documentPersonProofDescription(item.title)
                : null,
            autoConfirmOnPick: true,
            openPreviewAfterPick: true,
            initialRecord: initialRecord,
          ),
        ),
      );
    }

    if (submitted != null && mounted) {
      _saveRecord(item.id, submitted);
    }
  }

  Future<void> _onSendDocument(DocumentRequirementItem item) async {
    if (item.isUploaded && _recordFor(item.id) != null) {
      await _openPreviewForEdit(item);
      return;
    }
    await _openSubmitFlow(item);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final canGoBack = _currentIndex > 0;
    final canGoForward = _currentIndex < widget.groups.length - 1;

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
                    for (var i = 0; i < _requirements.length; i++) ...[
                      _DocumentRequirementRow(
                        title: _requirements[i].title,
                        isUploaded: _requirements[i].isUploaded,
                        actionLabel: _requirements[i].isUploaded
                            ? i18n.documentEditAction
                            : i18n.documentSendAction,
                        onSend: () => _onSendDocument(_requirements[i]),
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                        indent: 16,
                        endIndent: 16,
                        color: Color(0xFFCAC4D0),
                      ),
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
  final String title;
  final bool isUploaded;
  final String actionLabel;
  final VoidCallback onSend;

  const _DocumentRequirementRow({
    required this.title,
    required this.isUploaded,
    required this.actionLabel,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        children: [
          if (isUploaded) ...[
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 22,
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyLarge,
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
              actionLabel,
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
  final IconData icon;
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
      color: AppColors.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
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
