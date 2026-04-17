import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../presentation/mixins/push_fullscreen_manager.dart';
import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/navigation_manager.dart';
import '../../mixins/push_fullscreen_manager.dart';
import '../dashboard/section_view_model.dart';
import 'components/menu_more_section.dart';
import 'components/select_language_modal.dart';
import 'menu_presenter.dart';

class MenuPage extends StatefulWidget {
  final MenuPresenter presenter;

  const MenuPage({
    super.key,
    required this.presenter,
  });

  @override
  MenuPageState createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> with NavigationManager {
  @override
  void initState() {
    PushFullscreenManagerListener.handleFullScreen(
        context, PushFullscreenManager().isShowingStream);
    widget.presenter.loadSections();
    super.initState();
    widget.presenter.loadData();
    widget.presenter.loadDataSpiritual();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        handleNavigation(widget.presenter.navigateToStream);
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            backgroundColor: AppColors.primaryLight,
            title: Align(
              alignment: Alignment.centerLeft,
              child: GcText(
                text: R.string.more,
                textStyleEnum: GcTextStyleEnum.regular,
                textSize: GcTextSizeEnum.h3w5,
                color: AppColors.white,
                gcStyles: GcStyles.poppins,
              ),
            ),
          ),
          body: Column(
            children: [
              ValueListenableBuilder(
                valueListenable: widget.presenter.translationViewModel,
                builder: (context, snapshot, _) {
                  final viewModel = snapshot;
                  if (viewModel == null ||
                      viewModel.isTranslateEnable == false) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 16, left: 16, bottom: 8, right: 16),
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              widget.presenter.chooseEvent();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryLight,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                GcText(
                                  text: R.string.otherEvents,
                                  textStyleEnum: GcTextStyleEnum.regular,
                                  textSize: GcTextSizeEnum.h3w5,
                                  color: AppColors.white,
                                  gcStyles: GcStyles.poppins,
                                ),
                                const SizedBox(width: 12),
                                SvgPicture.asset(
                                  'lib/ui/assets/images/arrows-repeat.svg',
                                  height: 16,
                                  width: 16,
                                  color: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(16.0),
                                  ),
                                ),
                                builder: (context) => SelectLanguageModal(
                                  presenter: widget.presenter,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                ClipOval(
                                  child: Image.asset(
                                    viewModel.currentLanguage?.flag ?? '',
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.neutralLowDark,
                                  size: 32,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              StreamBuilder<SectionsViewModel?>(
                stream: widget.presenter.viewModel,
                builder: (context, snapshot) {
                  final sectionViewModel = snapshot.data;
                  if (sectionViewModel == null) {
                    return const SizedBox.shrink();
                  }
                  return Expanded(
                    child: MenuMoreSection(
                      viewModel: sectionViewModel,
                      onTap: (section) {
                        if (section != null) {
                          widget.presenter.routeToBy(section);
                        }
                      },
                      presenter: widget.presenter,
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
