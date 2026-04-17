import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../notification_view_model.dart';
import 'notification_details.dart';

class NotificationCell extends StatefulWidget {
  final NotificationResultViewModel viewModel;
  final Function(NotificationResultViewModel) onTap;

  const NotificationCell({
    super.key,
    required this.viewModel,
    required this.onTap,
  });

  @override
  State<NotificationCell> createState() => _NotificationCellState();
}

class _NotificationCellState extends State<NotificationCell> {
  void _selectNotification() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => NotificationDetails(
        viewModel: widget.viewModel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap(widget.viewModel);
        _selectNotification();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12),
        decoration: BoxDecoration(
          color: widget.viewModel.isRead == true
              ? AppColors.white
              : AppColors.neutralLight,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.viewModel.isRead == false)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(top: 12, right: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
              ),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.white,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                widget.viewModel.iconUrl ?? '',
                color: AppColors.primaryLight,
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GcText(
                    text: widget.viewModel.title ?? '',
                    gcStyles: GcStyles.poppins,
                    textSize: GcTextSizeEnum.callout,
                    textStyleEnum: GcTextStyleEnum.bold,
                    color: AppColors.black,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  GcText(
                    text: widget.viewModel.body ?? '',
                    gcStyles: GcStyles.poppins,
                    textSize: GcTextSizeEnum.subheadline,
                    textStyleEnum: GcTextStyleEnum.regular,
                    color: AppColors.neutralLowMedium,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 4),
                  GcText(
                    text: widget.viewModel.formatNotificationDate,
                    textStyleEnum: GcTextStyleEnum.regular,
                    textSize: GcTextSizeEnum.subheadline,
                    color: AppColors.neutralLowMedium,
                    gcStyles: GcStyles.poppins,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
