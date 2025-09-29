part of 'camera_example_controller.dart';

abstract class CameraStatus {
  String get message;
  final List<String> photos;
  CameraStatus copyWith({List<String>? photos, CameraController? cameraController, List<CameraDescription>? availableCameraList});
  final CameraController? cameraController;
  final List<CameraDescription>? availableCameraList;

  const CameraStatus({required this.photos, this.cameraController, this.availableCameraList});
}

abstract class CameraStatusWithOneOption extends CameraStatus {
  CameraStatus get next;

  const CameraStatusWithOneOption({required super.photos, super.cameraController, super.availableCameraList});
}

abstract class CameraStatusWithTwoOptions extends CameraStatus {
  CameraStatus get next;
  CameraStatus get alternative;

  const CameraStatusWithTwoOptions({required super.photos, super.cameraController, super.availableCameraList});
}

class Initial extends CameraStatusWithOneOption {
  @override
  final message = 'Tire uma foto';

  @override
  CameraStatus get next => TakenPhoto(photos: photos, availableCameraList: availableCameraList, cameraController: cameraController);

  const Initial({required super.photos, super.cameraController, super.availableCameraList});

  @override
  Initial copyWith({List<String>? photos, CameraController? cameraController, List<CameraDescription>? availableCameraList}) {
    return Initial(photos: photos ?? this.photos, cameraController: cameraController ?? this.cameraController, availableCameraList: availableCameraList ?? this.availableCameraList);
  }
}

class TakenPhoto extends CameraStatusWithTwoOptions {
  @override
  final message = 'Foto tirada. Gostou dela ou quer tirar outra?';

  CameraStatus get finishAllPhotos => CompleteAllPhotos(photos: photos, availableCameraList: availableCameraList, cameraController: cameraController);
  CameraStatus get takeAnother => Initial(photos: photos, availableCameraList: availableCameraList, cameraController: cameraController);

  @override
  CameraStatus get next => finishAllPhotos;
  @override
  CameraStatus get alternative => takeAnother;

  @override
  TakenPhoto copyWith({List<String>? photos, CameraController? cameraController, List<CameraDescription>? availableCameraList}) {
    return TakenPhoto(photos: photos ?? this.photos, cameraController: cameraController ?? this.cameraController, availableCameraList: availableCameraList ?? this.availableCameraList);
  }

  const TakenPhoto({required super.photos, super.cameraController, super.availableCameraList});
}

class CompleteAllPhotos extends CameraStatusWithOneOption {
  @override
  String get message => 'Todas as fotos serão enviadas';

  @override
  CameraStatus get next => Initial(photos: [], availableCameraList: availableCameraList, cameraController: cameraController);

  @override
  CompleteAllPhotos copyWith({List<String>? photos, CameraController? cameraController, List<CameraDescription>? availableCameraList}) {
    return CompleteAllPhotos(photos: photos ?? this.photos, cameraController: cameraController ?? this.cameraController, availableCameraList: availableCameraList ?? this.availableCameraList);
  }

  const CompleteAllPhotos({required super.photos, super.cameraController, super.availableCameraList});
}
