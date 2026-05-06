import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../main/i18n/app_i18n.dart';
import '../helpers/themes/themes.dart';
import '../modules/home/home_tabs.dart';

class EbolsaNavBar extends StatelessWidget {
  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;

  const EbolsaNavBar({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavBarItem(
            iconPath: AppIcons.noticeIcon,
            label: appStrings.navBarNoticesLabel,
            isSelected: currentTab == HomeTab.notices,
            onTap: () => onTabSelected(HomeTab.notices),
          ),
          _NavBarItem(
            iconPath: AppIcons.homeIcon,
            label: appStrings.navBarHomeLabel,
            isSelected: currentTab == HomeTab.process,
            onTap: () => onTabSelected(HomeTab.process),
          ),
          _NavBarItem(
            iconPath: AppIcons.profileIcon,
            label: appStrings.navBarProfileLabel,
            isSelected: currentTab == HomeTab.profile,
            onTap: () => onTabSelected(HomeTab.profile),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
            ),
            child: SvgPicture.asset(
              iconPath,
              color: isSelected ? Colors.white : AppColors.textSecondaryLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
