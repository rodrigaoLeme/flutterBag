import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../domain/entities/proof_document_entity.dart';
import '../../../../../domain/entities/proof_document_option_entity.dart';
import '../../../../../domain/entities/scholarship_proof_entity.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';
import 'document_proof_preview_page.dart';

class DocumentProofSendPage extends StatefulWidget {
  final ScholarshipProofEntity proof;
  final Future<DocumentProofPreviewResult?> Function() onPickFile;

  const DocumentProofSendPage({
    super.key,
    required this.proof,
    required this.onPickFile,
  });

  @override
  State<DocumentProofSendPage> createState() => _DocumentProofSendPageState();
}

class _DocumentProofSendPageState extends State<DocumentProofSendPage> {
  final Map<String, ProofDocumentOptionEntity> _selectedOptions = {};
  final Map<String, DocumentProofPreviewResult> _pickedFiles = {};
  final Set<String> _acceptedTerms = {};

  List<ProofDocumentEntity> get _slots =>
      widget.proof.scholarshipProofDocuments;

  @override
  void initState() {
    super.initState();
    for (final slot in _slots) {
      if (slot.options.length == 1) {
        _selectedOptions[slot.id] = slot.options.first;
      } else if (slot.documentId != null) {
        // pré-seleciona o tipo já vinculado ao slot
        for (final option in slot.options) {
          if (option.documentId == slot.documentId) {
            _selectedOptions[slot.id] = option;
          }
        }
      }
      if (slot.acceptedTerm) _acceptedTerms.add(slot.id);
    }
  }

  // Conforme o Figma: dropdown/declaração pedem "Confirmar";
  // os demais confirmam sozinhos quando o último arquivo é enviado.
  bool get _needsConfirmButton => _slots.any(
        (s) => s.options.length > 1 || s.options.any((o) => o.isDeclaration),
      );

  bool _isSlotComplete(ProofDocumentEntity slot) {
    final option = _selectedOptions[slot.id];
    if (option == null) return false;
    if (!_pickedFiles.containsKey(slot.id) && !slot.hasFile) return false;
    if (option.isDeclaration && !_acceptedTerms.contains(slot.id)) {
      return false;
    }
    return true;
  }

  bool get _allComplete => _slots.isNotEmpty && _slots.every(_isSlotComplete);

  String get _description =>
      widget.proof.referenceDescription ??
      AppI18n.current.documentPersonProofDescription(
        widget.proof.proofName ?? '',
      );

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
        // trocou o tipo: o arquivo e o aceite anteriores não valem mais
        _pickedFiles.remove(slot.id);
        _acceptedTerms.remove(slot.id);
      }
      _selectedOptions[slot.id] = selected;
    });
  }

  Future<void> _onUpload(ProofDocumentEntity slot) async {
    final option = _selectedOptions[slot.id];
    if (option == null) return;

    final picked = await widget.onPickFile();
    if (picked == null || !mounted) return;

    final confirmed =
        await Navigator.of(context).push<DocumentProofPreviewResult>(
      MaterialPageRoute(
        builder: (_) => DocumentProofPreviewPage(
          documentTitle: option.name ?? widget.proof.proofName ?? '',
          fileName: picked.fileName,
          filePath: picked.filePath,
          onReplace: widget.onPickFile,
        ),
      ),
    );
    if (confirmed == null || !mounted) return;

    setState(() => _pickedFiles[slot.id] = confirmed);

    if (!_needsConfirmButton && _allComplete) {
      Navigator.of(context).pop(_pickedFiles);
    }
  }

  Widget _buildSlot(ProofDocumentEntity slot) {
    final i18n = AppI18n.current;
    final option = _selectedOptions[slot.id];
    final picked = _pickedFiles[slot.id];
    final hasFile = picked != null || slot.hasFile;

    final String label;
    if (picked != null) {
      label = picked.fileName;
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
        _UploadButton(
          label: label,
          isUploaded: hasFile,
          onPressed: option == null ? null : () => _onUpload(slot),
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
        child: Column(
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
            if (_needsConfirmButton)
              Padding(
                padding: const EdgeInsets.all(16),
                child: EbolsaButton(
                  onPressed: _allComplete
                      ? () => Navigator.of(context).pop(_pickedFiles)
                      : null,
                  label: i18n.confirmAction,
                ),
              ),
          ],
        ),
      ),
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
