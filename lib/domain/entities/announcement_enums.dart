enum ScholarshipType {
  both(0, 'CEBAS e PROUNI'),
  cebas(1, 'CEBAS'),
  prouni(2, 'PROUNI');

  const ScholarshipType(this.value, this.label);
  final int value;
  final String label;

  static ScholarshipType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return ScholarshipType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum AnnouncementType {
  edital(1),
  additiveTerm(2);

  const AnnouncementType(this.value);
  final int value;

  static AnnouncementType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return AnnouncementType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum EducationLevel {
  basic(0, 'Ensino Básico'),
  higher(1, 'Ensino Superior'),
  basicAndHigher(2, 'Básico e Superior');

  const EducationLevel(this.value, this.label);
  final int value;
  final String label;

  static EducationLevel fromValue(int value) {
    return EducationLevel.values.firstWhere((e) => e.value == value);
  }
}

enum ProcessType {
  renewal(1, 'Renovação'),
  newEnrollment(2, 'Novos');

  const ProcessType(this.value, this.label);
  final int value;
  final String label;

  static ProcessType? fromValue(int? value) {
    if (value == null) return null;
    try {
      return ProcessType.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum ApplicantScholarshipStatus {
  registrationInProgress(
      100, 'Inscrição em Adamento', 'Preencha o formulário completo'),
  registrationNotCompletedWithinTheDeadline(
      110, 'Desclassificado', 'Inscrição não concluída no prazo'),
  registrationCompleted(
      120, 'Inscrição concluída', 'Aguarde as próximas etapas'),
  sendingDocuments(
      130, 'Enviando documentos', 'Faça o upload dos documentos solicitados'),
  incompleteDocumentation(140, 'Desclassificado', 'Documentação incompleta'),
  documentsSent(150, 'Documentos enviados', 'Aguardando análise'),
  documentsUnderReview(160, 'Documentos em análise',
      'Nossos revisores estão verificando seus documentos'),
  pendingDocuments(170, 'Documentos pendentes',
      'Reenvio necessário — veja os itens recusados'),
  incompleteDocumentReview(
      180, 'Desclassificado', 'Revisão documental incompleta'),
  incorrectShipments(190, 'Desclassificado', 'Envios incorretos'),
  documentsDoNotMeetTheRequirements(
      200, 'Desclassificado', 'Documentos não atendem aos requisitos'),
  approvedDocuments(
      210, 'Documentos aprovados', 'Análise socioeconômica em andamento'),
  incompleteSupplementaryDocuments(
      220, 'Desclassificado', 'Documentos complementares incompletos'),
  socioeconomicAnalysisCompleted(230, 'Análise socioeconômica concluída',
      'Aguardando deliberação da comissão'),
  waitingList(240, 'Lista de espera', 'Aguardando disponibilidade de vaga'),
  underDeliberation(
      250, 'Em deliberação', 'A comissão está avaliando seu processo'),
  deliberationConcluded(260, 'Deliberação concluída', 'Resultado em breve'),
  resultApproved(
      270, 'Resultado aprovado', 'Parabéns! Veja os próximos passos'),
  resultAnnounced(280, 'Resultado comunicado', 'Verifique seu e-mail'),
  finished(290, 'Matrícula confirmada', 'Processo concluído com sucesso');

  final String label;
  final String sublabel;
  final int value;
  const ApplicantScholarshipStatus(this.value, this.label, this.sublabel);

  static ApplicantScholarshipStatus? fromValue(int? value) {
    if (value == null) return null;
    try {
      return ApplicantScholarshipStatus.values
          .firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}

enum ScholarshipStatus {
  notFinished(0, 'Iniciado'),
  applied(1, 'Inscrição'),
  documentation(2, 'Documentação'),
  reviewed(3, 'Conferência'),
  analysis(4, 'Em Análise'),
  closed(5, 'Concluído');

  final int value;
  final String label;
  const ScholarshipStatus(this.value, this.label);

  static ScholarshipStatus? fromValue(int? value) {
    if (value == null) return null;
    try {
      return ScholarshipStatus.values.firstWhere((e) => e.value == value);
    } catch (_) {
      return null;
    }
  }
}
