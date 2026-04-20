import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

part 'states.dart';

class Controller extends StreamStore<Exception, CameraStatus> {
  Controller() : super(const Initial(photos: [])) {
    setLoading(true);
    _requestStoragePermission().then((isStoragePermissionGranted) {
      if (!isStoragePermissionGranted) {
        setError(Exception('Permissão para acessar o armazenamento local negada'));
        setLoading(false);
        Modular.to.pop();
        return;
      }
      _checkWhetherIosSystemVersionSupportsCameraPackage().then((isCameraAvailableForThisOS) {
        if (!isCameraAvailableForThisOS) {
          setError(Exception('Câmera não suportada'));
          setLoading(false);
          Modular.to.pop();
          return;
        }
        _initializeCamera();
      }).catchError((e) {
        setError(Exception('Não foi possível verificar o sistema operacional'));
        setLoading(false);
        Modular.to.pop();
        return;
      });
    }).catchError((e) {
      setError(Exception('Não foi possível solicitar a permissão para acessar o armazenamento'));
      setLoading(false);
      Modular.to.pop();
      return;
    });
  }

  void takePicture() async {
    if (state.cameraController!.value.isTakingPicture) return;
    final photo = await state.cameraController!.takePicture();
    final oldPhotoList = [
      ...state.photos
    ];
    final timeStamp = DateTime.now();
    final directory = await getTemporaryDirectory();
    final photoPath = '${directory.path}/photo-${timeStamp.toIso8601String()}.jpg';
    await photo.saveTo(photoPath);
    final newState = state.copyWith(photos: oldPhotoList..add(photoPath));
    update((newState as Initial).next);
  }

  void excludeCurrentPhotoAndTakeAnother() {
    if (state.photos.isEmpty) {
      return;
    }
    final newState = state.copyWith(photos: state.photos..removeLast());
    update((newState as TakenPhoto).alternative);
  }

  void saveCurrentPhotoAndTakeAnother() {
    update((state as TakenPhoto).alternative);
  }

  void completeAllPhotos() {
    update((state as TakenPhoto).next);
  }

  // void finish(File pdfFile) {
  //   Modular.to.pop(pdfFile);
  //   update((state as CompleteAllPhotos).next);
  // }
  void finish(List<String> filePaths) {
    Modular.to.pop(filePaths);
    update((state as CompleteAllPhotos).next);
  }

  void switchCameras() {
    if (isLoading || state.cameraController!.value.isTakingPicture) return;
    setLoading(true);
    final currentLensDirection = state.cameraController!.description.lensDirection;
    late CameraDescription newCamera;
    switch (currentLensDirection) {
      case CameraLensDirection.back:
        newCamera = state.availableCameraList!.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.front,
          orElse: () {
            log('Não foi detectada câmera frontal.');
            return state.cameraController!.description;
          },
        );
        break;
      case CameraLensDirection.front:
        newCamera = state.availableCameraList!.firstWhere(
          (element) => element.lensDirection == CameraLensDirection.back,
          orElse: () {
            log('Não foi detectada câmera traseira.');
            return state.cameraController!.description;
          },
        );
        break;
      default:
    }
    if (newCamera == state.cameraController!.description) {
      setError(Exception('Não foi possível trocar de câmera'));
      setLoading(false);
      return;
    }
    final newCameraController = CameraController(newCamera, ResolutionPreset.max, enableAudio: false);
    newCameraController.initialize().then((_) {
      update(state.copyWith(cameraController: newCameraController));
      setLoading(false);
    }).catchError(_onCameraException);
  }

  Future<bool> _requestStoragePermission() => Permission.storage.request().then((afterRequestingPermission) => afterRequestingPermission.isGranted);

  Future<bool> _checkWhetherIosSystemVersionSupportsCameraPackage() async {
    final plugin = DeviceInfoPlugin();
    if (Platform.isIOS) {
      final info = await plugin.iosInfo;
      final iOSVersion = info.systemVersion;
      if (iOSVersion == null) {
        log('Não foi possível abrir a câmera: Versão do sistema iOS recebida é nula');
        return false;
      }
      if (iOSVersion.isEmpty) {
        log('Não foi possível abrir a câmera: Versão do sistema iOS é vazia');
        return false;
      }
      if (iOSVersion.contains('10')) {
        log(info.systemVersion ?? '');
        return false;
      }
      return true;
    } else if (Platform.isAndroid) {
      final info = await plugin.androidInfo;
      log(info.version.sdkInt.toString());
      return true;
    }
    return false;
  }

  void _initializeCamera() {
    availableCameras().then((returnedCameras) async {
      if (returnedCameras.isEmpty) {
        setError(Exception('Não há câmeras disponíveis'));
        setLoading(false);
        return;
      }
      final controller = CameraController(returnedCameras[0], ResolutionPreset.high, enableAudio: false);
      controller.initialize().then((value) {
        update(state.copyWith(cameraController: controller, availableCameraList: returnedCameras));
        setLoading(false);
      }).catchError(_onCameraException);
    }).catchError(_onCameraException);
  }

  _onCameraException(Object e) {
    late final String message;
    if (e is CameraException) {
      switch (e.code) {
        case 'CameraAccessDenied':
          message = 'Você não tem permissão para usar a câmera';
          break;
        default:
          message = 'Não foi possível usar a câmera: ${e.code}\n${e.description}\nTratar esta exceção o quanto antes';
      }
    }
    setLoading(false);
    setError(Exception(message));
    Modular.to.pop();
  }

  @override
  Future destroy() {
    state.cameraController?.dispose();
    return super.destroy();
  }
}
