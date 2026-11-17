import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../domain/entities/proof_attachment_entity.dart';
import '../../../../../domain/entities/proof_document_entity.dart';
import '../../../../../domain/entities/proof_document_option_entity.dart';
import '../../../../../domain/entities/proof_slot_submission.dart';
import '../../../../../domain/entities/scholarship_proof_entity.dart';
import '../../../../../domain/usecases/documents/upload_proof_document_usecase.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../../share/utils/pdf_inspector.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';
import 'document_proof_preview_page.dart';

class DocumentProofSendPage extends StatefulWidget {
  final ScholarshipProofEntity proof;
  final Future<List<DocumentProofPreviewResult>> Function() onPickFiles;
  final Future<bool> Function(
      String proofDocumentId, ProofSlotSubmission submission) onUploadSlot;

  const DocumentProofSendPage({
    super.key,
    required this.proof,
    required this.onPickFiles,
    required this.onUploadSlot,
  });

  @override
  State<DocumentProofSendPage> createState() => _DocumentProofSendPageState();
}

class _DocumentProofSendPageState extends State<DocumentProofSendPage> {
  final Map<String, ProofDocumentOptionEntity> _selectedOptions = {};
  final Map<String, ProofAttachments> _attachments = {};
  final Set<String> _acceptedTerms = {};
  final Set<String> _sentSlots = {};
  bool _isSubmitting = false;

  List<ProofDocumentEntity> get _slots =>
      widget.proof.scholarshipProofDocuments;

  @override
  void initState() {
    super.initState();
    for (final slot in _slots) {
      if (slot.options.length == 1) {
        _selectedOptions[slot.id] = slot.options.first;
      } else if (slot.documentId != null) {
        for (final option in slot.options) {
          if (option.documentId == slot.documentId) {
            _selectedOptions[slot.id] = option;
          }
        }
      }
      if (slot.acceptedTerm) _acceptedTerms.add(slot.id);
    }
  }

  bool _isSlotComplete(ProofDocumentEntity slot) {
    final option = _selectedOptions[slot.id];
    if (option == null) return false;
    final hasNewFiles = _attachments[slot.id]?.isNotEmpty ?? false;
    if (!hasNewFiles && !slot.hasFile) return false;
    if (option.isDeclaration && !_acceptedTerms.contains(slot.id)) {
      return false;
    }
    return true;
  }

  bool get _allComplete => _slots.isNotEmpty && _slots.every(_isSlotComplete);

  Map<String, ProofSlotSubmission> get _submissions => {
        for (final slot in _slots)
          if ((_attachments[slot.id]?.isNotEmpty ?? false) &&
              _selectedOptions[slot.id] != null)
            slot.id: ProofSlotSubmission(
              documentId: _selectedOptions[slot.id]!.documentId,
              acceptTerm: _acceptedTerms.contains(slot.id),
              attachments: _attachments[slot.id]!,
            ),
      };

  String get _description =>
      widget.proof.referenceDescription ??
      AppI18n.current.documentPersonProofDescription(
        widget.proof.proofName ?? '',
      );

  void _showLimitMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  bool _acceptCheck(AttachmentCheck check) {
    switch (check) {
      case AttachmentCheck.ok:
        return true;
      case AttachmentCheck.tooManyFiles:
        _showLimitMessage(AppI18n.current.documentProofAttachTooManyFiles);
        return false;
      case AttachmentCheck.tooLarge:
        _showLimitMessage(AppI18n.current.documentProofAttachTooLarge);
        return false;
    }
  }

  Future<ProofAttachment?> _toAttachment(
    DocumentProofPreviewResult picked,
  ) async {
    final path = picked.filePath;
    if (path == null) return null;
    final isPdf = path.toLowerCase().endsWith('.pdf');
    return ProofAttachment(
      path: path,
      name: picked.fileName,
      sizeBytes: await File(path).length(),
      type: isPdf ? ProofAttachmentType.pdf : ProofAttachmentType.image,
      isEncrypted: isPdf && await isLikelyEncryptedPdf(path),
    );
  }

  Future<DocumentProofPreviewResult?> _pickOne() async {
    final list = await widget.onPickFiles();
    return list.isEmpty ? null : list.first;
  }

