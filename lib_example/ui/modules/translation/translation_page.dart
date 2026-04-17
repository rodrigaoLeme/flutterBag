import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/mixins.dart';
import 'components/translation_section.dart';
import 'translation_presenter.dart';
import 'translation_view_model.dart';

class TranslationPage extends StatefulWidget {
  final TranslationPresenter presenter;

  const TranslationPage({
    super.key,
    required this.presenter,
  });

  @override
  TranslationPageState createState() => TranslationPageState();
}

class TranslationPageState extends State<TranslationPage>
    with NavigationManager {
  @override
  void initState() {
    widget.presenter.convinienceInit();
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
      body: StreamBuilder<TranslationViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 56),
                  child: GcText(
                    text: R.string.selectLanguage,
                    gcStyles: GcStyles.poppins,
                    textSize: GcTextSizeEnum.h3,
                    textStyleEnum: GcTextStyleEnum.bold,
                    color: AppColors.neutralLowDark,
                    textAlign: TextAlign.center,
                  ),
                ),
                TranslationSection(
                  viewModel: snapshot.data,
                  onTap: (language) {
                    if (language != null) {
                      widget.presenter.chooseLenguage(language: language);
                    }
                  },
                ),
                ValueListenableBuilder(
                  valueListenable: widget.presenter.isFormEnable,
                  builder: (context, snapshot, _) {
                    return SizedBox(
                      height: 48.0,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: snapshot == true
                              ? AppColors.primaryLight
                              : AppColors.secondaryFixedDim,
                        ),
                        onPressed: () {
                          if (snapshot == true) {
                            widget.presenter.chooseEvent();
                          }
                        },
                        child: GcText(
                          text: R.string.next,
                          textSize: GcTextSizeEnum.h4,
                          textStyleEnum: GcTextStyleEnum.semibold,
                          color: AppColors.white,
                          gcStyles: GcStyles.poppins,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
