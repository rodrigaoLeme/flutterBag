import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../share/utils/app_color.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/mixins.dart';
import '../../mixins/navigation_manager.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String? title;
  const WebViewPage({
    super.key,
    required this.url,
    this.title,
  });

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> with NavigationManager {
  late WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromARGB(255, 255, 255, 255))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() => _isLoading = true);
          },
          onPageFinished: (String url) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  R.string.somethingWrongSubtitle,
                ),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      );
    _loadUrl();
  }

  void _loadUrl() {
    _controller.loadRequest(
      Uri.parse(widget.url),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.title != null ? Text(widget.title ?? '') : null,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Builder(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  WebViewWidget(controller: _controller),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
