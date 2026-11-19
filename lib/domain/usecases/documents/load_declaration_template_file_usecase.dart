import '../../entities/declaration_template_file_entity.dart';

abstract class LoadDeclarationTemplateFileUsecase {
  Future<DeclarationTemplateFileEntity> load({
    required String scholarshipId,
    required String declarationTemplateId,
  });
}

class LoadDeclarationTemplateFileException implements Exception {
  final String message;
  const LoadDeclarationTemplateFileException(this.message);
}
