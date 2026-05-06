import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../helpers/themes/themes.dart';

class AuthLoginLogo extends StatelessWidget {
  const AuthLoginLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        AppImages.logo,
        height: 100,
        placeholderBuilder: (_) => const Icon(Icons.school, size: 80),
      ),
    );
  }
}
