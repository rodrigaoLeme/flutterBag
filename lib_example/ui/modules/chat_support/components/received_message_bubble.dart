import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';

class ReceivedMessageBubble extends StatelessWidget {
  final String message;
  final String time;

  const ReceivedMessageBubble({
    super.key,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_circle,
              size: 48.0,
              color: AppColors.onSecundaryContainer,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GcText(
                  text: 'Marie Smith',
                  textSize: GcTextSizeEnum.h3,
                  textStyleEnum: GcTextStyleEnum.bold,
                  gcStyles: GcStyles.poppins,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(message),
                ),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50.0),
          child: Row(
            children: [
              Text(time, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              const Icon(Icons.check, size: 16, color: Colors.green),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
