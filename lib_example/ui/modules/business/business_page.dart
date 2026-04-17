import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/navigation_manager.dart';
import '../dashboard/section_view_model.dart';
import '../voting/component/user_voting_section.dart';
import '../voting/component/votings_stories_page.dart';
import 'business_presenter.dart';
import 'components/menu_item_section.dart';

class BusinessPage extends StatefulWidget {
  final BusinessPresenter presenter;

  const BusinessPage({
    super.key,
    required this.presenter,
  });

  @override
  BusinessPageState createState() => BusinessPageState();
}

class BusinessPageState extends State<BusinessPage> with NavigationManager {
  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToStream);
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
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
            text: R.string.businessLabel,
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: Builder(
        builder: (context) {
          widget.presenter.fetchVotings();

          return ValueListenableBuilder(
            valueListenable: widget.presenter.votingViewModel,
            builder: (context, snapshotVoting, _) {
              final votingViewModel = snapshotVoting;
              if (votingViewModel == null) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    if (votingViewModel.votings.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          left: 16,
                          right: 16,
                          bottom: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: GcText(
                                text: R.string.votingResultsLabel,
                                textSize: GcTextSizeEnum.h3,
                                textStyleEnum: GcTextStyleEnum.bold,
                                color: AppColors.black,
                                gcStyles: GcStyles.poppins,
                                maxLines: 2,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                widget.presenter.goToVoting();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.neutralLight,
                                elevation: 0,
                              ),
                              child: GcText(
                                text: R.string.seeAllButon,
                                textSize: GcTextSizeEnum.subhead,
                                textStyleEnum: GcTextStyleEnum.regular,
                                color: AppColors.primaryLight,
                                gcStyles: GcStyles.poppins,
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (votingViewModel.votings.isNotEmpty)
                      SizedBox(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: UserVotingSection(
                            viewModel: votingViewModel,
                            onTap: (votingItem) {
                              final allViewModels = votingViewModel.votings;
                              final index = allViewModels.indexOf(votingItem);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VotingStoriesPage(
                                    viewModels: allViewModels,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    if (votingViewModel.votings.isNotEmpty)
                      const Divider(
                        color: AppColors.neutralHighMedium,
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 16.0,
                        right: 16.0,
                        top: 24.0,
                      ),
                      child: MenuItemSection(
                        sections: const [
                          SectionType.schedule,
                          SectionType.documents,
                          SectionType.resources,
                        ],
                        onTap: (sectionType) {
                          switch (sectionType) {
                            case SectionType.schedule:
                              widget.presenter.goToAgenda();
                              break;
                            case SectionType.documents:
                              widget.presenter.goToDocuments();
                              break;
                            case SectionType.resources:
                              widget.presenter.goToBrochures();
                              break;
                            default:
                              break;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
