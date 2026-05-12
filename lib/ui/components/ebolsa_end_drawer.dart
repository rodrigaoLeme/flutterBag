import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../data/cache/cache.dart';
import '../../main/di/injection_container.dart';
import '../../main/i18n/app_i18n.dart';
import '../../main/routes/auth_routes.dart';
import '../helpers/themes/themes.dart';
import '../modules/home/home_tabs.dart';

class EbolsaEndDrawer extends StatelessWidget {
  final HomeTab currentTab;
  final ValueChanged<HomeTab> onTabSelected;

  const EbolsaEndDrawer({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    final appsString = AppI18n.current;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(43, 24, 24, 18),
              child: Text(
                appsString.endDrawerTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondaryLight,
                    ),
              ),
            ),
            _DrawerItem(
              iconPaht: AppIcons.homeIcon,
              label: appsString.endDrawerHomeLabel,
              isSelected: currentTab == HomeTab.process,
              onTap: () {
                onTabSelected(HomeTab.process);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              iconPaht: AppIcons.noticeIcon,
              label: appsString.endDrawerNoticesLabel,
              isSelected: currentTab == HomeTab.notices,
              onTap: () {
                onTabSelected(HomeTab.notices);
                Navigator.pop(context);
              },
            ),
            _DrawerItem(
              iconPaht: AppIcons.profileIcon,
              label: appsString.endDrawerProfileLabel,
              isSelected: currentTab == HomeTab.profile,
              onTap: () {
                onTabSelected(HomeTab.profile);
                Navigator.pop(context);
              },
            ),
            const Divider(indent: 24, endIndent: 24),
            _DrawerItem(
              iconPaht: AppIcons.logoutIcon,
              label: appsString.endDrawerLogoutLabel,
              isSelected: false,
              onTap: () async {
                Navigator.pop(context);
                await sl<SecureStorage>().clean();
                Modular.to.navigate(AuthRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final String iconPaht;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerItem({
    required this.iconPaht,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: SvgPicture.asset(
            iconPaht,
            color: AppColors.textSecondaryLight,
          ),
        ),
        title: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
                fontWeight: FontWeight.w600,
              ),
        ),
        tileColor:
            isSelected ? AppColors.secondaryContainer : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onTap: onTap,
      ),
    );
  }
}
