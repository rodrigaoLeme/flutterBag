import 'package:flutter/material.dart';

class DSLogo extends StatelessWidget {
  final double? widht;
  final DSLogoType type;
  const DSLogo({super.key, this.widht, this.type = DSLogoType.white});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widht,
      child: Image.asset(
        type.logo,
        width: widht,
      ),
    );
  }
}

enum DSLogoType { white, black }

extension DSLogoTypeEx on DSLogoType {
  static final Map<DSLogoType, String> _logos = {
    DSLogoType.black: 'lib/ui/assets/images/logo/logos.png',
    DSLogoType.white: 'lib/ui/assets/images/logo/logos.png',
  };

  String get logo => _logos[this]!;
}
