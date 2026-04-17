import '../../../data/models/map/remote_map_model.dart';

class MapsViewModel {
  final List<MapRoomViewModel>? rooms;
  final int? mapVersion;

  MapsViewModel({
    required this.rooms,
    required this.mapVersion,
  });
}

class MapRoomViewModel {
  final String? key;
  final String? value;

  MapRoomViewModel({
    required this.key,
    required this.value,
  });
}

class MapsViewModelFactory {
  static Future<MapsViewModel> make(RemoteMapModel model) async {
    final rooms = model.rooms;

    return MapsViewModel(
      rooms: rooms?.map((room) {
        return MapRoomViewModel(
          key: room.key,
          value: room.value,
        );
      }).toList(),
      mapVersion: model.mapVersion,
    );
  }
}
