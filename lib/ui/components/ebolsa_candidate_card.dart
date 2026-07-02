import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../helpers/themes/app_colors.dart';
import '../helpers/themes/app_text_styles.dart';

class CandidateCard extends StatelessWidget {
  final String name;
  final String unit;
  final String grade;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const CandidateCard({
    super.key,
    required this.name,
    required this.unit,
    required this.grade,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            const TextSpan(
                              text: 'Unidade: ',
                              style: AppTextStyles.bodyMedium,
                            ),
                            TextSpan(text: unit),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            const TextSpan(
                              text: 'Curso/Série pretendido: ',
                              style: AppTextStyles.bodyMedium,
                            ),
                            TextSpan(text: grade),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (onDelete != null)
                  GestureDetector(
                    onTap: onDelete,
                    child: SvgPicture.asset(
                      'lib/ui/assets/icons/delete_icon.svg',
                      width: 24,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Divider(
              thickness: 3,
              color: Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
