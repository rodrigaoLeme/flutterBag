import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../helpers/extensions/string_extension.dart';

class YoutubeWebViewPlayer extends StatefulWidget {
  final String youtubeUrl;
  final double aspectRatio;
  const YoutubeWebViewPlayer({
    required this.youtubeUrl,
    this.aspectRatio = 16 / 6,
    super.key,
  });

  @override
  State<YoutubeWebViewPlayer> createState() => _YoutubeWebViewPlayerState();
}

class _YoutubeWebViewPlayerState extends State<YoutubeWebViewPlayer> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    final videoId = widget.youtubeUrl.extractVideoId();
    final uri = Uri.tryParse(widget.youtubeUrl);
    String? startTime;

    if (uri?.queryParameters['start'] != null) {
      startTime = uri?.queryParameters['start'];
    } else if (uri?.queryParameters['t'] != null) {
      startTime = uri?.queryParameters['t']?.replaceAll('s', '');
    }

    String embedUrl = 'https://www.youtube.com/embed/$videoId';
    if (startTime != null) {
      embedUrl += '?start=$startTime';
    }
    if (widget.youtubeUrl.contains('live')) {
      embedUrl = widget.youtubeUrl;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(embedUrl));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
