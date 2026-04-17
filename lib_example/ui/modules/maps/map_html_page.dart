import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../helpers/responsive/responsive.dart';

class LocalHtmlPage extends StatefulWidget {
  final String? hashPath;

  const LocalHtmlPage({super.key, this.hashPath});

  @override
  State<LocalHtmlPage> createState() => _LocalHtmlPageState();
}

class _LocalHtmlPageState extends State<LocalHtmlPage> {
  String? _localFilePath;

  @override
  void initState() {
    super.initState();

    _loadHtmlFromAssets();
  }

  Future<void> _loadHtmlFromAssets() async {
    final data = await rootBundle.load('lib/ui/assets/html/svg_inline.html');
    final bytes = data.buffer.asUint8List();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/svg_inline.html');

    await file.writeAsBytes(bytes, flush: true);

    setState(() {
      _localFilePath = file.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_localFilePath == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final fileUrl = Uri.file(_localFilePath!).toString();
    final initialUrl =
        widget.hashPath != null ? '$fileUrl#${widget.hashPath}' : fileUrl;

    return Scaffold(
      appBar: AppBar(title: const Text('HTML Local WebView')),
      body: InteractiveViewer(
        minScale: 0.8,
        maxScale: 10.0,
        child: SizedBox(
          width: ResponsiveLayout.of(context).width,
          height: ResponsiveLayout.of(context).height,
          child: WebViewWidget(
            controller: _createController(initialUrl),
          ),
        ),
      ),
    );
  }

  WebViewController _createController(String initialUrl) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(initialUrl))
      ..enableZoom(true);
    return controller;
  }
}
