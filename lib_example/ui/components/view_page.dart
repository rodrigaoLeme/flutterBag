import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../modules/maps/map_by_pdf.dart';

class ViewPage extends StatefulWidget {
  final String url;
  final String? title;

  const ViewPage({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  late final WebViewController _controller;
  bool _isPdf = false;

  @override
  void initState() {
    super.initState();
    _checkIfPdf();
    if (!_isPdf) {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  void _checkIfPdf() {
    final url = widget.url.toLowerCase();
    _isPdf = url.endsWith('.pdf') || url.contains('.pdf?');
  }

  @override
  Widget build(BuildContext context) {
    if (_isPdf) {
      return PdfViewerPage(
        url: widget.url,
        title: widget.title,
        hideAppBar: true,
      );
    }

    return Scaffold(
      body: WebViewWidget(controller: _controller),
    );
  }
}
