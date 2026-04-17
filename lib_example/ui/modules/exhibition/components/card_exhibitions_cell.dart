import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../share/utils/app_color.dart';
import '../exhibition_view_model.dart';

class CardExhibitionsCell extends StatelessWidget {
  final FilesViewModel? file;
  final Function(FilesViewModel?) onTapDownload;

  const CardExhibitionsCell({
    super.key,
    required this.file,
    required this.onTapDownload,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapDownload(file);
      },
      child: Container(
        height: 54,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.neutralLight,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                file?.exhibitionType.iconAsset ?? '',
                height: 20,
                width: 20,
                color: AppColors.primaryLight,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  file?.name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: AppColors.primaryLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
