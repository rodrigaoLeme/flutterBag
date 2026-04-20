import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../check_device_permissions.dart';
import '../group_document_params.dart';
import '../group_params.dart';
import '../select_group_document/stores/usecases/get_accepted_documents_by_proof/store.dart'
    as accepted_documents;
import '../select_group_document/stores/usecases/get_proofs_by_family_params/store.dart'
    as proofs;
import '../stores/usecases/get_document_by_file_id/store.dart'
    as get_document_by_file_id;
import '../stores/usecases/send_proof_documents/store.dart'
    as send_proof_document;
import '../view_photo/controller.dart' as view_photo;
import 'states.dart';

class Controller extends StreamStore<String, StoreState> {
  final GroupParams params;
  final GroupDocumentParams groupDocumentParams;
  final proofs.Store getProofsStore;
  final send_proof_document.Store sendProofDocumentStore;
  final get_document_by_file_id.Store getDocumentByFileIdStore;
  final accepted_documents.Store getAcceptedDocumentsByProofStore;
  final maxSizeInBytes = 20 * 1024 * 1024;
  Controller(
      this.groupDocumentParams,
      this.sendProofDocumentStore,
      this.getDocumentByFileIdStore,
      this.params,
      this.getProofsStore,
      this.getAcceptedDocumentsByProofStore)
      : super(const Initial());

