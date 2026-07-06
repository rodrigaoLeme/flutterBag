import 'package:flutter/material.dart';

import '../../../../../helpers/themes/themes.dart';

class MemberRegistrationSubStepNav extends StatelessWidget {
  const MemberRegistrationSubStepNav({
    super.key,
    required this.navTitle,
    required this.canGoBack,
    required this.canGoForward,
    required this.onBack,
    required this.onForward,
  });

  final String navTitle;
  final bool canGoBack;
  final bool canGoForward;
  final VoidCallback onBack;
  final VoidCallback onForward;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        children: [
          _NavArrow(
            icon: Icons.arrow_back,
            isEnabled: canGoBack,
            onTap: onBack,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Center(
              child: Text(navTitle, style: AppTextStyles.titleLarge),
            ),
          ),
          const SizedBox(width: 12),
          _NavArrow(
            icon: Icons.arrow_forward,
            isEnabled: canGoForward,
            onTap: onForward,
          ),
        ],
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  const _NavArrow({
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  final IconData icon;
  final bool isEnabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primary : AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : AppColors.outline,
        ),
      ),
    );
  }
}
