import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../modules.dart';
import 'edit_profile_presenter.dart';

class EditProfilePage extends StatefulWidget {
  final EditProfilePresenter presenter;

  const EditProfilePage({super.key, required this.presenter});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
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
            text: R.string.editingProfileLabel,
            textSize: GcTextSizeEnum.h3,
            textStyleEnum: GcTextStyleEnum.regular,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0, bottom: 24.0),
                      child: Row(
                        children: [
                          const Icon(Icons.account_circle, size: 94),
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0),
                            child: TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ChangeImage();
                                  },
                                );
                              },
                              child: GcText(
                                text: R.string.changeImageLabel,
                                textSize: GcTextSizeEnum.callout,
                                textStyleEnum: GcTextStyleEnum.semibold,
                                color: AppColors.primaryLight,
                                gcStyles: GcStyles.poppins,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ProfileInput(
                      title: R.string.name,
                    ),
                    ProfileInput(
                      title: R.string.phone,
                    ),
                    ProfileInput(
                      title: R.string.email,
                    ),
                    ProfileInput(
                      title: R.string.entityLabel,
                    ),
                    ProfileInput(
                      title: R.string.linkedInLabel,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
              ),
              onPressed: () {},
              child: GcText(
                text: R.string.save,
                textSize: GcTextSizeEnum.h4,
                textStyleEnum: GcTextStyleEnum.semibold,
                color: AppColors.white,
                gcStyles: GcStyles.poppins,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextButton(
                onPressed: () {},
                child: GcText(
                  text: R.string.cancel,
                  textSize: GcTextSizeEnum.h4,
                  textStyleEnum: GcTextStyleEnum.semibold,
                  color: AppColors.primaryLight,
                  gcStyles: GcStyles.poppins,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
