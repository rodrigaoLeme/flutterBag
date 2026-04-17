import 'package:flutter/material.dart';

import '../../../../../share/utils/app_color.dart';
import '../../../components/empty_state.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../../../mixins/mixins.dart';
import '../spiritual_view_model.dart';
import 'components/devotional_details_page.dart';
import 'devotional_presenter.dart';

class DevotionalPage extends StatefulWidget {
  final DevotionalPresenter presenter;
  const DevotionalPage({
    super.key,
    required this.presenter,
  });

  @override
  DevotionalPageState createState() => DevotionalPageState();
}

class DevotionalPageState extends State<DevotionalPage> with NavigationManager {
  @override
  void initState() {
    super.initState();
    widget.presenter.convinienceInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            text: R.string.devotionalLabel,
            gcStyles: GcStyles.poppins,
            textSize: GcTextSizeEnum.h3w5,
            textStyleEnum: GcTextStyleEnum.regular,
            color: AppColors.white,
          ),
        ),
      ),
      body: StreamBuilder<SpiritualViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (viewModel == null) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/book-open-cover.svg',
              title: R.string.messageEmpty,
            );
          }
          final isEmpty = viewModel.devotional.isEmpty;
          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                TabBar(
                  indicatorColor: AppColors.primaryLight,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: AppColors.primaryLight,
                  labelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: [
                    Tab(text: R.string.morningLabel),
                    Tab(text: R.string.afternoonLabel),
                    Tab(text: R.string.eveningLabel.toUpperCase()),
                  ],
                ),
                Expanded(
                  child: isEmpty
                      ? EmptyState(
                          icon: 'lib/ui/assets/images/icon/book-open-cover.svg',
                          title: R.string.messageEmpty,
                        )
                      : TabBarView(
                          children: [
                            DevotionalDetailsPage(
                              viewModel: viewModel.morningDevotional,
                              onTap: (filter) {
                                if (filter != null) {
                                  widget.presenter.filterBy(
                                    filter: filter,
                                    spiritualViewModel: viewModel,
                                    type: DevotionalDayPeriod.morning,
                                  );
                                  setState(() {});
                                }
                              },
                              onTapLanguage: (filter) {
                                if (filter != null) {
                                  widget.presenter.setCurrentLanguageFilter(
                                    filter: filter,
                                    type: DevotionalDayPeriod.morning,
                                    spiritualViewModel: viewModel,
                                  );
                                }
                              },
                            ),
                            DevotionalDetailsPage(
                              viewModel: viewModel.afternoonDevotional,
                              onTap: (filter) {
                                if (filter != null) {
                                  widget.presenter.filterBy(
                                    filter: filter,
                                    spiritualViewModel: viewModel,
                                    type: DevotionalDayPeriod.afternoon,
                                  );
                                }
                              },
                              onTapLanguage: (filter) {
                                if (filter != null) {
                                  widget.presenter.setCurrentLanguageFilter(
                                    filter: filter,
                                    type: DevotionalDayPeriod.afternoon,
                                    spiritualViewModel: viewModel,
                                  );
                                }
                              },
                            ),
                            DevotionalDetailsPage(
                              viewModel: viewModel.eveningDevotional,
                              onTap: (filter) {
                                if (filter != null) {
                                  widget.presenter.filterBy(
                                    filter: filter,
                                    spiritualViewModel: viewModel,
                                    type: DevotionalDayPeriod.evening,
                                  );
                                }
                              },
                              onTapLanguage: (filter) {
                                if (filter != null) {
                                  widget.presenter.setCurrentLanguageFilter(
                                    filter: filter,
                                    type: DevotionalDayPeriod.evening,
                                    spiritualViewModel: viewModel,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
