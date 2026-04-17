import '../../../domain/entities/entities.dart';
import '../../../domain/entities/translation/translation_entity.dart';
import '../../http/http.dart';

class RemoteTranslationModel {
  final String title;
  final String subtitle;

  RemoteTranslationModel({
    required this.title,
    required this.subtitle,
  });

  factory RemoteTranslationModel.fromEntity(ProfileEntity entity) =>
      RemoteTranslationModel(
        title: entity.title,
        subtitle: entity.subtitle,
      );

  factory RemoteTranslationModel.fromJson(Map json) {
    if (!json.containsKey('title')) {
      throw HttpError.invalidData;
    }
    return RemoteTranslationModel(
      title: json['title'],
      subtitle: json['subtitle'],
    );
  }

  TranslationEntity toEntity() => TranslationEntity(
        title: title,
        subtitle: subtitle,
      );
}
