import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/input_placeholder.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../food/components/filter_costum.dart';
import '../modules.dart';
import 'component/filter_institutions_modal.dart';
import 'component/user_list_cell.dart';

class VotingPage extends StatefulWidget {
  final VotingPresenter presenter;

  const VotingPage({
    super.key,
    required this.presenter,
  });

  @override
  VotingPageState createState() => VotingPageState();
}

class VotingPageState extends State<VotingPage> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    widget.presenter.loadData();
    widget.presenter.clealAllFilters;
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    _controller.dispose();
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
            text: R.string.votingLabel,
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: StreamBuilder<VotingsViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (viewModel == null) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/check-to-slot.svg',
              title: R.string.messageEmpty,
            );
          }

          final isEmpty = viewModel.votings.isEmpty == true;
          return isEmpty
              ? EmptyState(
                  icon: 'lib/ui/assets/images/icon/check-to-slot.svg',
                  title: R.string.messageEmpty,
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16.0),
                      child: InputPlaceholder(
                        controller: _controller,
                        onChanged: (text) {
                          widget.presenter.filterVotingBy(text, viewModel);
                        },
                        hint: R.string.searchVoting,
                        iconLeading: GestureDetector(
                          onTap: () {
                            _controller.clear();
                            widget.presenter.filterVotingBy('', viewModel);
                          },
                          child: const Icon(
                            Icons.search,
                            color: AppColors.neutralLowMedium,
                          ),
                        ),
                        style: const TextStyle(
                          color: AppColors.neutralHigh,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                        ),
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.neutralLowMedium,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 48,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 42,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: viewModel
                                            .selectedDivisionGroups.length +
                                        1,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16.0),
                                          child: FilterCostum(
                                            text: R.string.filtersLabel,
                                            customIcon: SvgPicture.asset(
                                              'lib/ui/assets/images/icon/filter-list-regular.svg',
                                              height: 16,
                                              width: 16,
                                              color: AppColors.white,
                                            ),
                                            backgroundColor:
                                                _selectedIndex.value == 0
                                                    ? AppColors.primaryLight
                                                    : AppColors.neutralLight,
                                            textColor: _selectedIndex.value == 1
                                                ? AppColors.primaryLight
                                                : AppColors.white,
                                            onTap: () {
                                              _selectedIndex.value = 0;
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder: (context) =>
                                                    FilterInstitutionsModal(
                                                  presenter: widget.presenter,
                                                  viewModel: viewModel,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }
                                      final safeIndex = index - 1;

                                      final divisionGroup = viewModel
                                          .selectedDivisionGroups[safeIndex];

                                      return Padding(
                                        padding: EdgeInsets.only(
                                          left: 8,
                                          right: viewModel
                                                      .selectedDivisionGroups
                                                      .length ==
                                                  index
                                              ? 16
                                              : 0,
                                        ),
                                        child: FilterCostum(
                                          text: divisionGroup.divisionAcronym,
                                          icon: Icons.close,
                                          backgroundColor:
                                              !divisionGroup.isSelected
                                                  ? AppColors.neutralLight
                                                  : AppColors.primaryLight,
                                          textColor: divisionGroup.isSelected
                                              ? AppColors.white
                                              : AppColors.primaryLight,
                                          onTap: () {
                                            widget.presenter.setFilter(
                                                viewModel, divisionGroup);
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                final sections =
                                    snapshot.data?.selectedSections ?? [];

                                final hasData = sections.any((section) =>
                                    section.itensFiltered.isNotEmpty);

                                if (!hasData) {
                                  return Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(32),
                                      child: Column(
                                        children: [
                                          EmptyState(
                                            icon:
                                                'lib/ui/assets/images/icon/lupa.svg',
                                            title: R.string.messageEmptyVoting,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                                return ListView.builder(
                                  itemCount:
                                      sections.fold<int>(0, (count, section) {
                                    if (section.itensFiltered.isEmpty) {
                                      return count;
                                    }
                                    return count +
                                        1 +
                                        section.itensFiltered.length;
                                  }),
                                  itemBuilder: (context, index) {
                                    int runningIndex = 0;
                                    for (final section in sections) {
                                      if (section.itensFiltered.isEmpty) {
                                        continue;
                                      }

                                      if (index == runningIndex) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 16.0,
                                            left: 16.0,
                                          ),
                                          child: GcText(
                                            text: section.title,
                                            textSize: GcTextSizeEnum.h3,
                                            textStyleEnum: GcTextStyleEnum.bold,
                                            color: AppColors.black,
                                            gcStyles: GcStyles.poppins,
                                          ),
                                        );
                                      }

                                      final itemIndex =
                                          index - runningIndex - 1;
                                      if (itemIndex >= 0 &&
                                          itemIndex <
                                              section.itensFiltered.length) {
                                        final item =
                                            section.itensFiltered[itemIndex];
                                        return UserListCell(viewModel: item);
                                      }

                                      runningIndex +=
                                          1 + section.itensFiltered.length;
                                    }

                                    return const SizedBox.shrink();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
