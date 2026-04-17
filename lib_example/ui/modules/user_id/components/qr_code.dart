import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';

class QrCodeUser extends StatelessWidget {
  const QrCodeUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: const BoxDecoration(
        color: AppColors.onSecundaryContainer,
      ),
    );
  }
}
