import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../helpers/extensions/string_extension.dart';

class MusicListViewModel {
  final List<MusicViewModel> musics;
  List<MusicViewModel> filteredMusic;

  MusicListViewModel({
    required this.musics,
  }) : filteredMusic = musics;

  void filterBy(String text) {
    if (text == '') {
      filteredMusic = musics;
    } else {
      final query = text.toLowerCase();
      filteredMusic = musics
          .where(
            (element) => (element.name?.toLowerCase().contains(query) == true ||
                element.text?.toLowerCase().contains(query) == true),
          )
          .toList();
    }
  }
}

class MusicViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? name;
  final String? text;
  final String? link;
  final String? thumbnail;
  final int? order;

  MusicViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.name,
    required this.text,
    required this.link,
    required this.thumbnail,
    required this.order,
  });

  String get thumbnailUrl {
    final videoId = link?.extractVideoId();
    if (link?.contains('live') == true) {
      return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
    }
    if (thumbnail != null && link?.contains('youtu.be') == false) {
      return thumbnail ?? '';
    }
    return YoutubePlayer.getThumbnail(videoId: videoId ?? '');
  }

  void filterBy(String text) {}
}
