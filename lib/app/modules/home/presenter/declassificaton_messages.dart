class DeclassificatonMessages {
  static DeclassificatonMessages shared = DeclassificatonMessages._();
  DeclassificatonMessages._();

  String checkDeclassificationType(int type, String text) {
    String declassificationTypeString;
    switch (type) {
      case 1:
        declassificationTypeString =
            'Seu processo seletivo de bolsa foi desclassificado por não finalizar inscrição no prazo';
        break;
      case 2:
        declassificationTypeString =
            'Seu processo seletivo de bolsa foi desclassificado por não envio de documentação no prazo';
        break;
      case 3:
        declassificationTypeString =
            'Seu processo seletivo de bolsa foi desclassificado por não enviar pendências de documentação no prazo';
        break;
      case 4:
        declassificationTypeString =
            'Seu processo seletivo de bolsa foi desclassificado por não envio de documentos pendentes ou complementares solicitados por assistente social no prazo';
        break;
      case 5:
        declassificationTypeString =
            'Seu processo seletivo de bolsa foi desclassificado por documentos não atenderem requisitos';
        break;
      case 6:
        declassificationTypeString =
            'Seu processo seletivo de bolsa foi desclassificado por envio recorrente de documentos incorretos';
        break;
      default:
        declassificationTypeString = text;
        break;
    }
    return declassificationTypeString;
  }
}
