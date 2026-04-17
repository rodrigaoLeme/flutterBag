import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/responsive/responsive_layout.dart';
import '../broadcast_presenter.dart';
import '../broadcast_view_model.dart';

class BroadcastSelectLanguageModal extends StatefulWidget {
  final BroadcastPresenter presenter;
  final BroadcastsViewModel viewModel;

  const BroadcastSelectLanguageModal({
    required this.presenter,
    required this.viewModel,
    super.key,
  });

  @override
  State<BroadcastSelectLanguageModal> createState() =>
      _BroadcastSelectLanguageModal();
}

class _BroadcastSelectLanguageModal
    extends State<BroadcastSelectLanguageModal> {
  @override
  void initState() {
    super.initState();
    widget.presenter.languageBottomSheetInit(widget.viewModel);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      height: ResponsiveLayout.of(context).hp(45),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      child: Builder(builder: (context) {
        return ValueListenableBuilder(
            valueListenable: widget.presenter.broadcastLanguages,
            builder: (context, snapshot, _) {
              return Builder(
                builder: (context) {
                  final broadcastsViewModel = snapshot;
                  if (broadcastsViewModel == null) {
                    return const SizedBox.expand();
                  }
                  return Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 100,
                          height: 3,
                          decoration: const BoxDecoration(
                            color: AppColors.neutralLowMedium,
                            borderRadius: BorderRadius.all(Radius.circular(2)),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: broadcastsViewModel.languages?.length ?? 0,
                          itemBuilder: (context, index) {
                            final lenguage =
                                broadcastsViewModel.languages?[index];
                            final isSelected = lenguage?.type ==
                                broadcastsViewModel.language?.type;
                            return GestureDetector(
                              onTap: () {
                                if (lenguage != null) {
                                  widget.presenter.chooseLenguage(
                                    language: lenguage,
                                    viewModel: broadcastsViewModel,
                                  );
                                }
                              },
                              child: SizedBox(
                                height: 48.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ClipOval(
                                      child: Image.asset(
                                        lenguage?.flag ?? '',
                                        width: 24,
                                        height: 24,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: GcText(
                                        text: lenguage?.contryName ?? '',
                                        gcStyles: GcStyles.poppins,
                                        textSize: GcTextSizeEnum.callout,
                                        textStyleEnum: GcTextStyleEnum.regular,
                                        color: AppColors.neutralLowDark,
                                      ),
                                    ),
                                    if (isSelected)
                                      const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: Icon(
                                          Icons.check,
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              );
            });
      }),
    );
  }
}
