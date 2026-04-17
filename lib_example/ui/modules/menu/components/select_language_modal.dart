import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../../../mixins/navigation_manager.dart';
import '../menu_presenter.dart';

class SelectLanguageModal extends StatefulWidget {
  final MenuPresenter presenter;

  const SelectLanguageModal({
    required this.presenter,
    super.key,
  });

  @override
  State<SelectLanguageModal> createState() => _SelectLanguageModalState();
}

class _SelectLanguageModalState extends State<SelectLanguageModal>
    with NavigationManager {
  @override
  void initState() {
    super.initState();
    handleNavigation(widget.presenter.navigateToStream);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (value, args) {
        widget.presenter.goToHome();
      },
      child: Container(
        padding: const EdgeInsets.all(22),
        height: 500,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0),
          ),
        ),
        child: Builder(
          builder: (context) {
            widget.presenter.loadData();
            return ValueListenableBuilder(
              valueListenable: widget.presenter.translationViewModel,
              builder: (context, snapshot, _) {
                final viewModel = snapshot;
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel?.languages.length ?? 0,
                        itemBuilder: (context, index) {
                          final lenguage = viewModel?.languages[index];
                          final isSelected = lenguage?.type ==
                              viewModel?.currentLanguage?.type;
                          return GestureDetector(
                            onTap: () {
                              if (lenguage != null) {
                                widget.presenter
                                    .chooseLenguage(language: lenguage);
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
                    SizedBox(
                      height: 48.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryLight,
                        ),
                        onPressed: () {
                          widget.presenter.goToHome();
                          Navigator.of(context).pop();
                        },
                        child: GcText(
                          text: R.string.next,
                          textSize: GcTextSizeEnum.h4,
                          textStyleEnum: GcTextStyleEnum.semibold,
                          color: AppColors.white,
                          gcStyles: GcStyles.poppins,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
