import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/themes/themes.dart';
import 'document_group_item.dart';

class DocumentsStep extends StatefulWidget {
  final List<DocumentGroupItem> groups;
  final DateTime? submissionDeadline;
  final ValueChanged<DocumentGroupItem>? onGroupTap;

  const DocumentsStep({
    super.key,
    required this.groups,
    this.submissionDeadline,
    this.onGroupTap,
  });

  @override
  State<DocumentsStep> createState() => DocumentsStepState();
}

class DocumentsStepState extends State<DocumentsStep> {
  late List<DocumentGroupItem> _groups;
  bool _showDeadlineBanner = true;

  bool get canSendAllDocuments =>
      _groups.isNotEmpty && _groups.every((group) => group.isComplete);

  @override
  void initState() {
    super.initState();
    _groups = List<DocumentGroupItem>.from(widget.groups);
  }

  @override
  void didUpdateWidget(covariant DocumentsStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.groups != widget.groups) {
      _groups = List<DocumentGroupItem>.from(widget.groups);
    }
  }

  IconData _iconForType(DocumentGroupType type) {
    return switch (type) {
      DocumentGroupType.family => Icons.home_outlined,
      DocumentGroupType.candidate => Icons.school_outlined,
      DocumentGroupType.member => Icons.person_outline,
    };
  }

  String _progressLabel(DocumentGroupItem group) {
    return AppI18n.current.documentsProgressLabel(
      group.uploadedDocuments,
      group.totalDocuments,
    );
  }

  String? _formattedDeadline() {
    final deadline = widget.submissionDeadline;
    if (deadline == null) return null;

    final day = deadline.day.toString().padLeft(2, '0');
    final month = deadline.month.toString().padLeft(2, '0');
    return '$day/$month/${deadline.year}';
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;
    final deadline = _formattedDeadline();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(i18n.documentsStepTitle, style: AppTextStyles.titleLarge),
          const SizedBox(height: 8),
          Text(
            i18n.documentsStepDescription,
            style: AppTextStyles.bodyMedium,
          ),
          if (_showDeadlineBanner && deadline != null) ...[
            const SizedBox(height: 16),
            _buildDeadlineBanner(deadline),
          ],
          const SizedBox(height: 8),
          ..._buildGroupList(),
        ],
      ),
    );
  }

  Widget _buildDeadlineBanner(String deadline) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.warning,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppI18n.current.documentsDeadlineLabel(deadline),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _showDeadlineBanner = false),
            child: const Icon(
              Icons.cancel_outlined,
              size: 20,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGroupList() {
    return [
      for (var i = 0; i < _groups.length; i++) ...[
        InkWell(
          onTap: () => widget.onGroupTap?.call(_groups[i]),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Icon(
                  _iconForType(_groups[i].type),
                  color: _groups[i].isComplete
                      ? AppColors.success
                      : AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _groups[i].title,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: _groups[i].isComplete
                          ? AppColors.success
                          : AppColors.onSurface,
                    ),
                  ),
                ),
                Text(
                  _progressLabel(_groups[i]),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: _groups[i].isComplete
                        ? AppColors.success
                        : AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
        if (i < _groups.length - 1)
          const Divider(
            height: 1,
            thickness: 1,
            color: Color(0xFFB9BDC6),
          ),
      ],
    ];
  }
}