  Future<void> _openOptionSelector(ProofDocumentEntity slot) async {
    final i18n = AppI18n.current;
    final selected =
        await SearchableOptionsBottomSheet.show<ProofDocumentOptionEntity>(
      context: context,
      title: i18n.documentTypeSelectorTitle,
      options: slot.options,
      searchHint: i18n.noticesTermsSearchHint,
      helperText: i18n.noticesTermsBottomSheetSearchHelp,
      emptyStateText: i18n.noticesTermsBottomSheetNoResults,
      closeTooltip: i18n.noticesTermsCloseAction,
      selectedValue: _selectedOptions[slot.id],
      labelBuilder: (o) => o.name ?? '',
      searchTextBuilder: (o) => o.name ?? '',
      showSearchInput: false,
    );
    if (selected == null || !mounted) return;

    setState(() {
      final changed =
          _selectedOptions[slot.id]?.documentId != selected.documentId;
      if (changed) {
        _attachments.remove(slot.id);
        _acceptedTerms.remove(slot.id);
        _sentSlots.remove(slot.id);
      }
      _selectedOptions[slot.id] = selected;
    });
  }

  Future<void> _onAdd(ProofDocumentEntity slot) async {
    final picked = await widget.onPickFiles();
    if (picked.isEmpty || !mounted) return;

    final current = _attachments[slot.id] ?? const ProofAttachments();
    final existingPaths = current.items.map((a) => a.path).toSet();

    final incoming = <ProofAttachment>[];
    for (final p in picked) {
      final attachment = await _toAttachment(p);
      if (attachment != null && !existingPaths.contains(attachment.path)) {
        incoming.add(attachment);
      }
    }
    if (incoming.isEmpty || !mounted) return;
    if (!_acceptCheck(current.check(incoming))) return;

    setState(() {
      _attachments[slot.id] = current.add(incoming);
      _sentSlots.remove(slot.id);
    });
  }

  void _onRemove(ProofDocumentEntity slot, ProofAttachment attachment) {
    final current = _attachments[slot.id] ?? const ProofAttachments();
    setState(() => _attachments[slot.id] = current.remove(attachment));
  }

  Future<void> _openPreview(
    ProofDocumentEntity slot,
    ProofAttachment attachment,
  ) async {
    final option = _selectedOptions[slot.id];
    final result = await Navigator.of(context).push<DocumentProofPreviewResult>(
      MaterialPageRoute(
        builder: (_) => DocumentProofPreviewPage(
          documentTitle: option?.name ?? widget.proof.proofName ?? '',
          fileName: attachment.name,
          filePath: attachment.path,
          onReplace: _pickOne,
        ),
      ),
    );
    if (result == null || !mounted) return;
    if (result.filePath == null || result.filePath == attachment.path) return;

    final replacement = await _toAttachment(result);
    if (replacement == null || !mounted) return;

    final without =
        (_attachments[slot.id] ?? const ProofAttachments()).remove(attachment);
    if (!_acceptCheck(without.check([replacement]))) return;
    setState(() {
      _attachments[slot.id] = without.add([replacement]);
      _sentSlots.remove(slot.id);
    });
  }

