import 'package:flutter/material.dart';

//TODO(adbysantos) Pendências no usecase de câmera:
//1 - i18n no arquivo Info.plist para permissão de câmera
class CameraOverlay extends StatelessWidget {
  final VoidCallback onTapToTakePicture;
  final VoidCallback onTapToSwitchCameras;
  const CameraOverlay({Key? key, required this.onTapToTakePicture, required this.onTapToSwitchCameras}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 12),
                    child: const Text(
                      'Tente enquadrar a frente do\ndocumento no retângulo abaixo',
                      textAlign: TextAlign.center,
                      textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: false),
                      style: TextStyle(color: Colors.white, height: 1.3),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: onTapToSwitchCameras,
                      icon: const Icon(Icons.flip_camera_ios),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Material(
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTapToTakePicture,
                  child: Container(
                    height: 50,
                    width: 50,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.black)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
