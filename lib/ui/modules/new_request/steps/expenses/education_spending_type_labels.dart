import '../../../../../domain/entities/enrollment_enums.dart';
import '../../../../../main/i18n/app_i18n.dart';

String? educationSpendingTypeLabel(EducationSpendingType? type) {
  final i18n = AppI18n.current;
  switch (type) {
    case EducationSpendingType.basic:
      return i18n.expenseEducationTypeBasic;
    case EducationSpendingType.higher:
      return i18n.expenseEducationTypeHigher;
    case EducationSpendingType.courses:
      return i18n.expenseEducationTypeCourses;
    case EducationSpendingType.other:
      return i18n.expenseEducationTypeOther;
    case EducationSpendingType.tutoring:
      return i18n.expenseEducationTypeTutoring;
    case EducationSpendingType.sports:
      return i18n.expenseEducationTypeSports;
    case EducationSpendingType.arts:
      return i18n.expenseEducationTypeArts;
    case EducationSpendingType.afterSchool:
      return i18n.expenseEducationTypeAfterSchool;
    case EducationSpendingType.caregiving:
      return i18n.expenseEducationTypeCaregiving;
    case null:
      return null;
  }
}

EducationSpendingType? educationSpendingTypeFromLabel(String? label) {
  if (label == null) return null;
  for (final type in EducationSpendingType.values) {
    if (educationSpendingTypeLabel(type) == label) return type;
  }
  return null;
}

List<String> selectableEducationSpendingTypeLabels({String? currentLabel}) {
  final labels = EducationSpendingType.values
      .where((type) => type.selectable)
      .map((type) => educationSpendingTypeLabel(type)!)
      .toList();
  if (currentLabel != null &&
      currentLabel == educationSpendingTypeLabel(EducationSpendingType.other) &&
      !labels.contains(currentLabel)) {
    labels.add(currentLabel);
  }
  return labels;
}
