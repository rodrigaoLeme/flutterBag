import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../modules.dart';
import 'schedule_section.dart';

class EventSection extends StatefulWidget {
  final ScheduleTabs? viewModel;
  final void Function(ScheduleViewModel?) onPressed;
  final void Function(ScheduleViewModel?) goToDetails;
  final ScrollController? scrollController;

  const EventSection({
    super.key,
    required this.viewModel,
    required this.onPressed,
    required this.goToDetails,
    this.scrollController,
  });

  @override
  State<EventSection> createState() => _EventSectionState();
}

class _EventSectionState extends State<EventSection> {
  Map<String, GlobalKey> itemKeys = {};
  bool firstScroll = true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String key = widget.viewModel?.globalKey ?? '';
      scrollToIndex(key);
    });
  }

  void scrollToIndex(String key) {
    final context = itemKeys[key]?.currentContext;
    if (context != null && firstScroll) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      firstScroll = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      itemCount: widget.viewModel?.filter.length,
      itemBuilder: (BuildContext context, int index) {
        final item = widget.viewModel?.filter[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: GcText(
                text: item?.headerTitle ?? '',
                textSize: GcTextSizeEnum.h3,
                textStyleEnum: GcTextStyleEnum.bold,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
            ),
            ListView.builder(
              itemCount: item?.itens.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.only(top: 24.0),
              itemBuilder: (BuildContext context, int index) {
                final scheduleViewModel = item?.itens[index];
                final globalKey = GlobalKey();
                itemKeys[scheduleViewModel?.title ?? ''] = globalKey;
                return Container(
                  key: globalKey,
                  child: ScheduleSection(
                    viewModel: scheduleViewModel,
                    onPressed: widget.onPressed,
                    goToDetails: widget.goToDetails,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
