import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../main/routes/routes_app.dart';
import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import '../business/components/menu_item_cell.dart';
import '../dashboard/section_view_model.dart';
import 'spiritual_presenter.dart';
import 'spiritual_view_model.dart';

class SpiritualPage extends StatefulWidget {
  final SpiritualPresenter presenter;
  const SpiritualPage({
    super.key,
    required this.presenter,
  });

  @override
  SpiritualPageState createState() => SpiritualPageState();
}

class SpiritualPageState extends State<SpiritualPage>
    with NavigationManager, LoadingManager {
  @override
  void initState() {
    handleLoading(context, widget.presenter.isLoadingStream);
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      widget.presenter.loadData();
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
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.white,
              ),
            ),
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: GcText(
              text: R.string.spiritualLabel,
              gcStyles: GcStyles.poppins,
              textSize: GcTextSizeEnum.h3w5,
              textStyleEnum: GcTextStyleEnum.semibold,
              color: AppColors.white,
            ),
          ),
        ),
        body: StreamBuilder<SpiritualViewModel?>(
          stream: widget.presenter.viewModel,
          builder: (context, snapshot) {
            final viewModel = snapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 12),
                  child: MenuItemCell(
                    type: SectionType.worship,
                    onTap: (_) {
                      widget.presenter
                          .goToDevotional(spiritualViewModel: viewModel);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 12),
                  child: MenuItemCell(
                    type: SectionType.music,
                    onTap: (_) {
                      widget.presenter.goToMusic(spiritualViewModel: viewModel);
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, top: 12),
                  child: MenuItemCell(
                      type: SectionType.prayerRoom,
                      onTap: (_) async {
                        final prayerRoomViewModel = viewModel?.prayerRoom;
                        final result = await Modular.to.pushNamed(
                          Routes.prayerRoom,
                          arguments: prayerRoomViewModel,
                        );
                        if (result == true) {
                          Modular.to.pop();
                        }
                      }),
                ),
              ],
            );
          },
        ),
      );
    });
  }
}
