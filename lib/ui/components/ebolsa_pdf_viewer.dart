import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../main/i18n/app_i18n.dart';
import 'components.dart';

class EBolsaPdfViwer extends StatelessWidget {
  final Widget child;

  const EBolsaPdfViwer._({required this.child});

  /// Abre um PDF a partir de uma URL remota
  factory EBolsaPdfViwer.fromUrl(String url) => EBolsaPdfViwer._(
        child: _WebViewPdfViewer(url: url),
      );

  /// Abre o PDF a partir de um arquivo local (talvez usado nos scans de docs)
  factory EBolsaPdfViwer.fromFile(String path) => EBolsaPdfViwer._(
        child: _LocalPdfViewer(path: path),
      );

  @override
  Widget build(BuildContext context) => child;
}

// WebView - para URLs remotas
class _WebViewPdfViewer extends StatefulWidget {
  final String url;

  const _WebViewPdfViewer({required this.url});

  @override
  State<_WebViewPdfViewer> createState() => __WebViewPdfViewerState();
}

class __WebViewPdfViewerState extends State<_WebViewPdfViewer> {
  late final WebViewController _controller;
  late final String viewerUrl;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();

    viewerUrl = (Platform.isAndroid)
        ? 'https://docs.google.com/viewer?embedded=true&url=${Uri.encodeComponent(widget.url)}'
        : widget.url;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _isLoading = true;
            _hasError = false;
          }),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (_) => setState(() {
            _isLoading = false;
            _hasError = true;
          }),
        ),
      )
      ..loadRequest(Uri.parse(viewerUrl));

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(appStrings.pdfViewerErrorToLoadArchive),
            const SizedBox(
              height: 16,
            ),
            EbolsaButton(
              label: appStrings.tryAgain,
              onPressed: () {
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
                _controller.loadRequest(Uri.parse(widget.url));
              },
              isOutlined: true,
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}

// Local - para abrir pdfs ferados localmente
class _LocalPdfViewer extends StatelessWidget {
  final String path;

  const _LocalPdfViewer({required this.path});

  @override
  Widget build(BuildContext context) {
    // TODO: Implementar algum dia
    return const Center(
      child: Text('Visualizador Local - soon'),
    );
  }
}
