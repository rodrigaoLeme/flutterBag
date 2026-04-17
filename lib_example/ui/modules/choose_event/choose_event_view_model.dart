import '../../../data/models/choose_event/remote_choose_event_model.dart';
import '../../../ui/helpers/extensions/date_formater_extension.dart';
import '../../helpers/extensions/string_extension.dart';

class ChooseEventViewModel {
  final List<EventViewModel> result;

  ChooseEventViewModel({
    required this.result,
  });

  Map toJson() => {
        'Result': result.map((element) => element.toMap()).toList(),
      };
}

class EventViewModel {
  final String? externalId;
  final String? name;
  final String? timezone;
  final String? startDate;
  final String? address;
  final String? eventLogo;
  final String? eventColor;

  EventViewModel({
    required this.externalId,
    required this.name,
    required this.timezone,
    required this.startDate,
    required this.address,
    required this.eventLogo,
    required this.eventColor,
  });

  Map toMap() => {
        'Name': name,
        'Timezone': timezone,
        'ExternalId': externalId,
        'StartDate': startDate,
        'Address': address,
        'EventLogo': eventLogo,
        'EventColor': eventColor,
      };

  String get dateWithHour {
    final date = DateTime.tryParse(startDate ?? '');
    return date?.dateMonthYear ?? '';
  }
}

class ChooseEventViewModelFactory {
  static Future<ChooseEventViewModel> make(RemoteChooseEventModel model) async {
    final List<EventViewModel> result;
    result = await Future.wait(
      model.result.map(
        (element) async => EventViewModel(
          externalId: element.externalId,
          name: await element.name?.translate(),
          timezone: element.timezone,
          startDate: element.startDate,
          address: await element.address?.translate(),
          eventLogo: element.eventLogo,
          eventColor: element.eventColor,
        ),
      ),
    );
    return ChooseEventViewModel(result: result);
  }
}
