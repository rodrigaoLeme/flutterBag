import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';
import '../../../home/process_declaration_models_page.dart';
import 'document_proof_preview_page.dart';
import 'document_upload_record.dart';

class DocumentProofSubmitPage extends StatefulWidget {
  final String documentTitle;
  final String? documentId;
  final String? description;
  final List<String> documentTypeOptions;
  final List<String> uploadOptions;
  final bool requireValue;
  final bool autoConfirmOnPick;
  final bool showDeclarationModelDownload;
  final bool openPreviewAfterPick;
  final DocumentUploadRecord? initialRecord;

  const DocumentProofSubmitPage({
    super.key,
    required this.documentTitle,
    this.documentId,
    this.description,
    this.documentTypeOptions = const [],
    this.uploadOptions = const [],
    this.requireValue = false,
    this.autoConfirmOnPick = false,
    this.showDeclarationModelDownload = false,
    this.openPreviewAfterPick = false,
    this.initialRecord,
  });

  @override
  State<DocumentProofSubmitPage> createState() =>
      _DocumentProofSubmitPageState();
}

class _DocumentProofSubmitPageState extends State<DocumentProofSubmitPage> {
  String? _selectedDocumentType;
  String? _pickedFileName;
  String? _pickedFilePath;
  late final TextEditingController _valueController;
  bool _detailsExpanded = false;
  late final TapGestureRecognizer _readMoreRecognizer;
  TapGestureRecognizer? _receitaFederalRecognizer;
  final Map<String, DocumentProofPreviewResult> _uploadedOptionFiles = {};

  bool get _requiresDocumentType => widget.documentTypeOptions.isNotEmpty;

  bool get _hasMultipleUploadOptions => widget.uploadOptions.isNotEmpty;

  bool get _isCpfDocument => widget.documentId == 'cpf';

  bool get _isMeEppDocument => widget.documentId == 'me-epp-proof';

  bool get _isNoWorkCardDocument => widget.documentId == 'no-work-card';

  // ignore: unused_element
  Set<String> get _uploadedOptions => _uploadedOptionFiles.keys.toSet();

