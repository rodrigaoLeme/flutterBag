import '../../../data/models/emergency/remote_emergency_model.dart';
import '../../helpers/extensions/string_extension.dart';

class EmergencyViewModel {
  final List<EmergencyResultViewModel>? result;

  EmergencyViewModel({
    required this.result,
  });
}

class EmergencyResultViewModel {
  final int? id;
  final String? externalId;
  final int? eventId;
  final String? eventExternalId;
  final String? type;
  final String? title;
  final String? description;
  final String? information;
  final int? order;
  final EmergencyTypeModel emergencyTypeModel;

  EmergencyResultViewModel({
    required this.id,
    required this.externalId,
    required this.eventId,
    required this.eventExternalId,
    required this.type,
    required this.title,
    required this.description,
    required this.information,
    required this.order,
    required this.emergencyTypeModel,
  });

  String get emergencyIcon => emergencyTypeModel.iconAsset;
}

class EmergencyViewModelFactory {
  static Future<EmergencyViewModel> make(RemoteEmergencyModel model) async {
    final List<EmergencyResultViewModel> result = model.result != null
        ? await Future.wait(
            model.result!.map(
              (element) async => EmergencyResultViewModel(
                id: element.id,
                externalId: element.externalId,
                eventId: element.eventId,
                eventExternalId: element.eventExternalId,
                type: element.type,
                title: await element.title?.translate(),
                description: await element.description?.translate(),
                information: await element.information?.translate(),
                order: element.order,
                emergencyTypeModel: EmergencyTypeModel.fromType(element.type),
              ),
            ),
          )
        : [];
    return EmergencyViewModel(result: result);
  }
}
