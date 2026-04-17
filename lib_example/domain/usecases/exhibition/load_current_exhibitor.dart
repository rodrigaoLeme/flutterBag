import '../../entities/entities.dart';

abstract class LoadCurrentExhibitor {
  Future<ExhibitionEntity?> load({
    required LoadCurrentExhibitorParams params,
  });
}

class LoadCurrentExhibitorParams {
  final String eventId;
  LoadCurrentExhibitorParams({
    required this.eventId,
  });
}
