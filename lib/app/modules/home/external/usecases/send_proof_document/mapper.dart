import '../../../domain/usecases/send_proof_document/entity.dart';

class Mapper {
  Entity fromListToEntity(dynamic data) {
    //*(adbysantos): Formato de resposta mudou na tentativa de edição; Era string e agora é um map vazio (14/07/2022).
    return const Entity(sentFile: '');
  }

  const Mapper();
}
