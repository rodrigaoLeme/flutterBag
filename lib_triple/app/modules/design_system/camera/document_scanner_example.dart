import 'dart:io';
import 'package:flutter/material.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DocumentScannerExample extends StatefulWidget {
  const DocumentScannerExample({Key? key}) : super(key: key);

  @override
  State<DocumentScannerExample> createState() => _DocumentScannerExampleState();
}

class _DocumentScannerExampleState extends State<DocumentScannerExample> {
  File? _scannedDocumentFile;

  openPdfScanner(BuildContext context) async {
    var doc = await DocumentScannerFlutter.launchForPdf(
      context,
      labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Próximo",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE: "1 imagem para enviar",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE: "{PAGES_COUNT} imagens para enviar",
        ScannerLabelsConfig.PDF_GALLERY_EMPTY_TITLE: "Imagens para enviar",
        ScannerLabelsConfig.PDF_GALLERY_EMPTY_MESSAGE: "Nenhuma imagem encontrada",
        ScannerLabelsConfig.PDF_GALLERY_ADD_IMAGE_LABEL: "Adicionar",
        ScannerLabelsConfig.PICKER_CAMERA_LABEL: "Câmera",
        ScannerLabelsConfig.PICKER_GALLERY_LABEL: "Galeria de Fotos",
        ScannerLabelsConfig.ANDROID_OK_LABEL: "Concluir",
        ScannerLabelsConfig.ANDROID_APPLYING_FILTER_MESSAGE: "Sei lá",
        ScannerLabelsConfig.ANDROID_SAVE_BUTTON_LABEL: "Salvar",
        ScannerLabelsConfig.PDF_GALLERY_DONE_LABEL: "Finalizar",
      },
      //source: ScannerFileSource.CAMERA
    );
    if (doc != null) {
      setState(() {});
      await Future.delayed(const Duration(milliseconds: 100));

      // print('Original path: ${doc.path}');
      // String dir = path.dirname(doc.path);
      // String newPath = path.join(dir, 'teste.pdf');
      // print('NewPath: $newPath');
      // doc.rename(newPath);
      _scannedDocumentFile = doc;
      //print(_scannedDocumentFile?.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_scannedDocumentFile?.path ?? ''),
        ),
        Center(
          child: Builder(builder: (context) {
            return ElevatedButton(onPressed: () => openPdfScanner(context), child: const Text("PDF Scan"));
          }),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Modular.to.pop();
          },
          icon: const Icon(Icons.arrow_back_rounded),
          label: const Text('Voltar'),
        )
      ],
    ));
  }
}
