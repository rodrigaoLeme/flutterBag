import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'youtube_player_full_screen.dart';

class YoutubeVideoWidget extends StatefulWidget {
  final String videoUrl;
  final double height;
  final double? borderRadius;

  const YoutubeVideoWidget({
    Key? key,
    required this.videoUrl,
    required this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  YoutubeVideoWidgetState createState() => YoutubeVideoWidgetState();
}

class YoutubeVideoWidgetState extends State<YoutubeVideoWidget> {
  late YoutubePlayerController _controller;
  late YoutubePlayer youtubePlayer;
  bool inCurrentPage = true;
  int startAt = 0;

  @override
  void initState() {
    super.initState();
    _initializePlayer(widget.videoUrl);
  }

  void _initializePlayer(String url) {
    final videoId = YoutubePlayer.convertUrlToId(url);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        hideControls: false,
        enableCaption: false,
      ),
    )..addListener(_onPlayerStateChange);
    youtubePlayer = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }

  void initVideoBy() {
    _controller.dispose();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          hideControls: false,
          enableCaption: false,
          startAt: startAt),
    )..addListener(_onPlayerStateChange);
    youtubePlayer = YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    );
  }

  void _onPlayerStateChange() async {
    if (_controller.value.isPlaying && inCurrentPage) {
      inCurrentPage = false;
      startAt = await Modular.to.push(
        MaterialPageRoute(
          builder: (context) {
            return YoutubePlayerFullScreen(
              videoUrl: widget.videoUrl,
              startAt: startAt,
            );
          },
        ),
      );
      inCurrentPage = true;
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
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 300),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
        child: SizedBox(
          width: double.infinity,
          height: widget.height,
          child: youtubePlayer,
        ),
      ),
    );
  }
}
