import '../../../domain/entities/entities.dart';
import '../../http/http.dart';

class RemoteEditProfileModel {
  final String title;
  final String subtitle;

  RemoteEditProfileModel({
    required this.title,
    required this.subtitle,
  });

  factory RemoteEditProfileModel.fromEntity(EditProfileEntity entity) =>
      RemoteEditProfileModel(
        title: entity.title,
        subtitle: entity.subtitle,
      );

  factory RemoteEditProfileModel.fromJson(Map json) {
    if (!json.containsKey('title')) {
      throw HttpError.invalidData;
    }
    return RemoteEditProfileModel(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  EditProfileEntity toEntity() => EditProfileEntity(
        title: title,
        subtitle: subtitle,
      );
}
