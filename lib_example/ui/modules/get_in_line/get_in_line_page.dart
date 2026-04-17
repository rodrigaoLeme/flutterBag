import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../modules.dart';

class GetInLinePage extends StatelessWidget {
  final GetInLinePresenter presenter;

  const GetInLinePage({
    super.key,
    required this.presenter,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            text: R.string.getLineLabel,
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: GcText(
                text: R.string.speakingLabel,
                textStyleEnum: GcTextStyleEnum.bold,
                textSize: GcTextSizeEnum.h3,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: SpeakerCell(),
            ),
            GcText(
              text: '9 in line',
              textStyleEnum: GcTextStyleEnum.bold,
              textSize: GcTextSizeEnum.h3,
              color: AppColors.black,
              gcStyles: GcStyles.poppins,
            ),
            const SizedBox(height: 24.0),
            const Expanded(
              child: SpeakerSection(),
            ),
          ],
        ),
      ),
    );
  }
}
