import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../infra/download/file_download.dart';
import '../../../../share/utils/app_color.dart';
import '../../../components/enum/design_system_enums.dart';
import '../../../components/gc_text.dart';
import '../../../components/themes/gc_styles.dart';
import '../../../helpers/i18n/resources.dart';
import '../../../mixins/navigation_manager.dart';
import '../documents_view_model.dart';

class DocumentsDetails extends StatefulWidget with NavigationManager {
  final DocumentsResultViewModel viewModel;

  const DocumentsDetails({
    super.key,
    required this.viewModel,
  });

  @override
  DocumentsDetailsState createState() => DocumentsDetailsState();
}

class DocumentsDetailsState extends State<DocumentsDetails> {
  String? filePath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFile();
  }

  Future<void> _loadFile() async {
    try {
      final path = await getFilePath();
      if (mounted) {
        setState(() {
          filePath = path;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryLight,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.translucent,
          child: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        title: Align(
          alignment: Alignment.topLeft,
          child: GcText(
            text: R.string.documentsLabel,
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'lib/ui/assets/images/icon/share-nodes-regular.svg',
              height: 18,
              width: 18,
              color: AppColors.white,
            ),
            onPressed: () async {
              if (filePath != null) {
                try {
                  await Share.shareXFiles(
                    [XFile(filePath!)],
                    text: widget.viewModel.name ?? '',
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(R.string.errorSharing)),
                  );
                }
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          if (filePath != null && !isLoading) PDFView(filePath: filePath),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
              ),
            ),
        ],
      ),
    );
  }

  Future<String> getFilePath() async {
    return await PDFDownloader.downloadAndOpenPDF(
      widget.viewModel.url ?? '',
      widget.viewModel.description ?? '',
    );
  }
}
