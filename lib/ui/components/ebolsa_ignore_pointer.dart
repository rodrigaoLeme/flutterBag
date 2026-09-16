import 'package:flutter/material.dart';

class EbolsaIgnorePointer extends StatelessWidget {
  final bool ignoring;
  final double disabledOpacity;
  final Widget child;

  const EbolsaIgnorePointer({
    super.key,
    required this.ignoring,
    required this.child,
    this.disabledOpacity = 0.4,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoring,
      child: AnimatedOpacity(
        opacity: ignoring ? disabledOpacity : 1.0,
        duration: const Duration(milliseconds: 200),
        child: child,
      ),
    );
  }
}
