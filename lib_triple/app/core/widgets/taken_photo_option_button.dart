import 'package:flutter/material.dart';

class TakenPhotoOptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  const TakenPhotoOptionButton({Key? key, required this.label, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: primary))), backgroundColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? primary : Colors.white), overlayColor: MaterialStateProperty.all(primary), minimumSize: MaterialStateProperty.all(const Size(138, 48)), foregroundColor: MaterialStateProperty.resolveWith((states) => states.contains(MaterialState.pressed) ? Colors.white : primary)),
      child: Text(label),
    );
  }
}
