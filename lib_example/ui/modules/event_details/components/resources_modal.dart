import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../infra/download/file_download.dart';
import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../../agenda/agenda_view_model.dart';

class ResourcesModal extends StatefulWidget {
  final ScheduleViewModel? viewModel;
  const ResourcesModal({
    super.key,
    required this.viewModel,
  });

  @override
  State<ResourcesModal> createState() => _ResourcesModalState();
}

class _ResourcesModalState extends State<ResourcesModal> {
  bool isLoading = false;

  Future<void> _handleFileTap(String path, String name) async {
    setState(() => isLoading = true);
    try {
      final filePath = await PDFDownloader.downloadAndOpenPDF(path, name);
      await OpenFilex.open(filePath);
      setState(() => isLoading = false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(R.string.anErrorHasOccurred),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 100,
                        height: 3,
                        decoration: BoxDecoration(
                          color: AppColors.neutralLowMedium,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: GcText(
                      text: R.string.resourcesLabel,
                      textStyleEnum: GcTextStyleEnum.bold,
                      textSize: GcTextSizeEnum.headline,
                      color: AppColors.neutralLowDark,
                      gcStyles: GcStyles.poppins,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.viewModel?.files?.length ?? 0,
                      itemBuilder: (context, index) {
                        final file = widget.viewModel?.files?[index];
                        return Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: GestureDetector(
                            onTap: () async {
                              await _handleFileTap(
                                file?.storagePath ?? '',
                                file?.name ?? '',
                              );
                            },
                            child: Container(
                              height: 54,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: AppColors.neutralLight,
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
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
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
