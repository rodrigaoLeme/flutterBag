import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteGetInLineModel {
  final String title;
  final String subtitle;

  RemoteGetInLineModel({
    required this.title,
    required this.subtitle,
  });

  factory RemoteGetInLineModel.fromEntity(GetInLineEntity entity) =>
      RemoteGetInLineModel(
        title: entity.title,
        subtitle: entity.subtitle,
      );

  factory RemoteGetInLineModel.fromJson(Map json) {
    if (!json.containsKey('title')) {
      throw HttpError.invalidData;
    }
    return RemoteGetInLineModel(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  GetInLineEntity toEntity() => GetInLineEntity(
        title: title,
        subtitle: subtitle,
      );
}
