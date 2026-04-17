import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteStLouisModel {
  final String title;
  final String subtitle;

  RemoteStLouisModel({
    required this.title,
    required this.subtitle,
  });

  factory RemoteStLouisModel.fromEntity(StLouisEntity entity) =>
      RemoteStLouisModel(
        title: entity.title,
        subtitle: entity.subtitle,
      );

  factory RemoteStLouisModel.fromJson(Map json) {
    if (!json.containsKey('title')) {
      throw HttpError.invalidData;
    }
    return RemoteStLouisModel(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  StLouisEntity toEntity() => StLouisEntity(
        title: title,
        subtitle: subtitle,
      );
}
