import 'dart:io';

import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import '../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';

class LocalServer {
  HttpServer? _server;
  int? _port;

  final String remoteUrl;

  LocalServer({required this.remoteUrl});

  Future<int> start() async {
    if (_server != null) {
      return _port ?? 8080;
    }
    final dir = await getApplicationDocumentsDirectory();
    final paramController = Modular.get<ParamController>();
    final viewModel = paramController.getViewModel();
    final versionDir = Directory('${dir.path}/${viewModel?.mapVersion ?? 0}');

    if (!await versionDir.exists()) {
      await versionDir.create(recursive: true);
    }

    final filePath = '${versionDir.path}/index.html';
    final htmlFile = File(filePath);
    const defaultPort = 8080;
    if (!await htmlFile.exists()) {
      final response = await http.get(Uri.parse(remoteUrl));
      if (response.statusCode == 200) {
        await htmlFile.writeAsString(response.body);
      } else {
        return 0;
      }
    }

    handler(Request request) async {
      final path = request.url.path;

      if (path.isEmpty || path == 'index.html') {
        final content = await htmlFile.readAsString();
        return Response.ok(content, headers: {
          'content-type': 'text/html',
        });
      }

      return Response.notFound('Not Found');
    }

    try {
      _server = await shelf_io.serve(handler, 'localhost', defaultPort);
    } catch (e) {
      print(e.toString());
    }
    _port = _server?.port ?? defaultPort;

    return _port ?? defaultPort;
  }

  Future<void> stop() async {
    await _server?.close(force: true);
  }
}
