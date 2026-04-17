import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/mixins.dart';
import '../modules.dart';

class ProfilePage extends StatelessWidget with NavigationManager {
  final ProfilePresenter presenter;

  const ProfilePage({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryLight,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.translucent,
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: GcText(
            text: R.string.profile,
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: GcText(
              text: R.string.logout,
              textStyleEnum: GcTextStyleEnum.semibold,
              textSize: GcTextSizeEnum.callout,
              color: AppColors.white,
              gcStyles: GcStyles.poppins,
            ),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        handleNavigation(presenter.navigateToStream);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.account_circle,
                size: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GcText(
                  text: 'Pr. Jonas Williams',
                  textStyleEnum: GcTextStyleEnum.semibold,
                  textSize: GcTextSizeEnum.h3,
                  color: AppColors.neutralLowDark,
                  gcStyles: GcStyles.poppins,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0, top: 32.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neutralLight,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                      ),
                      onPressed: presenter.goToEditProfile,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/ui/assets/images/icon/square_light.svg',
                            color: AppColors.primaryLight,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 12.0),
                          GcText(
                            text: R.string.editProfile,
                            textStyleEnum: GcTextStyleEnum.regular,
                            textSize: GcTextSizeEnum.body,
                            color: AppColors.primaryLight,
                            gcStyles: GcStyles.poppins,
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.neutralLight,
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        surfaceTintColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const UserIdPage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'lib/ui/assets/images/icon/share-nodes-light.svg',
                            color: AppColors.primaryLight,
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 12.0),
                          GcText(
                            text: R.string.share,
                            textStyleEnum: GcTextStyleEnum.regular,
                            textSize: GcTextSizeEnum.body,
                            color: AppColors.primaryLight,
                            gcStyles: GcStyles.poppins,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: ProfileInfoSection(),
              ),
            ],
          ),
        );
      }),
    );
  }
}
