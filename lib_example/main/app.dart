import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../share/utils/app_color.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp.router(
      title: 'GC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: AppColors.primary, fontFamily: 'Poppins'),
      routerConfig: Modular.routerConfig,
    );
  }
}
