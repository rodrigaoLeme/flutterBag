import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../presentation/mixins/push_fullscreen_manager.dart';
import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/push_fullscreen_manager.dart';
import '../event_details/event_details_view_model.dart';
import 'local_server.dart';
import 'maps_presenter.dart';

class LocalWebViewPageByServer extends StatefulWidget {
  final String? hashPath;
  final MapPresenter presenter;

  const LocalWebViewPageByServer({
    required this.hashPath,
    required this.presenter,
    super.key,
  });

  @override
  State<LocalWebViewPageByServer> createState() =>
      _LocalWebViewPageByServerState();
}

class _LocalWebViewPageByServerState extends State<LocalWebViewPageByServer>
    with LoadingManager {
  LocalServer? _server;
  InAppWebViewController? _webViewController;
  final ValueNotifier<bool> _isWebViewLoaded = ValueNotifier(false);
  final Key _webViewKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    PushFullscreenManagerListener.handleFullScreen(
        context, PushFullscreenManager().isShowingStream);
    handleLoading(context, widget.presenter.isLoadingStream);
  }

  Future<void> _startServer(String remoteUrl) async {
    _server = LocalServer(remoteUrl: remoteUrl);
    final port = await _server?.start();
    final url = Uri.parse(
        'http://localhost:$port/index.html${(widget.hashPath != null && widget.hashPath!.isNotEmpty) ? '#${widget.hashPath}' : ''}');

    await _webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri.uri(url)),
    );
    _isWebViewLoaded.value = true;
  }

  Future<void> _stopServer() async {
    if (_server != null) {
      await _server!.stop();
      _server = null;
    }
  }

  @override
  void dispose() {
    _stopServer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.topLeft,
          child: GcText(
            text: 'Event Map',
            textStyleEnum: GcTextStyleEnum.semibold,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primaryLight,
      ),
      body: Builder(
        builder: (context) {
          widget.presenter.loadData();

          return StreamBuilder<EventDetailsViewModel?>(
            stream: widget.presenter.viewModel,
            builder: (context, snapshot) {
              final viewModel = snapshot.data;
              if (viewModel == null) {
                return const SizedBox.shrink();
              }

              return FutureBuilder(
                future: _startServer(viewModel.eventMap ?? ''),
                builder: (context, snapshot) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: _isWebViewLoaded,
                    builder: (context, isLoaded, _) {
                      return InAppWebView(
                        key: _webViewKey,
                        initialSettings: InAppWebViewSettings(
                          javaScriptEnabled: true,
                          supportZoom: true,
                          useWideViewPort: true,
                          loadWithOverviewMode: true,
                          builtInZoomControls: true,
                          displayZoomControls: false,
                          mediaPlaybackRequiresUserGesture: false,
                          transparentBackground: false,
                          allowUniversalAccessFromFileURLs: true,
                          allowFileAccessFromFileURLs: true,
                          useHybridComposition: true,
                          maximumZoomScale: 50.0,
                          minimumZoomScale: 10.0,
                          initialScale: 10,
                        ),
                        onWebViewCreated: (controller) {
                          _webViewController = controller;
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
