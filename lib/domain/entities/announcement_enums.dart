import 'dart:ui';

import '../../ui/helpers/themes/app_colors.dart';

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
  // Em andamento
  registrationInProgress(
      100, 'Inscrição em Adamento', 'Preencha o formulário completo'),
  registrationCompleted(
      120, 'Inscrição concluída', 'Aguarde as próximas etapas'),
  sendingDocuments(
      130, 'Enviando documentos', 'Faça o upload dos documentos solicitados'),
  documentsSent(150, 'Documentos enviados', 'Aguardando análise'),
  documentsUnderReview(160, 'Documentos em análise',
      'Nossos revisores estão verificando seus documentos'),
  pendingDocuments(170, 'Documentos pendentes',
      'Reenvio necessário — veja os itens recusados'),
  approvedDocuments(
      210, 'Documentos aprovados', 'Análise socioeconômica em andamento'),
  socioeconomicAnalysisCompleted(230, 'Análise socioeconômica concluída',
      'Aguardando deliberação da comissão'),
  waitingList(240, 'Lista de espera', 'Aguardando disponibilidade de vaga'),
  underDeliberation(
      250, 'Em deliberação', 'A comissão está avaliando seu processo'),
  deliberationConcluded(260, 'Deliberação concluída', 'Resultado em breve'),

  // Desclassificações
  registrationNotCompletedWithinTheDeadline(
      110, 'Desclassificado', 'Inscrição não concluída no prazo'),
  incompleteDocumentation(140, 'Desclassificado', 'Documentação incompleta'),
  incompleteDocumentReview(
      180, 'Desclassificado', 'Revisão documental incompleta'),
  incorrectShipments(190, 'Desclassificado', 'Envios incorretos'),
  documentsDoNotMeetTheRequirements(
      200, 'Desclassificado', 'Documentos não atendem aos requisitos'),
  incompleteSupplementaryDocuments(
      220, 'Desclassificado', 'Documentos complementares incompletos'),
  declassificatedByIncorrectApplicant(
      320, 'Desclassificado', 'Candidato incorreto'),

  // Resultado
  resultApproved(
      270, 'Resultado aprovado', 'Parabéns! Veja os próximos passos'),
  resultAnnounced(280, 'Resultado comunicado', 'Verifique seu e-mail'),
  finished(290, 'Matrícula confirmada', 'Processo concluído com sucesso'),

  // Cancelados
  canceled(330, 'Cancelado', 'Inscrição cancelada');

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

  bool get isActive =>
      value >= 100 && value < 110 ||
      value == 120 ||
      value == 130 ||
      value == 150 ||
      value == 160 ||
      value == 170 ||
      value == 210 ||
      value == 230;

  bool get isDeclassified =>
      value == 110 ||
      value == 140 ||
      value == 180 ||
      value == 190 ||
      value == 200 ||
      value == 220 ||
      value == 320;

  bool get isCanceled => value == 330;

  Color get color {
    if (isDeclassified || isCanceled) return AppColors.error;
    if (value == 170) return AppColors.warning;
    return AppColors.secondary;
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
