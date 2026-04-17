import 'package:flutter/material.dart';

import '../../../../share/utils/app_color.dart';
import '../../../helpers/i18n/resources.dart';

class MessageInputField extends StatelessWidget {
  const MessageInputField({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: R.string.typeMessageLabel,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    width: 1.0,
                    color: AppColors.onSecundaryContainer,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppColors.denimLigth,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: IconButton(
              icon: Icon(
                Icons.mood,
                size: 24.0,
                color: AppColors.primaryLight,
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: const Icon(
              Icons.send,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
