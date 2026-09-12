import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/app_assets.dart';
import '../../../../helpers/themes/themes.dart';

class DocumentProofPreviewResult {
  final String fileName;
  final String? filePath;

  const DocumentProofPreviewResult({
    required this.fileName,
    this.filePath,
  });
}

class DocumentProofPreviewPage extends StatefulWidget {
  final String documentTitle;
  final String fileName;
  final String? filePath;
  final Future<DocumentProofPreviewResult?> Function() onReplace;

  const DocumentProofPreviewPage({
    super.key,
    required this.documentTitle,
    required this.fileName,
    this.filePath,
    required this.onReplace,
  });

  @override
  State<DocumentProofPreviewPage> createState() =>
      _DocumentProofPreviewPageState();
}

class _DocumentProofPreviewPageState extends State<DocumentProofPreviewPage> {
  late String _fileName;
  late String? _filePath;

  @override
  void initState() {
    super.initState();
    _fileName = widget.fileName;
    _filePath = widget.filePath;
  }

  bool get _isImage {
    final name = _fileName.toLowerCase();
    return name.endsWith('.jpg') ||
        name.endsWith('.jpeg') ||
        name.endsWith('.png') ||
        name.endsWith('.webp') ||
        name.endsWith('.heic');
  }

  Future<void> _onReplace() async {
    final replaced = await widget.onReplace();
    if (replaced == null || !mounted) return;
    setState(() {
      _fileName = replaced.fileName;
      _filePath = replaced.filePath;
    });
  }

  void _onSend() {
    Navigator.of(context).pop(
      DocumentProofPreviewResult(
        fileName: _fileName,
        filePath: _filePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(i18n.documentProofSubmitAppBarTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.documentTitle,
                      style: AppTextStyles.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    _DocumentPreviewCard(
                      fileName: _fileName,
                      filePath: _filePath,
                      isImage: _isImage,
                    ),
                    const SizedBox(height: 16),
                    _ReplaceButton(
                      label: i18n.documentReplaceAction,
                      onPressed: _onReplace,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: EbolsaButton(
                onPressed: _onSend,
                label: i18n.documentSendAction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReplaceButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _ReplaceButton({
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.secondaryContainer,
          foregroundColor: AppColors.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              AppIcons.transferIcon,
              width: 20,
              height: 20,
              color: AppColors.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentPreviewCard extends StatelessWidget {
  final String fileName;
  final String? filePath;
  final bool isImage;

  const _DocumentPreviewCard({
    required this.fileName,
    required this.filePath,
    required this.isImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCAC4D0)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 220,
            child: ColoredBox(
              color: const Color(0xFFF7F7F9),
              child: _buildPreviewContent(),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: const Color(0xFFECEFF3),
            child: Text(
              fileName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewContent() {
    if (isImage && filePath != null && File(filePath!).existsSync()) {
      return Image.file(
        File(filePath!),
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => const _PdfPlaceholder(),
      );
    }

    return const _PdfPlaceholder();
  }
}

class _PdfPlaceholder extends StatelessWidget {
  const _PdfPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppIcons.pdfFileIcon,
            width: 56,
            height: 56,
          ),
          const SizedBox(height: 12),
          Text(
            'PDF',
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
