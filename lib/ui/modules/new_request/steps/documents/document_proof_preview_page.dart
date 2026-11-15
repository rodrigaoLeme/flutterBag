import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:open_document/open_document.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
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

  Future<void> _onViewFullscreen() async {
    final path = _filePath;
    if (path == null || !File(path).existsSync()) {
      _showOpenError();
      return;
    }

    if (_isImage) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => _FullscreenImagePage(title: _fileName, path: path),
        ),
      );
      return;
    }

    try {
      await OpenDocument.openDocument(filePath: path);
    } catch (_) {
      if (!mounted) return;
      _showOpenError();
    }
  }

  void _showOpenError() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppI18n.current.documentFullscreenError),
        backgroundColor: AppColors.error,
      ),
    );
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
        title: Text(i18n.documentProofEditSubmitAppBarTitle),
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
                      onFullscreen: _onViewFullscreen,
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
                label: i18n.documentSendDoneAction,
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

class _FullscreenImagePage extends StatelessWidget {
  final String title;
  final String path;

  const _FullscreenImagePage({required this.title, required this.path});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const CloseButton(color: Colors.white),
        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SizedBox.expand(
        child: InteractiveViewer(
          minScale: 1,
          maxScale: 5,
          child: Center(
            child: Image.file(
              File(path),
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white54,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DocumentPreviewCard extends StatelessWidget {
  final String fileName;
  final String? filePath;
  final bool isImage;
  final VoidCallback? onFullscreen;

  const _DocumentPreviewCard({
    required this.fileName,
    required this.filePath,
    required this.isImage,
    this.onFullscreen,
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
            child: Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    color: const Color(0xFFF7F7F9),
                    child: _buildPreviewContent(),
                  ),
                ),
                if (onFullscreen != null)
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: _FullscreenButton(onTap: onFullscreen!),
                  ),
              ],
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

class _FullscreenButton extends StatelessWidget {
  final VoidCallback onTap;

  const _FullscreenButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: AppI18n.current.documentViewFullscreenAction,
      child: Material(
        color: AppColors.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 48,
            height: 48,
            child: Center(
              child: SvgPicture.asset(
                AppIcons.fullScreenIcon,
                width: 24,
                height: 24,
                color: AppColors.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
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
            AppI18n.current.documentEditPdfFullscreenInfo,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}
