import 'package:flutter/material.dart';

import '../../../../../domain/entities/proof_document_entity.dart';
import '../../../../../domain/entities/proof_slot_submission.dart';
import '../../../../../domain/entities/scholarship_proof_entity.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_check_proofs_icons.dart';
import '../../../../helpers/themes/themes.dart';
import 'document_proof_preview_page.dart';
import 'document_proof_send_page.dart';
import 'proof_guidance.dart';

class DocumentProofSlotsPage extends StatefulWidget {
  final String proofId;
  final ScholarshipProofEntity? Function(String proofId) findProof;
  final Future<void> Function() refresh;
  final Future<List<DocumentProofPreviewResult>> Function() onPickFiles;
  final Future<bool> Function(
      String proofDocumentId, ProofSlotSubmission submission) onUploadSlot;

  const DocumentProofSlotsPage({
    super.key,
    required this.proofId,
    required this.findProof,
    required this.refresh,
    required this.onPickFiles,
    required this.onUploadSlot,
  });

  @override
  State<DocumentProofSlotsPage> createState() => _DocumentProofSlotsPageState();
}

class _DocumentProofSlotsPageState extends State<DocumentProofSlotsPage> {
  Future<void> _openSlot(
    ScholarshipProofEntity proof,
    ProofDocumentEntity slot,
  ) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => DocumentProofSendPage(
          proof: proof,
          slot: slot,
          onPickFiles: widget.onPickFiles,
          onUploadSlot: widget.onUploadSlot,
        ),
      ),
    );
    if (!mounted) return;
    await widget.refresh();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final proof = widget.findProof(widget.proofId);

    if (proof == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).maybePop();
      });
      return const Scaffold(body: SizedBox.shrink());
    }

    final reference = proof.referenceDescription;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.documentProofSubmitAppBarTitle),
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          children: [
            Text(proof.proofName ?? '', style: AppTextStyles.titleLarge),
            if (reference != null && reference.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(reference, style: AppTextStyles.bodyMedium),
            ],
            const SizedBox(height: 12),
            ProofGuidance(markdown: proof.guidanceMarkdown),
            const SizedBox(height: 24),
            for (final slot in proof.scholarshipProofDocuments) ...[
              _SlotRow(
                title: slot.displayName(i18n.documentTypeChoice),
                slot: slot,
                onTap: () => _openSlot(proof, slot),
              ),
              const Divider(height: 1),
            ],
          ],
        ),
      ),
    );
  }
}

class _SlotRow extends StatelessWidget {
  final String title;
  final ProofDocumentEntity slot;
  final VoidCallback onTap;

  const _SlotRow({
    required this.title,
    required this.slot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final needsReview = slot.lastReviewInvalid;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: (needsReview || slot.hasFile)
          ? EbolsaCheckProofsIcons(
              needsReview: needsReview, isComplete: slot.hasFile)
          : null,
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: (slot.hasFile && (slot.filename?.isNotEmpty ?? false))
          ? Text(
              slot.filename!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySmall,
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
