class Params {
  final String deviceCode;
  final String nameidentifier;
  final SetDeviceCodeOperation operation;

  const Params({required this.deviceCode, required this.nameidentifier, required this.operation});
  
  factory Params.finish() => const Params(deviceCode: '', nameidentifier: '', operation: SetDeviceCodeOperation.finish);
}

enum SetDeviceCodeOperation { start, finish }
