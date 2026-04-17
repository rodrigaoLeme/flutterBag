import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../../agenda/agenda_view_model.dart';
import 'schedule_items_cell.dart';

class ScheduleItemsSection extends StatefulWidget {
  final ScheduleSectionViewModel? currentSection;
  final Function(ScheduleViewModel?) goToDetails;

  const ScheduleItemsSection({
    super.key,
    required this.currentSection,
    required this.goToDetails,
  });

  @override
  State<ScheduleItemsSection> createState() => _ScheduleItemsSectionState();
}

class _ScheduleItemsSectionState extends State<ScheduleItemsSection> {
  final Map<int, GlobalKey> _itemKeys = {};
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToItemIndex(widget.currentSection?.currentIndex ?? 0);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToItemIndex(int index) {
    if (!_scrollController.hasClients) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      if (index == 0) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        return;
      }

      final key = _itemKeys[index];
      if (key?.currentContext == null) return;

      final RenderBox? renderBox =
          key!.currentContext!.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final itemPosition = renderBox
          .localToGlobal(Offset.zero,
              ancestor: _scrollController.position.context.notificationContext
                  ?.findRenderObject())
          .dy;

      final targetOffset = _scrollController.offset + itemPosition;

      _scrollController.animateTo(
        targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  GlobalKey _getKeyForIndex(int index) {
    if (!_itemKeys.containsKey(index)) {
      _itemKeys[index] = GlobalKey();
    }
    return _itemKeys[index]!;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GcText(
          text: widget.currentSection?.headerTitle ?? '',
          textSize: GcTextSizeEnum.h4w500,
          textStyleEnum: GcTextStyleEnum.bold,
          color: AppColors.neutralLowDark,
          gcStyles: GcStyles.poppins,
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            itemCount: widget.currentSection?.itens.length ?? 0,
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) {
              final section = widget.currentSection?.itens[index];
              if (section == null) {
                return const SizedBox.shrink();
              }

              return Container(
                key: _getKeyForIndex(index),
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GcText(
                          text: section.title,
                          textSize: GcTextSizeEnum.headline,
                          textStyleEnum: GcTextStyleEnum.bold,
                          gcStyles: GcStyles.poppins,
                          color: AppColors.neutralLowDark,
                        ),
                        const SizedBox(width: 8),
                        if (section.showLiveBadge == true)
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            padding: const EdgeInsets.symmetric(
                              vertical: 1.0,
                              horizontal: 6.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: GcText(
                              text: R.string.liveLabel,
                              textSize: GcTextSizeEnum.caption1,
                              textStyleEnum: GcTextStyleEnum.bold,
                              gcStyles: GcStyles.poppins,
                              color: AppColors.white,
                            ),
                          ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: section.filter.length,
                      itemBuilder: (BuildContext context, int itemIndex) {
                        final item = section.filter[itemIndex];
                        return Padding(
                          padding: const EdgeInsets.only(top: 4, left: 16),
                          child: ScheduleItemsCell(
                            viewModel: item,
                            goToDetails: widget.goToDetails,
                          ),
                        );
                      },
                    ),
                    if (index != (widget.currentSection?.itens.length ?? 0) - 1)
                      const Divider(color: AppColors.neutralLight),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
