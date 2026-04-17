import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/map/map_entity.dart';
import '../../http/http.dart';

class RemoteMapModel {
  final List<MapRoomModel>? rooms;
  final int? mapVersion;

  RemoteMapModel({
    required this.rooms,
    required this.mapVersion,
  });

  factory RemoteMapModel.fromDocument(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    try {
      final data = snapshot.data();
      final decodedResult = jsonDecode(data?['Result']);

      final rooms = (decodedResult?['Rooms'] as List?)
          ?.map((item) {
            final itemJson = item as Map<String, dynamic>?;
            if (itemJson != null) {
              return MapRoomModel.fromJson(itemJson);
            }
          })
          .whereType<MapRoomModel>()
          .toSet()
          .toList();

      final mapVersion = decodedResult?['MapVersion'];

      return RemoteMapModel(rooms: rooms, mapVersion: mapVersion);
    } catch (e) {
      throw HttpError.invalidData;
    }
  }

  MapEntity toEntity() => MapEntity(
        rooms: rooms?.map<MapRoomEntity>((event) => event.toEntity()).toList(),
        mapVersion: null,
      );
}

class MapRoomModel {
  final String? key;
  final String? value;

  MapRoomModel({
    required this.key,
    required this.value,
  });

  factory MapRoomModel.fromJson(Map json) {
    if (!json.containsKey('key')) {
      throw HttpError.invalidData;
    }

    return MapRoomModel(
      key: json['key'],
      value: json['value'],
    );
  }

  MapRoomEntity toEntity() => MapRoomEntity(
        key: key,
        value: value,
      );
}
