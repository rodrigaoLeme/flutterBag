import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../share/utils/app_color.dart';
import '../../../helpers/extensions/string_extension.dart';
import 'card_social_media_cell.dart';

class CardSocialMediaSection extends StatelessWidget {
  final String url;

  const CardSocialMediaSection({
    super.key,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              _launchURL(url.normalizarUrl);
            },
            child: CardSocialMediaCell(
              image: url.socialIcon,
              title: url,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16.0,
                color: AppColors.primaryLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
