import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../data/models/emergency/remote_emergency_model.dart';
import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/extensions/string_extension.dart';
import '../../../helpers/i18n/resources.dart';
import '../emergency_view_model.dart';

class EmergencyInfoCell extends StatelessWidget {
  final EmergencyResultViewModel? viewModel;

  const EmergencyInfoCell({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        switch (viewModel?.emergencyTypeModel) {
          case EmergencyTypeModel.link:
            final url = viewModel?.information ?? '';
            if (url.isNotEmpty) {
              await Clipboard.setData(ClipboardData(text: url));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(R.string.copiedLabel)),
                );
              }
            }

            break;
          default:
            break;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 24.0, bottom: 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GcText(
                    text: viewModel?.title ?? '',
                    textSize: GcTextSizeEnum.callout,
                    textStyleEnum: GcTextStyleEnum.bold,
                    gcStyles: GcStyles.poppins,
                    color: AppColors.black,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  GcText(
                    text: viewModel?.description ?? '',
                    textSize: GcTextSizeEnum.callout,
                    textStyleEnum: GcTextStyleEnum.regular,
                    gcStyles: GcStyles.poppins,
                    maxLines:
                        viewModel?.emergencyTypeModel == EmergencyTypeModel.link
                            ? 1
                            : null,
                    overflow:
                        viewModel?.emergencyTypeModel == EmergencyTypeModel.link
                            ? TextOverflow.ellipsis
                            : null,
                    style: viewModel?.emergencyTypeModel.isLink == true
                        ? const TextStyle(
                            decoration: TextDecoration.none,
                            color: AppColors.black)
                        : const TextStyle(color: AppColors.black),
                  ),
                ],
              ),
            ),
            if (viewModel?.emergencyTypeModel != EmergencyTypeModel.text)
              const SizedBox(width: 8),
            if (viewModel?.emergencyTypeModel != EmergencyTypeModel.text)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  switch (viewModel?.emergencyTypeModel) {
                    case EmergencyTypeModel.phone:
                      final sanitized =
                          viewModel?.information?.replaceAll(RegExp(' '), '');
                      final Uri url = Uri(scheme: 'tel', path: sanitized);
                      if (Platform.isAndroid) {
                        DialerHelper.abrirDiscador(sanitized ?? '');
                      } else {
                        await openUrl(url);
                      }

                      break;
                    case EmergencyTypeModel.link:
                      final urlDecodificada =
                          Uri.decodeFull(viewModel?.information ?? '');
                      final urlFinal = urlDecodificada.normalizarUrl;
                      final Uri url = Uri.parse(urlFinal);

                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        await launchUrl(url,
                            mode: LaunchMode.externalApplication);
                      }
                      break;
                    case EmergencyTypeModel.location:
                      await openMaps(viewModel?.information ?? '');
                      break;
                    default:
                      break;
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.neutralLight,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      viewModel?.emergencyIcon ?? '',
                      color: AppColors.primaryLight,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> openUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> openMaps(String input) async {
    late final Uri uri;

    try {
      uri = Uri.parse(input);

      if (uri.hasScheme && (uri.isAbsolute)) {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return;
        }
      }
    } catch (_) {}

    final encodedAddress = Uri.encodeComponent(input);

    final fallbackUrl = Platform.isIOS
        ? 'http://maps.apple.com/?q=$encodedAddress'
        : 'https://www.google.com/maps/search/?api=1&query=$encodedAddress';

    final fallbackUri = Uri.parse(fallbackUrl);

    if (await canLaunchUrl(fallbackUri)) {
      await launchUrl(fallbackUri, mode: LaunchMode.externalApplication);
    }
  }
}

class DialerHelper {
  static const platform = MethodChannel('gcsession2025/dialer');

  static Future<void> abrirDiscador(String numero) async {
    try {
      await platform.invokeMethod('openDialer', {'number': numero});
    } on PlatformException catch (e) {
      print('Erro ao abrir discador: ${e.message}');
    }
  }
}
