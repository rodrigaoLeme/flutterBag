import 'package:flutter/material.dart';

import '../helpers/themes/themes.dart';

class RadioOption<T> {
  const RadioOption({required this.label, required this.value});
  final String label;
  final T value;
}

class EbolsaRadioGroup<T> extends StatelessWidget {
  const EbolsaRadioGroup({
    super.key,
    required this.question,
    this.subtitle,
    this.errorText,
    required this.options,
    required this.groupValue,
    required this.onChanged,
    this.axis = Axis.horizontal,
  });

  final String question;
  final String? subtitle;
  final String? errorText;
  final List<RadioOption<T>> options;
  final T? groupValue;
  final ValueChanged<T?> onChanged;
  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final isVertical = axis == Axis.vertical;

    final radioItems = options.map((o) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onChanged(o.value),
        child: Padding(
          padding: EdgeInsets.only(
            right: isVertical ? 0 : 12.0,
            bottom: isVertical ? 8.0 : 0,
          ),
          child: Row(
            mainAxisSize: isVertical ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Radio<T>(
                value: o.value,
              ),
              Flexible(
                child: Text(o.label, style: AppTextStyles.bodyMedium),
              ),
            ],
          ),
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question, style: AppTextStyles.bodyMedium),
        if (subtitle != null && subtitle!.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(subtitle!, style: AppTextStyles.bodySmall),
        ],
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Text(
            errorText!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
          ),
        ],
        const SizedBox(height: 4),
        RadioGroup<T>(
          groupValue: groupValue,
          onChanged: onChanged,
          child: isVertical
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: radioItems,
                )
              : Wrap(
                  children: radioItems,
                ),
        ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final isVertical = axis == Axis.vertical;
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(question, style: AppTextStyles.bodyMedium),
  //       if (errorText != null) ...[
  //         const SizedBox(height: 4),
  //         Text(
  //           errorText!,
  //           style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
  //         ),
  //       ],
  //       if (subtitle != null && subtitle!.isNotEmpty)
  //         Text(subtitle!, style: AppTextStyles.bodySmall),
  //       isVertical
  //           ? Column(
  //               children: options
  //                   .map((o) => Padding(
  //                         padding: const EdgeInsets.only(bottom: 8.0),
  //                         child: Row(
  //                           children: [
  //                             Radio<T>(
  //                               value: o.value,
  //                               groupValue: groupValue,
  //                               onChanged: onChanged,
  //                             ),
  //                             Flexible(child: Text(o.label)),
  //                           ],
  //                         ),
  //                       ))
  //                   .toList(),
  //             )
  //           : Row(
  //               children: options
  //                   .map((o) => Padding(
  //                         padding: const EdgeInsets.only(right: 12.0),
  //                         child: Row(
  //                           children: [
  //                             Radio<T>(
  //                               value: o.value,
  //                               groupValue: groupValue,
  //                               onChanged: onChanged,
  //                             ),
  //                             Text(o.label),
  //                           ],
  //                         ),
  //                       ))
  //                   .toList(),
  //             ),
  //     ],
  //   );
  // }
}
