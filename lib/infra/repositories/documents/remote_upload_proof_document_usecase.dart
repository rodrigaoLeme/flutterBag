import 'dart:io';

import '../../../data/http/http_client.dart';
import '../../../domain/entities/proof_attachment_entity.dart';
import '../../../domain/usecases/documents/upload_proof_document_usecase.dart';
import '../../../main/flavors.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../files/proof_pdf_builder.dart';

class RemoteUploadProofDocumentUsecase implements UploadProofDocumentUsecase {
  final HttpClient httpClient;

  const RemoteUploadProofDocumentUsecase({required this.httpClient});

  @override
  Future<UploadProofDocumentResult> upload(
    UploadProofDocumentParams params, {
    void Function(int sent, int total)? onProgress,
  }) async {
    File? generatedPdf;
    try {
      final files = <MultipartFileData>[];
      final passwords = <String>[]; // mesma ordem de files

      final images = params.attachments.images;
      if (images.isNotEmpty) {
        try {
          generatedPdf =
              await buildPdfFromImages(images.map((i) => i.path).toList());
        } catch (_) {
          throw const UploadProofDocumentException(
            'Não foi possível converter as imagens em PDF. Tente outras fotos.',
          );
        }
        files.add(MultipartFileData(
          field: 'files',
          path: generatedPdf.path,
          filename: 'imagens.pdf',
        ));
        passwords.add('');
      }

      for (final pdf in params.attachments.pdfs) {
        files.add(MultipartFileData(
          field: 'files',
          path: pdf.path,
          filename: _pdfName(pdf.name),
        ));
        passwords.add(pdf.password ?? '');
      }

      await _validateBeforeSend(files);

      final payload = MultipartPayload(
        fields: [
          MapEntry('documentId', params.documentId),
          MapEntry('acceptTerm', params.acceptTerm.toString()),
          if (params.reviewId != null) MapEntry('reviewId', params.reviewId!),
          if (params.senderObservation?.isNotEmpty ?? false)
            MapEntry('senderObservation', params.senderObservation!),
          for (final p in passwords) MapEntry('pdfPasswords', p),
        ],
        files: files,
      );

      final response = await httpClient.upload(
        url: '${Flavor.apiBaseUrl}/v1/scholarships/${params.scholarshipId}'
            '/scholarship-proof-documents/${params.proofDocumentId}/file',
        method: HttpMethod.put,
        payload: payload,
        onSendProgress: onProgress,
      );

      return UploadProofDocumentResult(
        archived: response.headers['x-initial-proof-upload-archived'] == 'true',
      );
    } on UploadProofDocumentException {
      rethrow;
    } on ApiException catch (e) {
      throw _fromApi(e);
    } on HttpError catch (e) {
      switch (e) {
        case HttpError.noConnectivity:
          throw UploadProofDocumentException(AppI18n.current.errorNoInternet);
        case HttpError.timeout:
          throw const UploadProofDocumentException(
            'O envio demorou mais que o esperado. Verifique a conexão e tente novamente.',
          );
        default:
          throw UploadProofDocumentException(AppI18n.current.errorUnexpected);
      }
    } catch (_) {
      throw UploadProofDocumentException(AppI18n.current.errorUnexpected);
    } finally {
      try {
        await generatedPdf?.delete();
      } catch (_) {}
    }
  }

  String _pdfName(String name) =>
      name.toLowerCase().endsWith('.pdf') ? name : '$name.pdf';

  Future<void> _validateBeforeSend(List<MultipartFileData> files) async {
    if (files.isEmpty) {
      throw const UploadProofDocumentException(
          'Selecione ao menos um arquivo.');
    }
    if (files.length > ProofAttachments.maxFiles) {
      throw const UploadProofDocumentException(
        'Limite de 6 arquivos por envio.',
      );
    }
    var total = 0;
    for (final f in files) {
      final size = await File(f.path).length();
      if (size == 0) {
        throw const UploadProofDocumentException(
          'Um dos arquivos está vazio ou corrompido.',
        );
      }
      if (size > ProofAttachments.maxBytes) {
        throw const UploadProofDocumentException(
          'Cada arquivo pode ter no máximo 15 MB.',
        );
      }
      total += size;
    }
    if (total > ProofAttachments.maxBytes) {
      throw const UploadProofDocumentException(
        'O total dos arquivos não pode passar de 15 MB (após converter as imagens em PDF).',
      );
    }
  }

  UploadProofDocumentException _fromApi(ApiException e) {
    switch (e.code) {
      case 'ScholarshipProofDocument.PasswordRequired':
        return const UploadProofDocumentException(
          'Um dos PDFs está protegido por senha. Informe a senha para enviar.',
          failure: UploadProofFailure.passwordRequired,
        );
      case 'ScholarshipProofDocument.InvalidPassword':
        return const UploadProofDocumentException(
          'Senha incorreta. Confira e tente novamente.',
          failure: UploadProofFailure.invalidPassword,
        );
      case 'ScholarshipProofDocument.FileSizeExceeded':
        return const UploadProofDocumentException(
          'Um dos arquivos passa de 15 MB.',
        );
      case 'ScholarshipProofDocument.FinalFileSizeExceeded':
        return const UploadProofDocumentException(
          'O PDF final passa de 15 MB. Remova arquivos ou use imagens menores.',
        );
      case 'ScholarshipProofDocument.MaxFilesExceeded':
        return const UploadProofDocumentException(
          'Limite de 6 arquivos por envio.',
        );
      case 'ScholarshipProofDocument.InvalidFormat':
        return const UploadProofDocumentException(
          'Só são aceitos arquivos PDF.',
        );
      case 'ScholarshipProofDocument.CorruptedFile':
      case 'ScholarshipProofDocument.FileMissing':
        return const UploadProofDocumentException(
          'Arquivo vazio, corrompido ou não enviado.',
        );
      case 'Scholarship.Declassified':
        return const UploadProofDocumentException(
          'Inscrição desclassificada. Não é possível enviar documentos.',
        );
      default:
        return UploadProofDocumentException(
          e.fullMessage.isNotEmpty
              ? e.fullMessage
              : AppI18n.current.errorUnexpected,
        );
    }
  }
}
