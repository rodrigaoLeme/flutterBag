import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../../dashboard/components/menu_cell.dart';
import '../../dashboard/section_view_model.dart';
import '../menu_presenter.dart';
import 'menu_more_cell.dart';

class MenuMoreSection extends StatelessWidget {
  final SectionsViewModel viewModel;
  final MenuPresenter presenter;

  final Function(SectionViewModel?) onTap;

  const MenuMoreSection({
    required this.viewModel,
    required this.onTap,
    required this.presenter,
    super.key,
  });

  Future<String> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String version = packageInfo.version.replaceFirst(RegExp(r'[-+].*$'), '');

    final versionNumber = 'App version $version';
    return versionNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        itemCount: viewModel.menuGroup.length + 1,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          if (index == viewModel.menuGroup.length) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: FutureBuilder(
                  future: getVersion(),
                  builder: (context, snapshot) {
                    return GcText(
                      text: snapshot.data ?? '',
                      gcStyles: GcStyles.poppins,
                      color: AppColors.neutralLowLight,
                      textSize: GcTextSizeEnum.footnote,
                    );
                  },
                ),
              ),
            );
          }

          final group = viewModel.menuGroup[index];
          if (group.group == null) {
            return const SizedBox.shrink();
          }

          if (group.type == MenuGroupType.bottomMenuGroup) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: SizedBox(
                height: 108,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          presenter.goToEmergency();
                        },
                        child: MenuCell(
                          title: R.string.emergencyLabel,
                          iconPath:
                              'lib/ui/assets/images/icon/truck-medical-regular.svg',
                          iconColor: AppColors.primaryLight,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: AppColors.primaryLight,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          presenter.goToSupport();
                        },
                        child: MenuCell(
                          title: R.string.faqLabel,
                          iconPath:
                              'lib/ui/assets/images/icon/comments-question-check-light.svg',
                          iconColor: AppColors.primaryLight,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                            color: AppColors.primaryLight,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GcText(
                  text: group.title,
                  textStyleEnum: GcTextStyleEnum.bold,
                  textSize: GcTextSizeEnum.h3,
                  color: AppColors.black,
                  gcStyles: GcStyles.poppins,
                ),
                const SizedBox(height: 8.0),
                ListView.builder(
                  itemCount: group.group?.length ?? 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final item = group.group?[index];
                    return GestureDetector(
                      onTap: () {
                        onTap(item);
                      },
                      child: MenuMoreCell(
                        viewModel: item,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
