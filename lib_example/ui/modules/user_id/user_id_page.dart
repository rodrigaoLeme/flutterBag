import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../modules.dart';

class UserIdPage extends StatelessWidget {
  const UserIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: GcText(
            text: 'ID',
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.callout,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            UserDetails(),
            SizedBox(height: 36.0),
            QrCodeUser(),
          ],
        ),
      ),
    );
  }
}
