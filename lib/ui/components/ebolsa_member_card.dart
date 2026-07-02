import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/themes/themes.dart';

class EbolsaMemberCard extends StatelessWidget {
  final String? tag;
  final String? headerTitle;
  final String title;
  final String? subtitle;
  final List<Widget> content;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EbolsaMemberCard({
    super.key,
    this.tag,
    this.headerTitle,
    required this.title,
    this.subtitle,
    required this.content,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        headerTitle ?? '',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (tag != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 28,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFB9BDC6),
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            tag!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge,
                      ),
                      if (subtitle != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle!,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      const SizedBox(height: 8),
                      ...content,
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: onEdit,
                        child: SvgPicture.asset(
                          'lib/ui/assets/icons/edit.svg',
                          width: 20,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: onDelete,
                        child: SvgPicture.asset(
                          'lib/ui/assets/icons/delete_icon.svg',
                          width: 20,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Divider(
            color: Color(0xFFB9BDC6),
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
