import 'dart:developer';
import 'dart:io';

import 'package:cunning_document_scanner/cunning_document_scanner.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:either_dart/either.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart' as triple;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../check_device_permissions.dart';
import '../group_document_params.dart';
import '../group_params.dart';
import '../stores/usecases/get_document_by_file_id/store.dart'
    as get_document_by_file_id;
import '../stores/usecases/send_proof_documents/store.dart'
    as send_proof_document;
import '../view_photo/controller.dart' as view_photo;
import 'states.dart';
import 'stores/usecases/get_accepted_documents_by_proof/store.dart'
    as accepted_documents;
import 'stores/usecases/get_proofs_by_family_params/store.dart' as proofs;

class Controller extends triple.StreamStore<String, StoreState> {
  final proofs.Store getProofsStore;
  final accepted_documents.Store getAcceptedDocumentsByProofStore;
  final GroupParams params;
  final GroupDocumentParams groupDocumentParams;
  final send_proof_document.Store sendProofDocumentStore;
  final get_document_by_file_id.Store getDocumentByFileIdStore;
  final maxSizeInBytes = 20 * 1024 * 1024;

  Controller(
      this.params,
      this.getProofsStore,
      this.getAcceptedDocumentsByProofStore,
      this.groupDocumentParams,
      this.sendProofDocumentStore,
      this.getDocumentByFileIdStore)
      : super(const Initial());

  Future<void> getProofs() async {
    if (params.proofParams == null) {
      return log(
        'Proof Params está nulo',
      );
    }
    return getProofsStore(params.proofParams!);
  }