  Future<void> _onConfirm() async {
    final slotIds =
        _submissions.keys.where((id) => !_sentSlots.contains(id)).toList();

    setState(() => _isSubmitting = true);
    try {
      var archived = false;
      for (final slotId in slotIds) {
        archived = await _uploadWithPasswordRetry(slotId);
        _sentSlots.add(slotId);
        if (archived) break;
      }
      if (!mounted) return;
      if (archived) _showLimitMessage(AppI18n.current.documentProofListChanged);
      Navigator.of(context).pop(true);
    } on UploadProofDocumentException catch (e) {
      if (!mounted) return;
      _showLimitMessage(e.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<bool> _uploadWithPasswordRetry(String slotId) async {
    while (true) {
      final submission =
          _submissions[slotId]; // refeito a cada volta, com as senhas novas
      if (submission == null) return false;
      try {
        return await widget.onUploadSlot(slotId, submission);
      } on UploadProofDocumentException catch (e) {
        final needsPassword =
            e.failure == UploadProofFailure.passwordRequired ||
                e.failure == UploadProofFailure.invalidPassword;
        if (!needsPassword) rethrow;

        final provided = await _askPasswords(
          slotId,
          wrongPassword: e.failure == UploadProofFailure.invalidPassword,
        );
        if (!provided) rethrow;
      }
    }
  }

  Future<bool> _askPasswords(
    String slotId, {
    required bool wrongPassword,
    List<ProofAttachment>? only,
  }) async {
    final current = _attachments[slotId];
    if (current == null) return false;

    final pdfs = only ??
        [
          ...current.pdfs.where((p) => p.isEncrypted),
          ...current.pdfs.where((p) => !p.isEncrypted),
        ];
    if (pdfs.isEmpty) return false;

    final result = await showDialog<Map<String, String>>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          _PdfPasswordsDialog(pdfs: pdfs, wrongPassword: wrongPassword),
    );
    if (result == null || !mounted) return false;

    var updated = current;
    for (final pdf in pdfs) {
      updated = updated.update(pdf.copyWith(password: result[pdf.path] ?? ''));
    }
    setState(() => _attachments[slotId] = updated);
    return true;
  }

  Widget _buildSlot(ProofDocumentEntity slot) {
    final i18n = AppI18n.current;
    final option = _selectedOptions[slot.id];
    final attachments = _attachments[slot.id] ?? const ProofAttachments();

    final String label;
    if (attachments.isNotEmpty) {
      label = i18n.documentProofAttachAddAction;
    } else if (slot.hasFile && (slot.filename?.isNotEmpty ?? false)) {
      label = slot.filename!;
    } else if (slot.options.length > 1) {
      label = widget.proof.proofName ?? '';
    } else {
      label = option?.name ?? widget.proof.proofName ?? '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (slot.options.length > 1) ...[
          _OptionSelectorField(
            label: i18n.documentTypeSelectorTitle,
            value: option?.name,
            onTap: () => _openOptionSelector(slot),
          ),
          const SizedBox(height: 16),
        ],
        for (final attachment in attachments.items)
          _AttachmentTile(
            attachment: attachment,
            onTap: () => _openPreview(slot, attachment),
            onRemove: () => _onRemove(slot, attachment),
            onPassword: attachment.isEncrypted
                ? () => _askPasswords(slot.id,
                    wrongPassword: false, only: [attachment])
                : null,
          ),
        if (attachments.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  i18n.documentProofAttachCounter(
                    '${attachments.outgoingFileCount}/${ProofAttachments.maxFiles}',
                    '${_formatBytes(attachments.totalBytes)} / '
                        '${ProofAttachments.maxBytes ~/ (1024 * 1024)} MB',
                  ),
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 5),
                Text(
                  i18n.documentProofAttachInfoMessage,
                  style: AppTextStyles.bodySmall,
                )
              ],
            ),
          ),
        _UploadButton(
          label: label,
          isUploaded: attachments.isEmpty && slot.hasFile,
          onPressed: option == null ? null : () => _onAdd(slot),
        ),
        if (option != null && option.isDeclaration)
          CheckboxListTile(
            value: _acceptedTerms.contains(slot.id),
            onChanged: (v) => setState(() {
              if (v == true) {
                _acceptedTerms.add(slot.id);
              } else {
                _acceptedTerms.remove(slot.id);
              }
            }),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Texto para acceptlabel',
              style: AppTextStyles.bodyMedium,
            ),
          ),
        if (option?.declarationTemplateId != null)
          TextButton(
            onPressed: () {
              // TODO: baixar o modelo (depende do endpoint)
            },
            child: Text(i18n.documentNoWorkCardDownloadModelAction),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.documentProofSubmitAppBarTitle),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.proof.proofName ?? '',
                          style: AppTextStyles.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(_description, style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 32),
                        for (final slot in _slots) ...[
                          _buildSlot(slot),
                          const SizedBox(height: 16),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: EbolsaButton(
                    onPressed:
                        _allComplete && !_isSubmitting ? _onConfirm : null,
                    label: i18n.confirmAction,
                  ),
                ),
              ],
            ),
            if (_isSubmitting)
              const Positioned.fill(
                child: ColoredBox(
                  color: Colors.black26,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String _formatBytes(int bytes) {
  if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
  final mb = (bytes / (1024 * 1024)).toStringAsFixed(1).replaceAll('.', ',');
  return '$mb MB';
}

class _AttachmentTile extends StatelessWidget {
  final ProofAttachment attachment;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback? onPassword;

  const _AttachmentTile({
    required this.attachment,
    required this.onTap,
    required this.onRemove,
    this.onPassword,
  });

  @override
  Widget build(BuildContext context) {
    final isImage = attachment.type == ProofAttachmentType.image;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 44,
          height: 44,
          child: isImage
              ? Image.file(
                  File(attachment.path),
                  fit: BoxFit.cover,
                  cacheWidth: 120,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_outlined),
                )
              : const Icon(Icons.picture_as_pdf_outlined),
        ),
      ),
      title: Text(
        attachment.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.bodyMedium,
      ),
      subtitle: Text(
        _formatBytes(attachment.sizeBytes),
        style: AppTextStyles.bodySmall,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (attachment.isEncrypted)
            IconButton(
              tooltip: AppI18n.current.documentProofPasswordTitle,
              icon: Icon(
                (attachment.password?.isNotEmpty ?? false)
                    ? Icons.lock_open
                    : Icons.lock_outline,
              ),
              color: AppColors.onSurfaceVariant,
              onPressed: onPassword,
            ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: AppColors.onSurfaceVariant,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}

class _PdfPasswordsDialog extends StatefulWidget {
  final List<ProofAttachment> pdfs;
  final bool wrongPassword;

  const _PdfPasswordsDialog({required this.pdfs, required this.wrongPassword});

  @override
  State<_PdfPasswordsDialog> createState() => _PdfPasswordsDialogState();
}

class _PdfPasswordsDialogState extends State<_PdfPasswordsDialog> {
  late final Map<String, TextEditingController> _controllers;
  final Set<String> _visible = {};

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (final pdf in widget.pdfs)
        pdf.path: TextEditingController(text: pdf.password ?? ''),
    };
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return AlertDialog(
      title: Text(
        widget.wrongPassword
            ? i18n.documentProofPasswordWrongTitle
            : i18n.documentProofPasswordTitle,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(i18n.documentProofPasswordDescription,
                style: AppTextStyles.bodyMedium),
            const SizedBox(height: 16),
            for (final pdf in widget.pdfs) ...[
              Text(
                pdf.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall,
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _controllers[pdf.path],
                autofocus: pdf == widget.pdfs.first,
                obscureText: !_visible.contains(pdf.path),
                autocorrect: false,
                enableSuggestions: false,
                decoration: InputDecoration(
                  labelText: i18n.documentProofPasswordLabel,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _visible.contains(pdf.path)
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () => setState(() {
                      if (!_visible.add(pdf.path)) _visible.remove(pdf.path);
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
      actions: [
        EbolsaTextButton(
          onPressed: () => Navigator.of(context).pop(),
          label: i18n.documentProofPasswordCancelAction,
          isSecondary: true,
        ),
        EbolsaTextButton(
          onPressed: () => Navigator.of(context).pop({
            for (final e in _controllers.entries) e.key: e.value.text,
          }),
          label: i18n.documentProofPasswordSendAction,
        ),
      ],
    );
  }
}

class _OptionSelectorField extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;

  const _OptionSelectorField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: Text(
          value ?? label,
          style: value == null
              ? AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.onSurface.withValues(alpha: 0.6))
              : AppTextStyles.bodyMedium,
        ),
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  final String label;
  final bool isUploaded;
  final VoidCallback? onPressed;

  const _UploadButton({
    required this.label,
    required this.isUploaded,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.5 : 1,
      child: Material(
        //color: AppColors.primary.withValues(alpha: 0.15),
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!isUploaded)
                  SvgPicture.asset(
                    AppIcons.uploadIcon,
                    width: 20,
                    color: AppColors.onSurfaceVariant,
                  ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
