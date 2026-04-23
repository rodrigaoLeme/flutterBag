import 'package:flutter/material.dart';

class EbolsaCheckboxItem extends StatelessWidget {
  final bool value;
  final String label;
  final bool enabled;
  final ValueChanged<bool?> onChanged;

  const EbolsaCheckboxItem({
    super.key,
    required this.value,
    required this.label,
    required this.enabled,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          child: Checkbox(
            value: value,
            onChanged: enabled ? onChanged : null,
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: GestureDetector(
            onTap: enabled ? () => onChanged(!value) : null,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
