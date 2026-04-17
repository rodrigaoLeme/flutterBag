import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../share/utils/app_color.dart';
import '../../../helpers/extensions/string_extension.dart';

class CardSocialMediaCell extends StatelessWidget {
  final String image;
  final String title;
  final TextStyle? style;

  const CardSocialMediaCell({
    super.key,
    required this.image,
    required this.title,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () async {
          final urlDecodificada = Uri.decodeFull(title);

          final urlFinal = urlDecodificada.normalizarUrl;
          final Uri url = Uri.parse(urlFinal);

          await launchUrl(url);
        },
        child: Container(
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.denimLigth,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SvgPicture.asset(
                  image,
                  width: 18,
                  height: 18,
                  color: AppColors.primaryLight,
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: Text(
                    title,
                    style: style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
