import '../../../../../main/i18n/app_i18n.dart';
import 'document_group_item.dart';
import 'document_requirement_item.dart';

List<DocumentRequirementItem> documentRequirementsForGroup(
  DocumentGroupItem group,
) {
  final i18n = AppI18n.current;

  return switch (group.type) {
    DocumentGroupType.family => [
        DocumentRequirementItem(
            id: 'address-proof',
            title: i18n.documentAddressProofLabel,
            description: 'Descrição do ${i18n.documentAddressProofLabel}'),
        DocumentRequirementItem(
            id: 'phone-internet-proof',
            title: i18n.documentPhoneInternetProofLabel,
            description:
                'Descrição do ${i18n.documentPhoneInternetProofLabel}'),
        DocumentRequirementItem(
            id: 'public-transport-proof',
            title: i18n.documentPublicTransportProofLabel,
            description:
                'Descrição do ${i18n.documentPublicTransportProofLabel}'),
        DocumentRequirementItem(
            id: 'water-bill',
            title: i18n.documentWaterBillLabel,
            description: 'Descrição do ${i18n.documentWaterBillLabel}'),
        DocumentRequirementItem(
            id: 'electricity-bill',
            title: i18n.documentElectricityBillLabel,
            description: 'Descrição do ${i18n.documentElectricityBillLabel}'),
        DocumentRequirementItem(
            id: 'rented-property-declaration',
            title: i18n.documentRentedPropertyDeclarationLabel,
            description:
                'Descrição do ${i18n.documentRentedPropertyDeclarationLabel}'),
      ],
    DocumentGroupType.candidate => _candidateDocumentRequirements(i18n),
    DocumentGroupType.member => _memberDocumentRequirements(i18n),
  };
}

List<DocumentRequirementItem> _candidateDocumentRequirements(AppI18n i18n) => [
      DocumentRequirementItem(
          id: 'birth-certificate',
          title: i18n.documentBirthCertificateLabel,
          description: 'Descrição do ${i18n.documentBirthCertificateLabel}'),
      DocumentRequirementItem(
          id: 'cpf',
          title: i18n.documentCpfLabel,
          description: 'Descrição do ${i18n.documentCpfLabel}'),
      DocumentRequirementItem(
          id: 'academic-performance',
          title: i18n.documentAcademicPerformanceLabel,
          description: 'Descrição do ${i18n.documentAcademicPerformanceLabel}'),
      DocumentRequirementItem(
          id: 'civil-id',
          title: i18n.documentCivilIdLabel,
          description: 'Descrição do ${i18n.documentCivilIdLabel}'),
      DocumentRequirementItem(
          id: 'unemployed-or-homemaker',
          title: i18n.documentUnemployedOrHomemakerLabel,
          description:
              'Descrição do ${i18n.documentUnemployedOrHomemakerLabel}'),
      DocumentRequirementItem(
          id: 'no-work-card',
          title: i18n.documentNoWorkCardLabel,
          description: 'Descrição do ${i18n.documentNoWorkCardLabel}'),
    ];

List<DocumentRequirementItem> _memberDocumentRequirements(AppI18n i18n) => [
      DocumentRequirementItem(
          id: 'cpf',
          title: i18n.documentCpfLabel,
          description: 'Descrição do ${i18n.documentCpfLabel}'),
      DocumentRequirementItem(
          id: 'civil-id',
          title: i18n.documentCivilIdLabel,
          description: 'Descrição do ${i18n.documentCivilIdLabel}'),
      DocumentRequirementItem(
          id: 'birth-certificate',
          title: i18n.documentBirthCertificateLabel,
          description: 'Descrição do ${i18n.documentBirthCertificateLabel}'),
      DocumentRequirementItem(
          id: 'me-epp-proof',
          title: i18n.documentMeEppProofLabel,
          description: 'Descrição do ${i18n.documentMeEppProofLabel}'),
    ];
