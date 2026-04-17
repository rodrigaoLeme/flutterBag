import 'package:flutter/material.dart';

import '../../share/utils/app_color.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
    );
  }
}
