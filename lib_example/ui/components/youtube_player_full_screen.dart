import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class YoutubePlayerFullScreen extends StatefulWidget {
  final String videoUrl;
  int startAt;

  YoutubePlayerFullScreen({
    super.key,
    required this.videoUrl,
    required this.startAt,
  });

  @override
  State<YoutubePlayerFullScreen> createState() =>
      _YoutubePlayerFullScreenState();
}

class _YoutubePlayerFullScreenState extends State<YoutubePlayerFullScreen> {
  late YoutubePlayerController _controller;
  bool _isFullScreen = false;
  late YoutubePlayer youtubePlayer;

  void _initializePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: false,
        enableCaption: false,
        startAt: widget.startAt,
      ),
    )..addListener(_onPlayerStateChange);
    if (widget.startAt > 0) {
      _controller.seekTo(
        Duration(seconds: widget.startAt),
      );
      _controller.play();
    }
  }

  void _onPlayerStateChange() {
    if (_controller.value.position.inSeconds > 0) {
      widget.startAt = _controller.value.position.inSeconds;
    }
    if (_controller.value.isFullScreen && !_isFullScreen) {
      if (_controller.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        _isFullScreen = true;
      } else {
        Modular.to.pop(widget.startAt);
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onPlayerStateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      _initializePlayer(widget.videoUrl);
      return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    SystemChrome.setPreferredOrientations([
                      DeviceOrientation.portraitUp,
                    ]);
                    Modular.to.pop(widget.startAt);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