  void setNewProofDocumentValues(
    String proofId,
    String scholarshipProofDocumentId,
    String proofDocumentId,
    String proofDocumentName,
    String scholarshipProofId,
  ) {
    update(
        NewSet(
          selectedProofId: proofId,
          selectedScholarshipProofDocumentId: scholarshipProofDocumentId,
          selectedAcceptedDocumentId: proofDocumentId,
          files: state.files,
          selectedAcceptedDocumentName: proofDocumentName,
          scholarshipProofId: scholarshipProofId,
        ),
        force: true);
  }

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
      update(NewAddingPdf(
          selectedProofId: state.selectedProofId,
          selectedScholarshipProofDocumentId:
              state.selectedScholarshipProofDocumentId,
          selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
          photoPaths: photoPaths,
          files: state.files,
          selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
          scholarshipProofId: state.scholarshipProofId));
    } else if (state is EditingSet) {
      final localState = (state as EditingSet);
      update(EditingAddingPdf(
          selectedScholarshipProofDocumentId:
              state.selectedScholarshipProofDocumentId,
          selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
          photoPaths: photoPaths,
          stateBeforeEditing: localState.stateBeforeEditing,
          editingProofId: localState.editingProofId,
          selectedProofId: localState.selectedProofId,
          files: state.files,
          selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
          scholarshipProofId: state.scholarshipProofId));
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

  Future<void> takeDocumentScanner(BuildContext context) async {
    final hasPermissions =
        await CheckDevicePermissions.shared.checkScannerPermissions(context);
    if (!hasPermissions) return;

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
        update(NewAddingPdf(
            selectedProofId: state.selectedProofId,
            selectedScholarshipProofDocumentId:
                state.selectedScholarshipProofDocumentId,
            selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
            photoPaths: photoPath,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
            scholarshipProofId: state.scholarshipProofId));
      } else if (state is EditingSet) {
        final localState = (state as EditingSet);
        update(EditingAddingPdf(
            selectedScholarshipProofDocumentId:
                state.selectedScholarshipProofDocumentId,
            selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
            photoPaths: photoPath,
            stateBeforeEditing: localState.stateBeforeEditing,
            editingProofId: localState.editingProofId,
            selectedProofId: localState.selectedProofId,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
            scholarshipProofId: state.scholarshipProofId));
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
        update(NewAddingPdf(
            selectedProofId: state.selectedProofId,
            selectedScholarshipProofDocumentId:
                state.selectedScholarshipProofDocumentId,
            selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
            photoPaths: photoPath,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
            scholarshipProofId: state.scholarshipProofId));
      } else if (state is EditingSet) {
        final localState = (state as EditingSet);
        update(EditingAddingPdf(
            selectedScholarshipProofDocumentId:
                state.selectedScholarshipProofDocumentId,
            selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
            photoPaths: photoPath,
            stateBeforeEditing: localState.stateBeforeEditing,
            editingProofId: localState.editingProofId,
            selectedProofId: localState.selectedProofId,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
            scholarshipProofId: state.scholarshipProofId));
      }
      update(state, force: true);
      setLoading(false, force: true);
    }
  }

  Future<void> takePhoto() async {
    setLoading(true, force: true);
    //final File? pdfFile = await Modular.to.pushNamed('camera');
    final List<String>? photoPaths = await Modular.to.pushNamed('camera');
    //if (pdfFile == null) return setError(Exception('Não foi possível gerar o arquivo .pdf'));
    if (photoPaths != null) {
      if (state is NewSet) {
        update(NewAdding(
            selectedProofId: state.selectedProofId,
            selectedScholarshipProofDocumentId:
                state.selectedScholarshipProofDocumentId,
            selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
            photoPaths: photoPaths,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
            scholarshipProofId: state.scholarshipProofId));
      } else if (state is EditingSet) {
        final localState = (state as EditingSet);
        update(EditingAdding(
            selectedScholarshipProofDocumentId:
                state.selectedScholarshipProofDocumentId,
            selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
            photoPaths: photoPaths,
            stateBeforeEditing: localState.stateBeforeEditing,
            editingProofId: localState.editingProofId,
            selectedProofId: localState.selectedProofId,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
            scholarshipProofId: state.scholarshipProofId));
      }
    }
    update(state, force: true);
    setLoading(false, force: true);
  }

  Future<void> sendPhotos() async {
    if (state is Adding) {
      final addingState = (state as Adding);
      if (addingState.photoPaths.isEmpty) return;
      setLoading(true);
      await _generateAndSendPdfFile(paths: addingState.photoPaths);
    }
  }

  Future _generateAndSendPdfFile({required List<String> paths}) async {
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
        documentId: state.selectedAcceptedDocumentId,
        scholarshipProofDocumentId: state.selectedScholarshipProofDocumentId,
        pdfFile: pdfFile);
  }

  void deleteOnePhoto({required int index}) {
    if (state is NewAdding) {
      final addingState = (state as Adding);
      final newList = [...addingState.photoPaths..removeAt(index)];
      if (newList.isEmpty) {
        update(NewSet(
            selectedProofId: state.selectedProofId,
            selectedScholarshipProofDocumentId:
                state.selectedScholarshipProofDocumentId,
            selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
            scholarshipProofId: state.scholarshipProofId));
      } else {
        update(addingState.copyWith(photoPaths: newList));
      }
    } else if (state is EditingAdding) {
      final addingState = (state as EditingAdding);
      final newList = [...addingState.photoPaths..removeAt(index)];
      if (newList.isEmpty) {
        update(EditingSet(
            selectedProofId: state.selectedProofId,
            selectedScholarshipProofDocumentId:
                state.selectedScholarshipProofDocumentId,
            selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
            editingProofId: addingState.editingProofId,
            stateBeforeEditing: addingState.stateBeforeEditing,
            files: state.files,
            selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
            scholarshipProofId: state.scholarshipProofId));
      } else {
        update(addingState.copyWith(photoPaths: newList));
      }
    }
  }

  void deletePdf() {
    update(NewSet(
        selectedProofId: state.selectedProofId,
        selectedScholarshipProofDocumentId:
            state.selectedScholarshipProofDocumentId,
        selectedAcceptedDocumentId: state.selectedAcceptedDocumentId,
        files: state.files,
        selectedAcceptedDocumentName: state.selectedAcceptedDocumentName,
        scholarshipProofId: state.scholarshipProofId));
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

      final currentSelectedAcceptedDocumentName =
          state.selectedAcceptedDocumentName;

      if (currentSelectedAcceptedDocumentName.contains('/')) {
        update(state.copyWith(
            selectedAcceptedDocumentName:
                currentSelectedAcceptedDocumentName.replaceAll('/', '')));
      }

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
    final acceptTerm = getAcceptedDocumentsByProofStore.state.acceptedDocuments
            .firstWhere((element) => element.id == documentId)
            .isDeclaration ==
        true;
    await sendProofDocumentStore(send_proof_document.Params(
      acceptTerm: acceptTerm,
      documentId: documentId,
      file: pdfFile,
      scholarshipProofDocumentId: scholarshipProofDocumentId,
      origin: 'App',
    ));
    if (sendProofDocumentStore.error == null) {
      getProofs();
      update(const Initial());
    } else {
      setError(
          'Não foi possível enviar o arquivo para o servidor. Contate a administração.');
      update(state, force: true);
    }
    setLoading(false, force: true);
  }

  Future<void> sendPdf({required File pdfFile}) async {
    setLoading(true, force: true);
    final acceptTerm = getAcceptedDocumentsByProofStore.state.acceptedDocuments
            .firstWhere(
                (element) => element.id == state.selectedAcceptedDocumentId)
            .isDeclaration ==
        true;
    await sendProofDocumentStore(send_proof_document.Params(
      acceptTerm: acceptTerm,
      documentId: state.selectedAcceptedDocumentId,
      file: pdfFile,
      scholarshipProofDocumentId: state.selectedScholarshipProofDocumentId,
      origin: 'App',
    ));
    if (sendProofDocumentStore.error == null) {
      getProofs();
      update(const Initial());
    } else {
      setError(
          'Não foi possível enviar o arquivo para o servidor. Contate a administração.');
      update(state, force: true);
    }
    setLoading(false, force: true);
  }

  void reset() {
    update(const Initial());
  }

  void selectGroupDocument(GroupDocumentParams params) {
    groupDocumentParams.icon = params.icon;
    groupDocumentParams.groupName = params.groupName;
    groupDocumentParams.groupDocumentName = params.groupDocumentName;
    groupDocumentParams.scholarshipProofDocuments =
        params.scholarshipProofDocuments;
    groupDocumentParams.acceptedDocuments = params.acceptedDocuments;
    groupDocumentParams.isEdit = params.isEdit;
    groupDocumentParams.proofId = params.proofId;
    groupDocumentParams.proof = params.proof!;
  }

  void goToRequiredAcceptedDocumentsPage() {
    Modular.to.pushNamed('required_accepted_documents').then((value) {
      //TODO(adbysantos): Ao invés de reexecutar o caso de uso, fazer alteração diretamente na store de proofs
      _refreshGroupDocuments();
    });
  }

  Future<void> _refreshGroupDocuments() {
    return getProofsStore(params.proofParams!);
  }

  void exceptionOccuredWhenGettingAcceptedDocuments() {
    setError('Não foi possível recuperar os tipos de comprovantes aceitos');
  }

  void showResendOption(ConfirmEditing confirmEditing) {
    update(confirmEditing);
  }

  void startSendingOneDocument(EditingSet editingSet) {
    update(editingSet);
  }

  void exitEditingMode() {
    if (state is Editing) {
      update((state as Editing).stateBeforeEditing);
    }
  }

  void openPhotoFromFile({required File file}) {
    Modular.to.pushNamed(
      'view_photo',
      arguments: view_photo.Controller(file: file, onTapClose: Modular.to.pop),
    );
  }
}
