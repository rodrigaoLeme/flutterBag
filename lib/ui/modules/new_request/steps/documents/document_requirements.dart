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
        ),
        DocumentRequirementItem(
          id: 'phone-internet-proof',
          title: i18n.documentPhoneInternetProofLabel,
        ),
        DocumentRequirementItem(
          id: 'public-transport-proof',
          title: i18n.documentPublicTransportProofLabel,
        ),
        DocumentRequirementItem(
          id: 'water-bill',
          title: i18n.documentWaterBillLabel,
        ),
        DocumentRequirementItem(
          id: 'electricity-bill',
          title: i18n.documentElectricityBillLabel,
        ),
        DocumentRequirementItem(
          id: 'rented-property-declaration',
          title: i18n.documentRentedPropertyDeclarationLabel,
        ),
      ],
    DocumentGroupType.candidate => List.generate(
        group.totalDocuments,
        (index) => DocumentRequirementItem(
          id: '${group.id}-doc-$index',
          title: '${i18n.documentsTitle} ${index + 1}',
        ),
      ),
    DocumentGroupType.member => List.generate(
        group.totalDocuments,
        (index) => DocumentRequirementItem(
          id: '${group.id}-doc-$index',
          title: '${i18n.documentsTitle} ${index + 1}',
        ),
      ),
  };
}
