import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteChatSupportModel {
  final String title;
  final String subtitle;

  RemoteChatSupportModel({
    required this.title,
    required this.subtitle,
  });

  factory RemoteChatSupportModel.fromEntity(ChatSupportEntity entity) =>
      RemoteChatSupportModel(
        title: entity.title,
        subtitle: entity.subtitle,
      );

  factory RemoteChatSupportModel.fromJson(Map json) {
    if (!json.containsKey('title')) {
      throw HttpError.invalidData;
    }
    return RemoteChatSupportModel(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  ChatSupportEntity toEntity() => ChatSupportEntity(
        title: title,
        subtitle: subtitle,
      );
}
