import '../../../domain/usecases/set_device_code/params.dart';

class Mapper {
  const Mapper();

  List<Map<String, String>> getDataFromParams(Params params) {
    late final String operation;
    switch (params.operation) {
      case SetDeviceCodeOperation.start:
        operation = 'replace';
        break;
      case SetDeviceCodeOperation.finish:
        operation = 'remove';
        break;
    }
    return [
      {
        'op': operation,
        'path': '/fcmregistrationtoken',
        'value': params.deviceCode,
      }
    ];
  }
}
