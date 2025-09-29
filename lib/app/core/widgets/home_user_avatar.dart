import '../icons/ebolsas_icons_icons.dart';
import 'package:flutter/material.dart';

class HomeUserAvatar extends StatelessWidget {
  const HomeUserAvatar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: const Icon(
        EbolsasIcons.user,
        color: Color(0xFFA1A1A1),
        size: 40,
      ),
    );
  }
}
