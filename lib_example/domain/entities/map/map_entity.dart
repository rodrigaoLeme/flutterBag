class MapEntity {
  final List<MapRoomEntity>? rooms;
  final int? mapVersion;

  MapEntity({
    required this.rooms,
    required this.mapVersion,
  });
}

class MapRoomEntity {
  final String? key;
  final String? value;

  MapRoomEntity({
    required this.key,
    required this.value,
  });
}
