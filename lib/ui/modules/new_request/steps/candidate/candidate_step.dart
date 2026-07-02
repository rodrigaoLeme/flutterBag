import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/ebolsa_candidate_card.dart';
import '../../../../helpers/themes/themes.dart';

class CandidateStep extends StatefulWidget {
  final VoidCallback? onAddCandidate;
  final void Function(Map<String, dynamic> candidate)? onEditCandidate;
  final VoidCallback? onCandidatesChanged;

  const CandidateStep({
    super.key,
    this.onAddCandidate,
    this.onEditCandidate,
    this.onCandidatesChanged,
  });

  @override
  State<CandidateStep> createState() => CandidateStepState();
}

class CandidateStepState extends State<CandidateStep> {
  final List<Map<String, dynamic>> _candidates = [];

  bool get hasCandidates => _candidates.isNotEmpty;

  List<String> get addedMemberIds => _candidates
      .map((c) => c['familyMemberId']?.toString())
      .whereType<String>()
      .toList();

  List<Map<String, dynamic>> get candidates =>
      List<Map<String, dynamic>>.unmodifiable(_candidates);

  void addCandidate(Map<String, dynamic> candidate) {
    setState(() => _candidates.add(candidate));
    widget.onCandidatesChanged?.call();
  }

  void updateCandidate(Map<String, dynamic> candidate) {
    final memberId = candidate['familyMemberId']?.toString();
    final index = _candidates.indexWhere(
      (c) => c['familyMemberId']?.toString() == memberId,
    );
    if (index == -1) {
      addCandidate(candidate);
      return;
    }
    setState(() => _candidates[index] = candidate);
    widget.onCandidatesChanged?.call();
  }

  void removeCandidateAt(int index) {
    setState(() => _candidates.removeAt(index));
    widget.onCandidatesChanged?.call();
  }

  Future<void> _confirmDeleteCandidate(int index) async {
    final candidate = _candidates[index];
    final name = candidate['name']?.toString() ?? '';
    final i18n = AppI18n.current;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.backgroundLight,
        title: Text(
          i18n.candidateDeleteDialogTitle,
          style: AppTextStyles.titleLarge,
        ),
        content: Text(
          i18n.candidateDeleteDialogMessage(name),
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              i18n.answerNo,
              style: AppTextStyles.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              i18n.answerYes,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      removeCandidateAt(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(i18n.candidateStepTitle, style: AppTextStyles.titleLarge),
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
          _buildAddCandidateButton(),
          if (_candidates.isNotEmpty) ...[
            const SizedBox(height: 24),
            ..._buildCandidateCards(),
          ],
        ],
      ),
    );
  }

  Widget _buildAddCandidateButton() {
    return InkWell(
      onTap: widget.onAddCandidate,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 20, color: AppColors.onPrimaryContainer),
            const SizedBox(width: 8),
            Text(
              AppI18n.current.addCandidate,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCandidateCards() {
    return [
      for (var i = 0; i < _candidates.length; i++) ...[
        CandidateCard(
          name: _candidates[i]['name']?.toString() ?? '',
          unit: _candidates[i]['schoolName']?.toString() ?? '-',
          grade: _candidates[i]['gradeName']?.toString() ?? '-',
          onTap: () => widget.onEditCandidate?.call(_candidates[i]),
          onDelete: () => _confirmDeleteCandidate(i),
        ),
        const SizedBox(height: 12),
      ],
    ];
  }
}
