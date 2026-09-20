import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/themes/themes.dart';

class EbolsaMemberCard extends StatelessWidget {
  final bool isResponsible;
  final String? tag;
  final String? headerTitle;
  final String title;
  final String? subtitle;
  final List<Widget> content;

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const EbolsaMemberCard({
    super.key,
    this.isResponsible = false,
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
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
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
                      if (headerTitle != null)
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
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.primaryOutline,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(tag!, style: AppTextStyles.labelMedium),
                        ),
                        const SizedBox(height: 5),
                      ],
                      Text(
                        title,
                        style: AppTextStyles.bodyLarge,
                      ),
                      if (subtitle != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            subtitle!,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 2),
                      ],
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
                          AppIcons.editIcon,
                          width: 20,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      if (!isResponsible) ...{
                        SizedBox(width: 8),
                        GestureDetector(
                          onTap: onDelete,
                          child: SvgPicture.asset(
                            AppIcons.deleteIcon,
                            width: 20,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      }
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
