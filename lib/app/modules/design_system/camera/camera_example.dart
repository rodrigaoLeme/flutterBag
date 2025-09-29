import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/widgets/show_add_more_documents_dialog.dart';
import '../../../core/widgets/taken_photo_option_button.dart';
import 'camera_overlay.dart';
import 'store/camera_example_controller.dart';

class CameraExample extends StatefulWidget {
  const CameraExample({Key? key}) : super(key: key);

  @override
  State<CameraExample> createState() => _CameraExampleState();
}

class _CameraExampleState extends State<CameraExample> {
  late CameraExampleController controller;
  Disposer? disposer;

  @override
  void initState() {
    super.initState();
    controller = CameraExampleController();
    disposer = controller.observer(
      onError: (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()))),
    );
  }

  @override
  void dispose() {
    controller.destroy();
    super.dispose();
  }

  Future<void> generatePdfFromListOfPaths(List<String> paths) async {
    final pdfThatContainsPictures = pw.Document();

    void putPicturesIntoThePdf() {
      for (final path in paths) {
        final image = pw.MemoryImage(
          File(path).readAsBytesSync(),
        );
        pdfThatContainsPictures.addPage(pw.Page(build: (pw.Context context) {
          return pw.Center(child: pw.Image(image));
        }));
      }
    }

    putPicturesIntoThePdf();

    Future<File> savePdf() async {
      final pdfContent = await pdfThatContainsPictures.save();

      final directoryForThePdf = await getTemporaryDirectory();

      final pdfPath = "${directoryForThePdf.path}/${DateTime.now().toIso8601String()}.pdf";

      final pdfFileToFillOut = File(pdfPath);

      return await pdfFileToFillOut.writeAsBytes(pdfContent);
    }

    final generatedPdf = await savePdf();

    void openPdf() {
      OpenDocument.openDocument(filePath: generatedPdf.path);
    }

    openPdf();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 50),
          child: LayoutBuilder(
            builder: (context, constraints) => ScopedBuilder<CameraExampleController, Exception, CameraStatus>(
              store: controller,
              onLoading: (context) => const Center(child: CircularProgressIndicator()),
              onError: (context, exception) => Text(exception.toString()),
              onState: (onStateContext, state) {
                final cameraController = state.cameraController!;
                final cameraScreen = CameraPreview(cameraController);
                if (state is Initial) {
                  return FittedBox(
                    fit: BoxFit.cover,
                    child: ConstrainedBox(
                      constraints: constraints,
                      child: Stack(
                        alignment: Alignment.center,
                        fit: StackFit.expand,
                        children: [
                          CustomPaint(
                            foregroundPainter: _PaintCamera(),
                            child: cameraScreen,
                          ),
                          ClipPath(
                            clipper: _ClipCamera(),
                            child: cameraScreen,
                          ),
                          CameraOverlay(
                            onTapToTakePicture: controller.takePicture,
                            onTapToSwitchCameras: controller.switchCameras,
                          )
                        ],
                      ),
                    ),
                  );
                }
                if (state is TakenPhoto) {
                  return ConstrainedBox(
                    constraints: constraints,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(constraints.maxWidth * 0.15, constraints.maxHeight * 0.1, constraints.maxWidth * 0.15, constraints.maxHeight * 0.2),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.file(
                              File(state.photos.last),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: const [
                                      TextSpan(text: 'Este documento está '),
                                      TextSpan(text: 'legível', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: '?'),
                                    ],
                                    style: TextStyle(color: primary, fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Gostaria de tirar outra foto?', style: TextStyle(fontSize: 16, color: primary)),
                                SizedBox(height: constraints.maxHeight * 0.04),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TakenPhotoOptionButton(
                                      onPressed: controller.excludeCurrentPhotoAndTakeAnother,
                                      label: 'Tirar outra',
                                    ),
                                    TakenPhotoOptionButton(
                                      onPressed: () {
                                        showAddMoreDocumentsDialog(
                                          context: onStateContext,
                                          onTapYes: () {
                                            Navigator.of(onStateContext).pop();
                                            controller.saveCurrentPhotoAndTakeAnother();
                                          },
                                          onTapNo: () {
                                            Navigator.of(onStateContext).pop();
                                            generatePdfFromListOfPaths(controller.state.photos).then((value) {
                                              controller.completeAllPhotos();
                                            });
                                          },
                                        );
                                      },
                                      label: 'Enviar',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }
                if (state is CompleteAllPhotos) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            controller.finish();
                          },
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Voltar'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}

// class CameraOverlayDefault extends StatelessWidget {
//   final double aspectRatio;
//   final double padding;
//   final Color color;
//   const CameraOverlayDefault({Key? key, required this.aspectRatio, required this.padding, required this.color}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         const verticalPadding = 60.0;
//         const horizontalPadding = 30.0;
//         return Stack(
//           fit: StackFit.expand,
//           children: [
//             Align(alignment: Alignment.centerLeft, child: Container(width: horizontalPadding, color: color)),
//             Align(alignment: Alignment.centerRight, child: Container(width: horizontalPadding, color: color)),
//             Align(alignment: Alignment.topCenter, child: Container(margin: const EdgeInsets.only(left: horizontalPadding, right: horizontalPadding), height: verticalPadding, color: color)),
//             Align(alignment: Alignment.bottomCenter, child: Container(margin: const EdgeInsets.only(left: horizontalPadding, right: horizontalPadding), height: verticalPadding, color: color)),
//             Container(
//               margin: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
//               decoration: BoxDecoration(border: Border.all(color: Colors.cyan), borderRadius: BorderRadius.circular(40)),
//             )
//           ],
//         );
//       },
//     );
//   }
// }

class _PaintCamera extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.grey.withOpacity(0.8), BlendMode.dstOut);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class _ClipCamera extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    debugPrint(size.toString());
    Path path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(20, size.height / 2 - 315, size.width - 40, size.height * 0.75), const Radius.circular(70)));
    return path;
  }

  @override
  bool shouldReclip(oldClipper) {
    return true;
  }
}
