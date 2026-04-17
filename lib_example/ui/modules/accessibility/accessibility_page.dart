import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/html_view_page.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/extensions/string_extension.dart';
import '../../helpers/i18n/resources.dart';
import 'accessibility_presenter.dart';
import 'accessibility_view_model.dart';

class AccessibilityPage extends StatefulWidget {
  final AccessibilityPresenter presenter;
  const AccessibilityPage({
    super.key,
    required this.presenter,
  });

  @override
  AccessibilityPageState createState() => AccessibilityPageState();
}

class AccessibilityPageState extends State<AccessibilityPage> {
  @override
  void initState() {
    widget.presenter.loadData();
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryLight,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.white,
            ),
          ),
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: GcText(
            text: R.string.accessibilityLabel,
            gcStyles: GcStyles.poppins,
            textSize: GcTextSizeEnum.h3w5,
            textStyleEnum: GcTextStyleEnum.regular,
            color: AppColors.white,
          ),
        ),
      ),
      body: StreamBuilder<AccessibilityViewModel?>(
        stream: widget.presenter.viewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          if (viewModel == null ||
              snapshot.hasData == false ||
              viewModel.accessibility == null ||
              viewModel.accessibility?.text?.isEmpty == true) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/acces.svg',
              title: R.string.messageEmpty,
            );
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: CustomHtml(
                      htmlData: viewModel.accessibility?.text ?? '',
                    ),
                  ),
                ),
                if (viewModel.accessibility?.link != null &&
                    viewModel.accessibility!.link!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () async {
                        final urlDecodificada =
                            Uri.decodeFull(viewModel.accessibility?.link ?? '');
                        final urlFinal = urlDecodificada.normalizarUrl;
                        final Uri url = Uri.parse(urlFinal);

                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          await launchUrl(url,
                              mode: LaunchMode.externalApplication);
                        }
                      },
                      child: GcText(
                        text: viewModel.accessibility!.link!,
                        textSize: GcTextSizeEnum.subhead,
                        textStyleEnum: GcTextStyleEnum.regular,
                        color: AppColors.primaryLight,
                        gcStyles: GcStyles.poppins,
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<void> openUrl(Uri url) async {
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}
