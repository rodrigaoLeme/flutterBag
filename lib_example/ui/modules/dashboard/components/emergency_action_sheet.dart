import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import './components.dart';

class EmergencyActionSheet {
  static void show(
    BuildContext context,
    Function()? onPressed,
  ) {
    showModalBottomSheet(
      elevation: 0,
      backgroundColor: AppColors.shadow,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.0),
                topRight: Radius.circular(24.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Fecha o bottom sheet
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: GcText(
                  text: R.string.emergencyInformationLabel,
                  textSize: GcTextSizeEnum.h3,
                  textStyleEnum: GcTextStyleEnum.bold,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.black,
                ),
              ),
              const Expanded(
                child: EmergencySection(),
              ),
              ElevatedButton(
                onPressed: onPressed,
                child: const Text('Hello'),
              ),
            ],
          ),
        );
      },
    );
  }
}