  Future<void> initAddingFromCellphone() async {
    setLoading(true, force: true);
    final result = await _selectFromCellphone();
    List<String> photoPaths = [];
    result.fold(
      (l) {
        setError(l);
        update(state, force: true);
        setLoading(false, force: true);
      },
      (r) {
        photoPaths = r;
      },
    );
    //setLoading(false, force: true);
    if (photoPaths.isEmpty) {
      setLoading(false, force: true);
      return;
    }
    if (state is NewSet) {
      update(
        NewAddingPdf(
            photoPaths: photoPaths,
            documentId: state.documentId,
            scholarshipProofDocumentId: state.scholarshipProofDocumentId,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
      );
    } else if (state is EditingSet) {
      final localState = (state as EditingSet);
      update(
        EditingAddingPdf(
            photoPaths: photoPaths,
            stateBeforeEditing: localState.stateBeforeEditing,
            documentId: localState.documentId,
            editingScholarshipProofDocumentId:
                localState.editingScholarshipProofDocumentId,
            scholarshipProofDocumentId: localState.scholarshipProofDocumentId,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
      );
    }
    update(state, force: true);
    setLoading(false, force: true);
  }

  Future<Either<String, List<String>>> _selectFromCellphone() async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf', 'jpeg', 'jpg', 'png'],
        type: FileType.custom,
      );

      if (result != null) {
        final pathsToGeneratePdf = <String>[];
        final path = result.paths.first;
        if (path == null) {
          return const Left('Arquivo não encontrado');
        }
        final file = File(path);
        final fileSize = await file.length();
        if (fileSize > maxSizeInBytes) {
          return const Left('O arquivo selecionado excede o limite de 20MB.');
        }
        pathsToGeneratePdf.add(path);
        var newString = path.substring(path.length - 5);
        final splitted = newString.split('.');
        if (splitted[1] == 'pdf' || splitted[1] == 'PDF') {
          return Right(pathsToGeneratePdf);
        } else if (splitted[1] == 'png' ||
            splitted[1] == 'PNG' ||
            splitted[1] == 'jpg' ||
            splitted[1] == 'JPG' ||
            splitted[1] == 'jpeg' ||
            splitted[1] == 'JPEG') {
          File? pdfFile;
          try {
            pdfFile = await _generatePdfFromListOfPaths(pathsToGeneratePdf);
          } catch (e) {
            return const Left(
                'Não foi possível gerar o arquivo .pdf a partir da imagem selecionada. Contate a administração.');
          }
          final pathsToGeneratePdf2 = [pdfFile.path];
          return Right(pathsToGeneratePdf2);
        } else {
          return const Left('Não foi possível selecionar o arquivo');
        }
      } else {
        return const Left('Nenhum arquivo selecionado');
      }
    } catch (e) {
      return const Left('Não foi possível selecionar o arquivo');
    }
  }

  Future<void> takeDocumentScanner({
    required String documentId,
    required String scholarshipProofDocumentId,
    bool isRequiredDocument = false,
    required BuildContext context,
  }) async {
    final hasPermissions =
        await CheckDevicePermissions.shared.checkScannerPermissions(context);
    if (!hasPermissions) return;

    if (isRequiredDocument) {
      setNewAcceptedDocumentValues(
        documentId: documentId,
        scholarshipProofDocumentId: scholarshipProofDocumentId,
        documentName: state.selectedAcceptedDocumentName,
      );
    }

    if (Platform.isAndroid) {
      setLoading(true, force: true);

      // Abre o scanner (galeria opcional)
      final images = await CunningDocumentScanner.getPictures(
        noOfPages: 20, // ou null para ilimitado
        isGalleryImportAllowed: true,
      );

      if (images == null || images.isEmpty) {
        update(state, force: true);
        setLoading(false, force: true);
        return;
      }

      // Gera PDF com as imagens
      final pdf = pw.Document();
      for (final imagePath in images) {
        final image = File(imagePath);
        final imageBytes = await image.readAsBytes();
        final pdfImage = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                  child: pw.Image(pdfImage, fit: pw.BoxFit.contain));
            },
          ),
        );
      }

      // Salva o PDF em um arquivo temporário
      final dir = await getTemporaryDirectory();
      final sanitizedName =
          state.selectedAcceptedDocumentName.replaceAll('/', '-').trim();
      final pdfFile = File('${dir.path}/$sanitizedName.pdf');
      await pdfFile.writeAsBytes(await pdf.save());

      final fileSize = await pdfFile.length();
      if (fileSize > maxSizeInBytes) {
        setError('O arquivo PDF excede o tamanho máximo permitido de 20MB.');
        update(state, force: true);
        setLoading(false, force: true);
        return;
      }

      // Atualiza seu estado com o caminho do PDF gerado
      final List<String> photoPath = [pdfFile.path];

      if (state is NewSet) {
        update(
          NewAddingPdf(
              photoPaths: photoPath,
              documentId: state.documentId,
              scholarshipProofDocumentId: state.scholarshipProofDocumentId,
              files: state.files,
              selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
        );
      } else if (state is EditingSet) {
        final localState = (state as EditingSet);
        update(
          EditingAddingPdf(
              photoPaths: photoPath,
              stateBeforeEditing: localState.stateBeforeEditing,
              documentId: localState.documentId,
              editingScholarshipProofDocumentId:
                  localState.editingScholarshipProofDocumentId,
              scholarshipProofDocumentId: localState.scholarshipProofDocumentId,
              files: state.files,
              selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
        );
      }

      update(state, force: true);
      setLoading(false, force: true);
    } else {
      File? scannedDoc =
          await DocumentScannerFlutter.launchForPdf(context, labelsConfig: {
        ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Próximo",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_SINGLE:
            "1 foto para enviar",
        ScannerLabelsConfig.PDF_GALLERY_FILLED_TITLE_MULTIPLE:
            "{PAGES_COUNT} fotos para enviar",
        ScannerLabelsConfig.PDF_GALLERY_EMPTY_TITLE: "Gerenciador de Fotos",
        ScannerLabelsConfig.PDF_GALLERY_EMPTY_MESSAGE:
            "Nenhuma foto adicionada",
        ScannerLabelsConfig.PDF_GALLERY_ADD_IMAGE_LABEL: "Adicionar",
        ScannerLabelsConfig.PICKER_CAMERA_LABEL: "Câmera",
        ScannerLabelsConfig.PICKER_GALLERY_LABEL: "Galeria de Fotos",
        ScannerLabelsConfig.ANDROID_OK_LABEL: "Concluir",
        ScannerLabelsConfig.ANDROID_SAVE_BUTTON_LABEL: "Salvar",
        ScannerLabelsConfig.PDF_GALLERY_DONE_LABEL: "Finalizar"
      });
      if (scannedDoc == null) return;

      final fileSize = await scannedDoc.length();
      if (fileSize > maxSizeInBytes) {
        setError('O arquivo PDF excede o tamanho máximo permitido de 20MB.');
        update(state, force: true);
        setLoading(false, force: true);
        return;
      }

      final List<String> photoPath = [scannedDoc.path];
      if (state is NewSet) {
        update(
          NewAddingPdf(
              photoPaths: photoPath,
              documentId: state.documentId,
              scholarshipProofDocumentId: state.scholarshipProofDocumentId,
              files: state.files,
              selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
        );
      } else if (state is EditingSet) {
        final localState = (state as EditingSet);
        update(
          EditingAddingPdf(
              photoPaths: photoPath,
              stateBeforeEditing: localState.stateBeforeEditing,
              documentId: localState.documentId,
              editingScholarshipProofDocumentId:
                  localState.editingScholarshipProofDocumentId,
              scholarshipProofDocumentId: localState.scholarshipProofDocumentId,
              files: state.files,
              selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
        );
      }
      update(state, force: true);
      setLoading(false, force: true);
    }
  }

  Future<void> takePhoto(
      {required String documentId,
      required String scholarshipProofDocumentId,
      bool isRequiredDocument = false}) async {
    if (isRequiredDocument) {
      setNewAcceptedDocumentValues(
          documentId: documentId,
          scholarshipProofDocumentId: scholarshipProofDocumentId,
          documentName: state.selectedAcceptedDocumentName);
    }
    setLoading(true, force: true);
    final List<String>? photoPaths = await Modular.to.pushNamed('camera');
    //if (pdfFile == null) return setError(Exception('Não foi possível gerar o arquivo .pdf'));
    if (photoPaths != null) {
      if (state is EditingSet) {
        final localState = (state as EditingSet);
        update(EditingAdding(
            stateBeforeEditing: localState.stateBeforeEditing,
            editingScholarshipProofDocumentId:
                localState.editingScholarshipProofDocumentId,
            documentId: state.documentId,
            scholarshipProofDocumentId: state.scholarshipProofDocumentId,
            photoPaths: photoPaths,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName));
      } else if (state is NewSet) {
        update(NewAdding(
            documentId: state.documentId,
            scholarshipProofDocumentId: state.scholarshipProofDocumentId,
            photoPaths: photoPaths,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName));
      }
    } else {
      update(state, force: true);
    }
    setLoading(false, force: true);
  }

  void deleteOnePhoto({required int index}) {
    if (state is NewAdding) {
      final addingState = (state as Adding);
      final newList = [...addingState.photoPaths..removeAt(index)];
      if (newList.isEmpty) {
        update(
          NewSet(
              documentId: addingState.documentId,
              scholarshipProofDocumentId:
                  addingState.scholarshipProofDocumentId,
              files: state.files,
              selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
        );
      } else {
        update(addingState.copyWith(photoPaths: newList));
      }
    } else if (state is EditingAdding) {
      final addingState = (state as EditingAdding);
      final newList = [...addingState.photoPaths..removeAt(index)];
      if (newList.isEmpty) {
        update(
          EditingSet(
              documentId: addingState.documentId,
              editingScholarshipProofDocumentId:
                  addingState.editingScholarshipProofDocumentId,
              scholarshipProofDocumentId:
                  addingState.scholarshipProofDocumentId,
              stateBeforeEditing: addingState.stateBeforeEditing,
              files: state.files,
              selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
        );
      } else {
        update(addingState.copyWith(photoPaths: newList));
      }
    }
  }

  void deletePdf() {
    update(
      NewSet(
          documentId: state.documentId,
          scholarshipProofDocumentId: state.scholarshipProofDocumentId,
          files: state.files,
          selectedAcceptedDocumentName: state.selectedAcceptedDocumentName),
    );
  }

  Future<void> sendPhotos(
      {required String documentId,
      required String scholarshipProofDocumentId}) async {
    if (state is Adding) {
      final addingState = (state as Adding);
      if (addingState.photoPaths.isEmpty) return;
      setLoading(true);
      await _generateAndSendPdfFile(
          paths: addingState.photoPaths,
          documentId: addingState.documentId,
          scholarshipProofDocumentId: scholarshipProofDocumentId);
    }
  }

  Future _generateAndSendPdfFile(
      {required String documentId,
      required String scholarshipProofDocumentId,
      required List<String> paths}) async {
    File? pdfFile;
    try {
      pdfFile = await _generatePdfFromListOfPaths(paths);
    } catch (e) {
      setError(
          'Não foi possível gerar o arquivo .pdf. Contate a administração.');
      update(state, force: true);
      return setLoading(false, force: true);
    }
    await _sendPhotosAsPdf(
        documentId: documentId,
        scholarshipProofDocumentId: scholarshipProofDocumentId,
        pdfFile: pdfFile);
  }

  Future<File> _generatePdfFromListOfPaths(List<String> paths) async {
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

      //final pdfPath = "${directoryForThePdf.path}/${DateTime.now().toIso8601String()}.pdf";
      final pdfPath =
          "${directoryForThePdf.path}/${state.selectedAcceptedDocumentName}.pdf";

      final pdfFileToFillOut = File(pdfPath);

      return await pdfFileToFillOut.writeAsBytes(pdfContent);
    }

    final generatedPdf = await savePdf();

    // void openPdf() {
    //   OpenDocument.openDocument(filePath: generatedPdf.path);
    // }

    // openPdf();
    return generatedPdf;
  }

  Future<void> _sendPhotosAsPdf(
      {required String documentId,
      required String scholarshipProofDocumentId,
      required File pdfFile}) async {
    await sendProofDocumentStore(send_proof_document.Params(
        acceptTerm: true,
        documentId: documentId,
        file: pdfFile,
        scholarshipProofDocumentId: scholarshipProofDocumentId,
        origin: 'App'));
    if (sendProofDocumentStore.error == null) {
      //OLD Business login where "sentFile" was being sent from the API as a response. If it's fulfilled, I updated the list locally instead of doing a remote request.
      final scholarshipProofDocumentListId = groupDocumentParams
          .scholarshipProofDocuments!
          .indexWhere((element) => element.id == scholarshipProofDocumentId);
      //final newDocument = groupDocumentParams.scholarshipProofDocuments![scholarshipProofDocumentListId].copyWith(fileId: sendProofDocumentStore.state.sentFile);
      final newDocument = groupDocumentParams
          .scholarshipProofDocuments![scholarshipProofDocumentListId]
          .copyWith(fileId: 'OK');
      final oldDocumentList = [
        ...groupDocumentParams.scholarshipProofDocuments!
      ];
      oldDocumentList[scholarshipProofDocumentListId] = newDocument;
      groupDocumentParams.scholarshipProofDocuments = oldDocumentList;
      //TODO(adbysantos) Trazer o caso de uso de buscar documentos para esta classe para atualizar a lista de documentos após enviar documentos corretamente.
      if (state is EditingAdding) {
        update((state as EditingAdding).stateBeforeEditing, force: true);
      } else {
        update(const Initial());
      }
    } else {
      setError('${sendProofDocumentStore.error}', force: true);
      update(state, force: true);
    }
    setLoading(false, force: true);
  }

  Future<void> sendPdf({
    required File pdfFile,
    required bool documentHasDeclarationToShow,
    required String fileId,
  }) async {
    setLoading(true, force: true);
    await sendProofDocumentStore(send_proof_document.Params(
        acceptTerm: documentHasDeclarationToShow,
        documentId: state.documentId,
        file: pdfFile,
        scholarshipProofDocumentId: state.scholarshipProofDocumentId,
        origin: 'App'));
    if (sendProofDocumentStore.error == null) {
      //OLD Business login where "sentFile" was being sent from the API as a response. If it's fulfilled, I updated the list locally instead of doing a remote request.
      final scholarshipProofDocumentListId =
          groupDocumentParams.scholarshipProofDocuments!.indexWhere(
              (element) => element.id == state.scholarshipProofDocumentId);
      final newDocument = groupDocumentParams
          .scholarshipProofDocuments![scholarshipProofDocumentListId]
          .copyWith(fileId: fileId);
      final oldDocumentList = [
        ...groupDocumentParams.scholarshipProofDocuments!
      ];
      oldDocumentList[scholarshipProofDocumentListId] = newDocument;
      groupDocumentParams.scholarshipProofDocuments = oldDocumentList;

      if (state is EditingAdding) {
        update((state as EditingAdding).stateBeforeEditing, force: true);
      } else {
        update(const Initial());
      }
    } else {
      setError('${sendProofDocumentStore.error}', force: true);
      update(state, force: true);
    }
    setLoading(false, force: true);
  }

  void setNewAcceptedDocumentValues({
    required String documentId,
    required String scholarshipProofDocumentId,
    required String documentName,
  }) {
    if (state is Editing) {
      update(
          EditingSet(
              editingScholarshipProofDocumentId: scholarshipProofDocumentId,
              stateBeforeEditing: (state as Editing).stateBeforeEditing,
              documentId: documentId,
              scholarshipProofDocumentId: scholarshipProofDocumentId,
              files: state.files,
              selectedAcceptedDocumentName: documentName),
          force: true);
    } else {
      update(
          NewSet(
              documentId: documentId,
              scholarshipProofDocumentId: scholarshipProofDocumentId,
              files: state.files,
              selectedAcceptedDocumentName: documentName),
          force: true);
    }
  }

  void openPhotoFromFile({required File file}) {
    Modular.to.pushNamed(
      'view_photo',
      arguments: view_photo.Controller(file: file, onTapClose: Modular.to.pop),
    );
  }

  void exitEditingMode() {
    if (state is Editing) {
      update((state as Editing).stateBeforeEditing);
    }
  }

  void showResendOption(ConfirmEditing confirmEditing) {
    update(confirmEditing);
  }

  void startSendingOneDocument(EditingSet editingSet) {
    update(editingSet);
  }
}
