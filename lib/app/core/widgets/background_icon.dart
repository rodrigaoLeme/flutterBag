import 'package:flutter/material.dart';

class BackgroundIcon extends StatelessWidget {
  final Widget icon;
  final Color? backgroundColor;
  const BackgroundIcon({Key? key, required this.icon, this.backgroundColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: backgroundColor ?? const Color(0xFFE3E8EB)),
      child: icon,
    );
  }
}
