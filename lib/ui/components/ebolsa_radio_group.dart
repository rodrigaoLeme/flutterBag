import 'package:flutter/material.dart';

import '../helpers/themes/themes.dart';

class RadioOption<T> {
  const RadioOption({required this.label, required this.value});
  final String label;
  final T value;
}

class EbolsaRadioGroup<T> extends StatelessWidget {
  const EbolsaRadioGroup({
    Key? key,
    required this.question,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.axis = Axis.horizontal,
  }) : super(key: key);

  final String question;
  final List<RadioOption<T>> options;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final isVertical = axis == Axis.vertical;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        isVertical
            ? Column(
                children: options
                    .map((o) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Radio<T>(
                                value: o.value,
                                groupValue: groupValue,
                                onChanged: onChanged,
                              ),
                              Flexible(child: Text(o.label)),
                            ],
                          ),
                        ))
                    .toList(),
              )
            : Row(
                children: options
                    .map((o) => Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Row(
                            children: [
                              Radio<T>(
                                value: o.value,
                                groupValue: groupValue,
                                onChanged: onChanged,
                              ),
                              Text(o.label),
                            ],
                          ),
                        ))
                    .toList(),
              ),
      ],
    );
  }
}
