import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../share/utils/app_color.dart';
import '../helpers/extensions/string_extension.dart';
import '../helpers/helpers.dart';
import '../modules/emergency/components/emergency_info_cell.dart';
import '../modules/transport/transport_page.dart.dart';
import 'enum/design_system_enums.dart';
import 'gc_text.dart';
import 'themes/gc_styles.dart';

class HtmlViewPage extends StatelessWidget {
  final String html;
  final String? title;
  final bool isTitleInBody;
  final bool showAppBar;

  const HtmlViewPage({
    super.key,
    required this.html,
    this.title,
    this.isTitleInBody = false,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: showAppBar
          ? AppBar(
              elevation: 0,
              backgroundColor: AppColors.primaryLight,
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                behavior: HitTestBehavior.translucent,
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
              title: Align(
                alignment: Alignment.topLeft,
                child: GcText(
                  text: R.string.newsLabel,
                  textStyleEnum: GcTextStyleEnum.semibold,
                  textSize: GcTextSizeEnum.h3w5,
                  color: AppColors.white,
                  gcStyles: GcStyles.poppins,
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isTitleInBody && title != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GcText(
                    text: title!,
                    textSize: GcTextSizeEnum.h2,
                    textStyleEnum: GcTextStyleEnum.bold,
                    color: AppColors.black,
                    gcStyles: GcStyles.poppins,
                    textAlign: TextAlign.start,
                  ),
                ),
              CustomHtml(
                htmlData: '<h1>$title</h1>$html',
                onLinkClick: _handleLinkClick,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLinkClick() {
    _launchURL('https://privacy.adventist.org/');
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class CustomHtml extends StatelessWidget {
  final String htmlData;
  final void Function()? onLinkClick;

  const CustomHtml({Key? key, required this.htmlData, this.onLinkClick})
      : super(key: key);

  String _processHtmlClasses(String html) {
    String processed = html;

    processed = processed.replaceAllMapped(
      RegExp(r'class="([^"]*ql-align-right[^"]*)"'),
      (match) => 'class="${match.group(1)}" style="text-align: right;"',
    );
    processed = processed.replaceAllMapped(
      RegExp(r'class="([^"]*ql-align-center[^"]*)"'),
      (match) => 'class="${match.group(1)}" style="text-align: center;"',
    );
    processed = processed.replaceAllMapped(
      RegExp(r'class="([^"]*ql-align-left[^"]*)"'),
      (match) => 'class="${match.group(1)}" style="text-align: left;"',
    );
    processed = processed.replaceAllMapped(
      RegExp(r'class="([^"]*ql-align-justify[^"]*)"'),
      (match) => 'class="${match.group(1)}" style="text-align: justify;"',
    );

    return processed;
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: _processHtmlClasses(htmlData),
      onLinkTap: (String? url, Map<String, String> attributes, element) {
        if (url == 'https://privacy.adventist.org/') {
          if (onLinkClick != null) {
            onLinkClick!();
          }
        } else if (url != null) {
          _launchURL(url);
        }
      },
      style: {
        'img': Style(
          width: Width(
            ResponsiveLayout.of(context).wp(80),
            Unit.px,
          ),
          height: Height(5, Unit.rem),
        ),
        '.ql-align-right': Style(
          textAlign: TextAlign.right,
        ),
        '.ql-align-center': Style(
          textAlign: TextAlign.center,
        ),
        '.ql-align-left': Style(
          textAlign: TextAlign.left,
        ),
        '.ql-align-justify': Style(
          textAlign: TextAlign.justify,
        ),
      },
    );
  }

  void _launchURL(String url) async {
    final uri = Uri.parse(url.normalizarUrl);
    if (url.contains('tel')) {
      final sanitized = url.replaceAll(RegExp('tel:'), '');
      final Uri urlTel = Uri(scheme: 'tel', path: sanitized);
      if (Platform.isAndroid) {
        DialerHelper.abrirDiscador(sanitized);
      } else {
        await openUrl(urlTel);
      }
    } else if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
