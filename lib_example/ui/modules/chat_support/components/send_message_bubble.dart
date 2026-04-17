import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class SentMessageBubble extends StatelessWidget {
  final String message;
  final String time;

  const SentMessageBubble({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.onPrimaryFixedDim,
            borderRadius: BorderRadius.circular(8),
          ),
          child: GcText(
            text: message,
            gcStyles: GcStyles.poppins,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(time, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 4),
            const Icon(Icons.check, size: 16, color: Colors.green),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
