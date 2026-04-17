import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../broadcast_presenter.dart';
import '../broadcast_view_model.dart';
import 'broadcast_select_language_modal.dart';

class VideoDetails extends StatelessWidget {
  final BroadcastPresenter presenter;
  final BroadcastsViewModel viewModel;

  const VideoDetails({
    Key? key,
    required this.viewModel,
    required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, bottom: 16, top: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GcText(
                  text: viewModel.currentVideo?.title ?? '',
                  textSize: GcTextSizeEnum.h2,
                  textStyleEnum: GcTextStyleEnum.bold,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.black,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16.0)),
                    ),
                    builder: (context) => BroadcastSelectLanguageModal(
                      presenter: presenter,
                      viewModel: viewModel,
                    ),
                  );
                },
                child: Row(
                  children: [
                    ClipOval(
                      child: Image.asset(
                        viewModel.languagePlayer?.flag ?? '',
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
      ],
    );
  }
}
