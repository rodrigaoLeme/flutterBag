import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteProfileModel {
  final String title;
  final String subtitle;

  RemoteProfileModel({
    required this.title,
    required this.subtitle,
  });

  factory RemoteProfileModel.fromEntity(ProfileEntity entity) =>
      RemoteProfileModel(
        title: entity.title,
        subtitle: entity.subtitle,
      );

  factory RemoteProfileModel.fromJson(Map json) {
    if (!json.containsKey('title')) {
      throw HttpError.invalidData;
    }
    return RemoteProfileModel(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  ProfileEntity toEntity() => ProfileEntity(
        title: title,
        subtitle: subtitle,
      );
}
