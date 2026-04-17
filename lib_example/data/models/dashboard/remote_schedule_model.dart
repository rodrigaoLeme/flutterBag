import '../../../domain/entities/dashboard/dashboard.dart';
import '../../http/http.dart';

class RemoteScheduleModel {
  final String title;
  final String subtitle;
  final String address;

  RemoteScheduleModel({
    required this.title,
    required this.subtitle,
    required this.address,
  });

  factory RemoteScheduleModel.fromEntity(ScheduleEntity entity) =>
      RemoteScheduleModel(
          title: entity.title,
          subtitle: entity.subtitle,
          address: entity.address);

  factory RemoteScheduleModel.fromJson(Map json) {
    if (!json.containsKey('title')) {
      throw HttpError.invalidData;
    }
    return RemoteScheduleModel(
      title: json['title'],
      subtitle: json['subtitle'],
      address: json['address'],
    );
  }

  ScheduleEntity toEntity() => ScheduleEntity(
        title: title,
        subtitle: subtitle,
        address: address,
      );
}
