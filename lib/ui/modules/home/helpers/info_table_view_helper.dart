import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../helpers/themes/themes.dart';

class InfoRow2Col extends StatelessWidget {
  final String label1;
  final String value1;
  final String label2;
  final String value2;

  const InfoRow2Col({
    super.key,
    required this.label1,
    required this.value1,
    required this.label2,
    required this.value2,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InfoCol(
            label: label1,
            child: Text(
              value1,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: InfoCol(
            label: label2,
            child: Text(
              value2,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class InfoCol extends StatelessWidget {
  final String label;
  final Widget child;

  const InfoCol({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w500,
              ),
        ),
        const SizedBox(height: 5),
        child,
      ],
    );
  }
}

class DetailNavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool dangerZone;
  final VoidCallback onTap;

  const DetailNavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.dangerZone = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: SvgPicture.asset(
        icon,
        width: 18,
        height: 18,
        color:
            (!dangerZone) ? AppColors.surfaceColor : AppColors.errorContainer,
      ),
      title: Text(
        label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w400,
              color: (!dangerZone)
                  ? AppColors.onSurface
                  : AppColors.errorContainer,
            ),
      ),
      trailing: SvgPicture.asset(
        AppIcons.arrowRightIconFill,
        width: 5,
        height: 10,
        color: (!dangerZone) ? AppColors.onSurface : AppColors.errorContainer,
      ),
      onTap: onTap,
    );
  }
}
