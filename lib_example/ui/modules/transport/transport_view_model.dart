import '../../../data/models/transport/remote_transport_model.dart';
import '../../helpers/extensions/string_extension.dart';

class TransportViewModel {
  final TransportResultViewModel? transportation;

  TransportViewModel({
    required this.transportation,
  });
}

class TransportResultViewModel {
  final String? externalId;
  final String? eventExternalId;
  final String? text;
  final String? link;

  TransportResultViewModel({
    required this.externalId,
    required this.eventExternalId,
    required this.text,
    required this.link,
  });
}

class TransportViewModelFactory {
  static Future<TransportViewModel> make(RemoteTransportModel model) async {
    final transport = model.transportation;

    return TransportViewModel(
      transportation: transport != null
          ? TransportResultViewModel(
              externalId: transport.externalId,
              eventExternalId: transport.eventExternalId,
              text: await transport.text?.translate(),
              link: transport.link,
            )
          : null,
    );
  }
}
