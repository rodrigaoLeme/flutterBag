import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../share/utils/app_color.dart';

class WebViewByHtml extends StatefulWidget {
  final String htmlContent;
  const WebViewByHtml({
    super.key,
    required this.htmlContent,
  });

  @override
  State<WebViewByHtml> createState() => _HtmlWebViewPageState();
}

class _HtmlWebViewPageState extends State<WebViewByHtml> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(widget.htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.dividerGrey,
      child: WebViewWidget(
        controller: _controller,
      ),
    );
  }
}
