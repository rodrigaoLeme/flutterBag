import '../../../domain/entities/business/business_entity.dart';
import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteBusinessModel {
  final String title;
  final String subtitle;

  RemoteBusinessModel({
    required this.title,
    required this.subtitle,
  });

  factory RemoteBusinessModel.fromEntity(ProfileEntity entity) =>
      RemoteBusinessModel(
        title: entity.title,
        subtitle: entity.subtitle,
      );

  factory RemoteBusinessModel.fromJson(Map json) {
    if (!json.containsKey('title')) {
      throw HttpError.invalidData;
    }
    return RemoteBusinessModel(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  BusinessEntity toEntity() => BusinessEntity(
        title: title,
        subtitle: subtitle,
      );
}