  bool get _canConfirm {
    if (_hasMultipleUploadOptions) {
      return _uploadedOptionFiles.length == widget.uploadOptions.length;
    }
    if (_pickedFileName == null) return false;
    if (_requiresDocumentType && _selectedDocumentType == null) return false;
    if (widget.requireValue && _valueController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  DocumentUploadRecord get _currentRecord => DocumentUploadRecord(
        fileName: _pickedFileName ?? '',
        filePath: _pickedFilePath,
        selectedDocumentType: _selectedDocumentType,
        value: _valueController.text.trim().isEmpty
            ? null
            : _valueController.text.trim(),
        optionFiles: Map<String, DocumentProofPreviewResult>.from(
          _uploadedOptionFiles,
        ),
      );

  String get _valueFieldLabel {
    final i18n = AppI18n.current;
    final type = _selectedDocumentType;
    if (type == i18n.documentTypeElectricity) {
      return i18n.documentProofElectricityValueLabel;
    }
    return i18n.documentProofValueLabel;
  }

  String get _uploadButtonLabel {
    final i18n = AppI18n.current;
    if (_pickedFileName != null) return _pickedFileName!;
    if (_isNoWorkCardDocument) return i18n.documentNoWorkCardUploadLabel;
    return widget.documentTitle;
  }

  String get _description {
    final i18n = AppI18n.current;
    if (_isCpfDocument) return i18n.documentCpfProofDescription;
    if (_isMeEppDocument) return i18n.documentMeEppProofDescriptionCollapsed;
    if (_isNoWorkCardDocument) {
      return i18n.documentNoWorkCardGuidelinesCollapsed;
    }
    return widget.description ??
        (_requiresDocumentType
            ? i18n.documentAddressProofDescription
            : i18n.documentPersonProofDescription(widget.documentTitle));
  }

  @override
  void initState() {
    super.initState();
    final initial = widget.initialRecord;
    _selectedDocumentType = initial?.selectedDocumentType;
    _pickedFileName =
        initial?.fileName.isNotEmpty == true ? initial!.fileName : null;
    _pickedFilePath = initial?.filePath;
    _uploadedOptionFiles.addAll(initial?.optionFiles ?? const {});
    _valueController = TextEditingController(text: initial?.value ?? '')
      ..addListener(() => setState(() {}));
    _readMoreRecognizer = TapGestureRecognizer()
      ..onTap = () => setState(() => _detailsExpanded = true);
    if (_isCpfDocument) {
      _receitaFederalRecognizer = TapGestureRecognizer()
        ..onTap = _openReceitaFederal;
    }
  }

  @override
  void dispose() {
    _valueController.dispose();
    _readMoreRecognizer.dispose();
    _receitaFederalRecognizer?.dispose();
    super.dispose();
  }

  Future<void> _openReceitaFederal() async {
    final uri = Uri.parse(AppI18n.current.documentCpfProofReceitaFederalUrl);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> _openDocumentTypeSelector() async {
    final i18n = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: i18n.documentTypeSelectorTitle,
      options: widget.documentTypeOptions,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedDocumentType,
    );

    if (selected == null || !mounted) return;
    setState(() => _selectedDocumentType = selected);
  }

  Future<void> _onUploadPressed({String? optionLabel}) async {
    if (_requiresDocumentType && _selectedDocumentType == null) {
      return;
    }

    if (optionLabel == null &&
        _pickedFileName != null &&
        _pickedFileName!.isNotEmpty) {
      final previewTitle = _selectedDocumentType ?? widget.documentTitle;
      final confirmed =
          await Navigator.of(context).push<DocumentProofPreviewResult>(
        MaterialPageRoute(
          builder: (_) => DocumentProofPreviewPage(
            documentTitle: previewTitle,
            fileName: _pickedFileName!,
            filePath: _pickedFilePath,
            onReplace: _pickFile,
          ),
        ),
      );
      if (confirmed == null || !mounted) return;
      setState(() {
        _pickedFileName = confirmed.fileName;
        _pickedFilePath = confirmed.filePath;
      });
      if (widget.autoConfirmOnPick || widget.openPreviewAfterPick) {
        Navigator.of(context).pop(_currentRecord);
      }
      return;
    }

    final picked = await _pickFile();
    if (picked == null || !mounted) return;

    if (optionLabel != null || widget.openPreviewAfterPick) {
      final previewTitle =
          optionLabel ?? _selectedDocumentType ?? widget.documentTitle;

      final confirmed =
          await Navigator.of(context).push<DocumentProofPreviewResult>(
        MaterialPageRoute(
          builder: (_) => DocumentProofPreviewPage(
            documentTitle: previewTitle,
            fileName: picked.fileName,
            filePath: picked.filePath,
            onReplace: _pickFile,
          ),
        ),
      );

      if (confirmed == null || !mounted) return;

      if (optionLabel != null) {
        setState(() => _uploadedOptionFiles[optionLabel] = confirmed);
        if (widget.autoConfirmOnPick &&
            _uploadedOptionFiles.length == widget.uploadOptions.length) {
          Navigator.of(context).pop(_currentRecord);
        }
      } else {
        setState(() {
          _pickedFileName = confirmed.fileName;
          _pickedFilePath = confirmed.filePath;
        });
        Navigator.of(context).pop(_currentRecord);
      }
      return;
    }

    setState(() {
      _pickedFileName = picked.fileName;
      _pickedFilePath = picked.filePath;
    });

    if (widget.autoConfirmOnPick) {
      final confirmed =
          await Navigator.of(context).push<DocumentProofPreviewResult>(
        MaterialPageRoute(
          builder: (_) => DocumentProofPreviewPage(
            documentTitle: widget.documentTitle,
            fileName: picked.fileName,
            filePath: picked.filePath,
            onReplace: _pickFile,
          ),
        ),
      );
      if (confirmed == null || !mounted) return;
      setState(() {
        _pickedFileName = confirmed.fileName;
        _pickedFilePath = confirmed.filePath;
      });
      Navigator.of(context).pop(_currentRecord);
    }
  }

  Future<void> _openUploadedOption(String optionLabel) async {
    final existing = _uploadedOptionFiles[optionLabel];
    if (existing == null) return;

    final confirmed =
        await Navigator.of(context).push<DocumentProofPreviewResult>(
      MaterialPageRoute(
        builder: (_) => DocumentProofPreviewPage(
          documentTitle: optionLabel,
          fileName: existing.fileName,
          filePath: existing.filePath,
          onReplace: _pickFile,
        ),
      ),
    );

    if (confirmed == null || !mounted) return;
    setState(() => _uploadedOptionFiles[optionLabel] = confirmed);
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

  Future<DocumentProofPreviewResult?> _pickFromCamera() async {
    final cameraStatus = await Permission.camera.request();
    if (!cameraStatus.isGranted) {
      if (!mounted) return null;
      await _showPermissionDialog();
      return null;
    }

    try {
      final pictures = await CunningDocumentScanner.getPictures(
        noOfPages: 1,
      );
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
    if (!hasAccess) {
      if (!mounted) return null;
      await _showPermissionDialog();
      return null;
    }

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

  Future<void> _showPermissionDialog() async {
    final i18n = AppI18n.current;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.familyConfirmDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: Text(
          i18n.documentProofPermissionDialogBody,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              i18n.answerNo,
              style: AppTextStyles.m3LabelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: Text(
              i18n.documentProofPermissionSettingsAction,
              style: AppTextStyles.m3LabelLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirm() {
    if (!_canConfirm) return;
    Navigator.of(context).pop(_currentRecord);
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final showConfirm =
        (!widget.autoConfirmOnPick && !widget.openPreviewAfterPick) ||
            (_hasMultipleUploadOptions && _canConfirm);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(i18n.documentProofSubmitAppBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.documentTitle,
                            style: AppTextStyles.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          if (_isCpfDocument)
                            _buildCpfDescription(i18n)
                          else if (_isMeEppDocument)
                            _buildMeEppDescription(i18n)
                          else if (_isNoWorkCardDocument)
                            _buildNoWorkCardDescription(i18n)
                          else
                            Text(
                              _description,
                              style: AppTextStyles.bodyMedium,
                            ),
                          if (_requiresDocumentType) ...[
                            const SizedBox(height: 24),
                            _buildDocumentTypeSelector(i18n),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: true,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: constraints.maxHeight,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_hasMultipleUploadOptions)
                                  ..._buildMultipleUploadButtons()
                                else ...[
                                  _buildUploadButton(
                                    label: _uploadButtonLabel,
                                    onPressed: (_requiresDocumentType &&
                                            _selectedDocumentType == null)
                                        ? null
                                        : () => _onUploadPressed(),
                                    allowNullOnPressed: true,
                                  ),
                                  if (widget.requireValue) ...[
                                    const SizedBox(height: 16),
                                    EbolsaTextField(
                                      controller: _valueController,
                                      label: _valueFieldLabel,
                                      keyboardType: TextInputType.number,
                                    ),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showDeclarationModelDownload)
              _buildDeclarationModelDownload(i18n),
            if (showConfirm)
              Padding(
                padding: const EdgeInsets.all(16),
                child: EbolsaButton(
                  onPressed: _canConfirm ? _onConfirm : null,
                  label: i18n.confirmAction,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoWorkCardDescription(AppI18n i18n) {
    final actionStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            style: AppTextStyles.bodyMedium,
            children: [
              TextSpan(
                text: _detailsExpanded
                    ? i18n.documentNoWorkCardGuidelinesExpanded
                    : i18n.documentNoWorkCardGuidelinesCollapsed,
              ),
              if (!_detailsExpanded)
                TextSpan(
                  text: i18n.documentReadMoreAction,
                  style: actionStyle,
                  recognizer: _readMoreRecognizer,
                ),
            ],
          ),
        ),
        if (_detailsExpanded) ...[
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => setState(() => _detailsExpanded = false),
              child: Text(
                i18n.documentReadLessAction,
                style: actionStyle,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDeclarationModelDownload(AppI18n i18n) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              i18n.documentNoWorkCardDownloadModelHint,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProcessDeclarationModelsPage(),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerLow,
                  foregroundColor: AppColors.onPrimaryContainer,
                  side: const BorderSide(
                    color: Color(0xFFCAC4D0),
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: SvgPicture.asset(
                  AppIcons.downloadIcon,
                  width: 14,
                  height: 14,
                  color: AppColors.onPrimaryContainer,
                ),
                label: Text(
                  i18n.documentNoWorkCardDownloadModelAction,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeEppDescription(AppI18n i18n) {
    final actionStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text.rich(
          TextSpan(
            style: AppTextStyles.bodyMedium,
            children: [
              TextSpan(text: i18n.documentMeEppProofDescriptionCollapsed),
              if (!_detailsExpanded)
                TextSpan(
                  text: i18n.documentReadMoreAction,
                  style: actionStyle,
                  recognizer: _readMoreRecognizer,
                ),
            ],
          ),
        ),
        if (_detailsExpanded) ...[
          const SizedBox(height: 12),
          Text(
            i18n.documentMeEppProofDescriptionExpanded,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => setState(() => _detailsExpanded = false),
              child: Text(
                i18n.documentReadLessAction,
                style: actionStyle,
              ),
            ),
          ),
        ],
      ],
    );
  }

  List<Widget> _buildMultipleUploadButtons() {
    final widgets = <Widget>[];
    for (var i = 0; i < widget.uploadOptions.length; i++) {
      final option = widget.uploadOptions[i];
      final isUploaded = _uploadedOptionFiles.containsKey(option);
      widgets.add(
        _buildUploadButton(
          label: option,
          onPressed: () {
            if (isUploaded) {
              _openUploadedOption(option);
            } else {
              _onUploadPressed(optionLabel: option);
            }
          },
          isUploaded: isUploaded,
        ),
      );
      if (i < widget.uploadOptions.length - 1) {
        widgets.add(const SizedBox(height: 12));
      }
    }
    return widgets;
  }

  Widget _buildCpfDescription(AppI18n i18n) {
    final linkStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.primary,
      decoration: TextDecoration.underline,
      decorationColor: AppColors.primary,
    );
    final actionStyle = AppTextStyles.bodyMedium.copyWith(
      color: AppColors.primary,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          i18n.documentCpfProofDescription,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            style: AppTextStyles.bodyMedium,
            children: [
              TextSpan(text: i18n.documentCpfProofStepsIntroPrefix),
              TextSpan(
                text: i18n.documentCpfProofReceitaFederalLabel,
                style: linkStyle,
                recognizer: _receitaFederalRecognizer,
              ),
              TextSpan(text: i18n.documentCpfProofStepsIntroSuffix),
              if (!_detailsExpanded)
                TextSpan(
                  text: i18n.documentReadMoreAction,
                  style: actionStyle,
                  recognizer: _readMoreRecognizer,
                ),
            ],
          ),
        ),
        if (_detailsExpanded) ...[
          const SizedBox(height: 12),
          Text(
            i18n.documentCpfProofStepsExpanded,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => setState(() => _detailsExpanded = false),
              child: Text(
                i18n.documentReadLessAction,
                style: actionStyle,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDocumentTypeSelector(AppI18n i18n) {
    final selected = _selectedDocumentType;
    final placeholder = i18n.documentTypeSelectorPlaceholder;

    return SizedBox(
      height: 56,
      child: InkWell(
        onTap: _openDocumentTypeSelector,
        borderRadius: BorderRadius.circular(16),
        child: InputDecorator(
          decoration: InputDecoration(
            hintText: placeholder,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 16,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            suffixIcon: const Icon(Icons.keyboard_arrow_down),
          ),
          child: Text(
            selected ?? placeholder,
            style: selected == null
                ? AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.onSurface.withValues(alpha: 0.6),
                  )
                : AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton({
    required String label,
    VoidCallback? onPressed,
    bool isUploaded = false,
    bool allowNullOnPressed = false,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: allowNullOnPressed
            ? onPressed
            : (onPressed ?? () => _onUploadPressed()),
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.secondaryContainer,
          foregroundColor: AppColors.onSurface,
          disabledBackgroundColor:
              AppColors.secondaryContainer.withOpacity(0.5),
          minimumSize: const Size.fromHeight(56),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            if (isUploaded)
              const Icon(
                Icons.check_circle,
                color: AppColors.success,
                size: 20,
              )
            else
              SvgPicture.asset(
                'lib/ui/assets/icons/upload.svg',
                width: 20,
                color: AppColors.onPrimaryContainer,
              ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
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
