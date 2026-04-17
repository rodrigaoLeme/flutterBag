import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import '../../../../infra/download/file_download.dart';
import '../../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;
  final String? title;
  final bool hideAppBar;

  const PdfViewerPage({
    super.key,
    required this.url,
    this.title,
    this.hideAppBar = false,
  });

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? filePath;
  bool isLoading = true;
  bool isImage = false;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    try {
      final fileName = Uri.parse(widget.url).pathSegments.last;
      final extension = fileName.split('.').last.toLowerCase();

      isImage =
          ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);

      if (!isImage) {
        final nameWithoutExtension = fileName.split('.').first;

        final path = await PDFDownloader.downloadAndOpenPDF(
          widget.url,
          nameWithoutExtension,
        );

        if (mounted) {
          setState(() {
            filePath = path;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(R.string.anErrorHasOccurred),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: widget.hideAppBar
          ? null
          : AppBar(
              elevation: 0,
              backgroundColor: AppColors.primaryLight,
              title: Align(
                alignment: Alignment.topLeft,
                child: GcText(
                  text: widget.title ?? '',
                  textStyleEnum: GcTextStyleEnum.semibold,
                  textSize: GcTextSizeEnum.h3w5,
                  color: AppColors.white,
                  gcStyles: GcStyles.poppins,
                ),
              ),
            ),
      body: Stack(
        children: [
          if (!isLoading)
            if (isImage)
              InteractiveViewer(
                child: SizedBox.expand(
                  child: Image.network(
                    widget.url,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
              )
            else if (filePath != null)
              PDFView(filePath: filePath!),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryLight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
