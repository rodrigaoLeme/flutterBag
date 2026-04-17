import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../modules.dart';
import '../voting/component/user_voting_section.dart';
import '../voting/component/votings_stories_page.dart';

class NewsPage extends StatefulWidget {
  final NewsPresenter presenter;

  const NewsPage({
    super.key,
    required this.presenter,
  });

  @override
  NewsPageState createState() => NewsPageState();
}

class NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    widget.presenter.loadData();
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
            text: R.string.newsLabel,
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: StreamBuilder<NewsListViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (viewModel == null) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/newspaper.svg',
              title: R.string.messageEmpty,
            );
          }

          return Builder(
            builder: (context) {
              widget.presenter.fetchVotings();
              return ValueListenableBuilder(
                valueListenable: widget.presenter.votingViewModel,
                builder: (context, snapshotVoting, _) {
                  final votingViewModel = snapshotVoting;
                  if (votingViewModel == null) {
                    return const SizedBox.shrink();
                  }

                  final isEmpty = viewModel.newsList.isEmpty == true;
                  return isEmpty
                      ? EmptyState(
                          icon: 'lib/ui/assets/images/icon/newspaper.svg',
                          title: R.string.messageEmpty,
                        )
                      : SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (votingViewModel.votings.isNotEmpty ==
                                    true) ...[
                                  SizedBox(
                                    child: UserVotingSection(
                                      viewModel: votingViewModel,
                                      onTap: (votingItem) {
                                        final allViewModels =
                                            votingViewModel.votings;
                                        final index =
                                            allViewModels.indexOf(votingItem);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                VotingStoriesPage(
                                              viewModels: allViewModels,
                                              initialIndex: index,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16.0),
                                    child: Divider(
                                      color: AppColors.neutralHighMedium,
                                      height: 1,
                                    ),
                                  ),
                                ],
                                NewsSection(viewModel: viewModel),
                              ],
                            ),
                          ),
                        );
                },
              );
            },
          );
        },
      ),
    );
  }
}
