import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../helpers/themes/themes.dart';

class OnboardingItem extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;

  const OnboardingItem({
    super.key,
    this.image,
    required this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image ?? '',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              title ?? '',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: AppColors.onSurface,
              ),
            ),
          ),
          Text(
            description ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
