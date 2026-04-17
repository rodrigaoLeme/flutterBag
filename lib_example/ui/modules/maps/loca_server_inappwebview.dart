import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MyApp extends StatefulWidget {
  final String path;

  const MyApp({super.key, required this.path});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? urlToLoad;
  late InAppLocalhostServer localhostServer;

  @override
  void initState() {
    super.initState();
    localhostServer = InAppLocalhostServer();
    initWebview();
  }

  Future<void> initWebview() async {
    // 1. Diretório onde salvar o HTML
    final dir = await getTemporaryDirectory();
    final htmlFile = File('${dir.path}/index.html');

    // 2. Verificar se já existe
    if (!await htmlFile.exists()) {
      print('HTML não encontrado. Baixando...');

      final response = await http.get(Uri.parse(
        'https://events-assets-staging.sdasystems.org/events/01JVMKSYQAC5P4YQZHTBKJRY4J/Oa19tlrq.html',
      ));

      if (response.statusCode != 200 || response.body.trim().isEmpty) {
        print('Erro ao baixar HTML ou HTML vazio');
        return;
      }

      await htmlFile.writeAsString(response.body);
      print('HTML salvo em: ${htmlFile.path}');
    } else {
      print('HTML já existe em: ${htmlFile.path}');
    }

    // 3. Iniciar servidor
    localhostServer = InAppLocalhostServer(documentRoot: dir.path);
    await localhostServer.start();

    // 4. Atualizar estado com URL + path
    setState(() {
      urlToLoad = 'http://localhost:8080/index.html#${widget.path}';
      print('URL final: $urlToLoad');
    });
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('WebView Localhost')),
        body: urlToLoad == null
            ? const Center(child: CircularProgressIndicator())
            : InAppWebView(
                initialOptions: InAppWebViewGroupOptions(
                  crossPlatform: InAppWebViewOptions(
                    javaScriptEnabled: true,
                    cacheEnabled: true,
                    useShouldOverrideUrlLoading: false,
                    mediaPlaybackRequiresUserGesture: false,
                    verticalScrollBarEnabled: false, // opcional
                    horizontalScrollBarEnabled: false, // opcional
                    transparentBackground: false,
                  ),
                  android: AndroidInAppWebViewOptions(
                    useHybridComposition: true,
                    builtInZoomControls: false,
                    displayZoomControls: false,
                    disableDefaultErrorPage: true,
                    overScrollMode: AndroidOverScrollMode
                        .OVER_SCROLL_NEVER, // previne overscroll delay
                  ),
                  ios: IOSInAppWebViewOptions(
                    allowsBackForwardNavigationGestures: false,
                    allowsInlineMediaPlayback: true,
                    suppressesIncrementalRendering: true, // ajuda no scroll
                  ),
                ),
                initialUrlRequest: URLRequest(
                  url: WebUri(urlToLoad!),
                ),
              ),
      ),
    );
  }
}
