import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class LocalHtmlServerPage extends StatefulWidget {
  final String? hashPath;
  const LocalHtmlServerPage({super.key, this.hashPath});

  @override
  State<LocalHtmlServerPage> createState() => _LocalHtmlServerPageState();
}

class _LocalHtmlServerPageState extends State<LocalHtmlServerPage> {
  late InAppLocalhostServer localhostServer;
  InAppWebViewController? webViewController;

  @override
  void initState() {
    super.initState();
    _startServer();
  }

  Future<void> _startServer() async {
    localhostServer = InAppLocalhostServer(documentRoot: 'lib/ui/assets/html');
    await localhostServer.start();
    setState(() {});
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (localhostServer.isRunning() == false) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final url = Uri.parse(
      'http://localhost:8080/svg_inline.html${widget.hashPath != null ? '#${widget.hashPath}' : ''}',
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Event Map')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(url)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          supportZoom: true,
          useWideViewPort: true,
          loadWithOverviewMode: true,
          builtInZoomControls: true,
          displayZoomControls: false,
          mediaPlaybackRequiresUserGesture: false,
          transparentBackground: false,
          allowUniversalAccessFromFileURLs:
              true, // importante se usar JS externo
          allowFileAccessFromFileURLs: true, // idem
          useHybridComposition: true,
          maximumZoomScale: 50.0,
          minimumZoomScale: 10.0,
          initialScale: 10,
        ),
        onWebViewCreated: (controller) {
          webViewController = controller;
        },
        onZoomScaleChanged: (controller, oldScale, newScale) async {
          print(newScale);
          print(oldScale);
        },
      ),
    );
  }
}
