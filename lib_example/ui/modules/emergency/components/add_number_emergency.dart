import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';

class AddNumberEmergency extends StatelessWidget {
  const AddNumberEmergency({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 325,
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.close,
                color: AppColors.primaryLight,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GcText(
                text: R.string.addPhoneLabel,
                textSize: GcTextSizeEnum.h3,
                textStyleEnum: GcTextStyleEnum.bold,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8.0, left: 16.0, bottom: 12.0),
              child: GcText(
                text: R.string.phoneNumberLabel,
                textSize: GcTextSizeEnum.callout,
                textStyleEnum: GcTextStyleEnum.regular,
                color: AppColors.black,
                gcStyles: GcStyles.poppins,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).disabledColor),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Theme.of(context).disabledColor),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check,
                        color: AppColors.white,
                      ),
                      const SizedBox(width: 8.0),
                      GcText(
                        text: R.string.save,
                        textSize: GcTextSizeEnum.body,
                        textStyleEnum: GcTextStyleEnum.bold,
                        color: AppColors.white,
                        gcStyles: GcStyles.poppins,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
