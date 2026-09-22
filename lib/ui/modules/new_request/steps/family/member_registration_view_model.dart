import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../domain/entities/enrollment_enums.dart';
import '../../../../../domain/entities/extra_income_entity.dart';
import '../../../../../domain/entities/extra_income_type_entity.dart';
import '../../../../../domain/entities/family_member_entity.dart';
import '../../../../../domain/entities/group_income_entity.dart';
import '../../../../../domain/entities/nationalities_entity.dart';
import '../../../../../domain/entities/occupation_entity.dart';
import '../../../../../domain/entities/occupation_type_entity.dart';
import '../../../../../domain/entities/person_entity.dart';
import '../../../../../domain/entities/special_needs_entity.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/money_formatter.dart';

class MemberRegistrationViewModel extends ChangeNotifier {
  static const double minimumWage = 1518.0;
  static const _brazilianNationalityId = 'c88ac7a5-2de6-4b2e-a9b2-dc4d3f654dfa';
  static const _nenhunmaSpecialNeedsId = '8bb77161-9f1b-46eb-b92a-cef26b02f804';

  final TextEditingController cpfController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nacionalityController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController orgaoController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController tipoDoencaController = TextEditingController();
  final TextEditingController pensionValueController = TextEditingController();
  final TextEditingController previdenciaValueController =
      TextEditingController();
  final TextEditingController beneficioValueController =
      TextEditingController();
  final TextEditingController imovelAlugadoValueController =
      TextEditingController();
  final TextEditingController ajudaFamiliarValueController =
      TextEditingController();
  final TextEditingController ajudaOutroDeQuemController =
      TextEditingController();
  final TextEditingController ajudaOutroValueController =
      TextEditingController();
  final TextEditingController programaGovernoController =
      TextEditingController();
  final TextEditingController programaGovernoValueController =
      TextEditingController();

  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {'#': RegExp(r'\d')},
  );

  final List<Gender> genderOptions = Gender.values;
  final List<String> responsibleOptions = ['Pai', 'Mãe', 'Outro'];
  List<String> get pcdOptions => _specialNeedsOptions
      .map((e) => e.name ?? '')
      .where((n) => n.isNotEmpty)
      .toList();
  List<String> get nationalityOptions => _nationalityOptions
      .map((e) => e.name ?? '')
      .where((n) => n.isNotEmpty)
      .toList();

  final List<Map<String, dynamic>> addedOccupations = [];
  final List<Map<String, dynamic>> addedOtherIncomes = [];
  final List<Map<String, dynamic>> addedFamilyMembers = [];
  final List<Map<String, dynamic>> addedProperties = [];
  final List<Map<String, dynamic>> addedInvestments = [];
  final List<Map<String, dynamic>> addedVehicles = [];
  final List<FamilyMemberEntity> familyMemberEntities = [];

  bool isLoadingPerson = false;
  bool isHigherEducation;

  List<SpecialNeedsEntity> _specialNeedsOptions = [];
  List<NationalitiesEntity> _nationalityOptions = [];
  List<OccupationTypeEntity> _occupationTypes = [];
  List<ExtraIncomeTypeEntity> _extraIncomeTypes = [];

  String? _currentMemberId;
  int? _editingIndex;

  String? cpfError;
  String? selectedGender;
  MaritalStatus? maritalStatus;
  String? selectedResponsible;
  String? selectedPcd;
  int? cadunicoValue;
  int? recebePensao;
  int? aposentado;
  int? seraCandidato;
  int? naturalizado;
  int? possuiCIN;
  int? possuiDoenca;
  int? irpfCondition;
  int? declarouEsseAno;
  int? temCarteira;
  int? trabalhadorRural;
  int? superdotacao;
  int? espectro;
  String? _pendingSpecialNeedsId;
  String? _pendingNationalityId;

  int? recebePensaoAlimenticia;
  int? recebePrevidenciaPrivada;
  int? recebeOutroBeneficioINSS;
  bool hasOccupation = false;
  bool showPensionValueField = false;
  bool showPrevidenciaValueField = false;
  bool showInssValueField = false;
  bool pensionIncomeAcknowledged = false;
  bool inssBenefitAcknowledged = false;

  bool _hasPendingOccupationNames = false;

  int? possuiOutraFonteRenda;
  int? recebeValorImovelAlugado;
  int? ajudaFinanceira;
  int? beneficiarioProgramaGoverno;
  int? possuiImovelProprio;
  int? possuiInvestimentoFinanceiro;
  int? possuiVeiculo;

  KinshipType? kinshipType;
  String _previousDob = '';

  bool get isEditing => _editingIndex != null;

  int get age {
    try {
      final dob = DateFormat('dd/MM/yyyy').parse(dobController.text.trim());
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month ||
          (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    } catch (_) {
      return 0; // data inválida ou vazia → sem filtro de idade
    }
  }

  MemberRegistrationViewModel({this.isHigherEducation = false}) {
    for (final controller in _trackedControllers) {
      controller.addListener(notifyListeners);
    }
  }

  List<TextEditingController> get _trackedControllers => [
        cpfController,
        nameController,
        dobController,
        nacionalityController,
        rgController,
        orgaoController,
        nisController,
        tipoDoencaController,
        pensionValueController,
        previdenciaValueController,
        beneficioValueController,
        imovelAlugadoValueController,
        ajudaFamiliarValueController,
        ajudaOutroDeQuemController,
        ajudaOutroValueController,
        programaGovernoController,
        programaGovernoValueController,
      ];

  bool showCandidateField(
      {required bool isFirstMember, required bool isHigherEducation}) {
    if (isHigherEducation) return true;
    return !isFirstMember;
  }

  bool isCpfAlreadyAdded(String cpf) {
    final clean = cpf.replaceAll(RegExp(r'\D'), '');
    return familyMemberEntities.any(
      (m) => m.personCpf?.replaceAll(RegExp(r'\D'), '') == clean,
    );
  }

  bool get showReceivesPension => maritalStatus == MaritalStatus.widower;
  bool get showIsRetired => recebePensao == 1;
  bool get showCINFields => possuiCIN == 0;
  bool get showNisField => cadunicoValue == 1;
  bool get showDiseaseType => possuiDoenca == 1;
  bool get showNaturalizedField =>
      selectedNationalityId != null &&
      selectedNationalityId != _brazilianNationalityId;

  String get memberFirstName {
    final name = nameController.text.trim();
    if (name.isEmpty) return 'O membro';
    return name.split(RegExp(r'\s+')).first;
  }

  bool get isFirstMember => addedFamilyMembers.isEmpty;

  bool get isCpfValidated =>
      cpfError == null &&
      cpfController.text.replaceAll(RegExp(r'\D'), '').length == 11;

  String? get selectedPcdId {
    if (selectedPcd == null || selectedPcd == 'Nenhuma') return null;
    try {
      return _specialNeedsOptions.firstWhere((e) => e.name == selectedPcd).id;
    } catch (_) {
      return null;
    }
  }

  bool get legalAge => age >= 18;

  bool get hasPwd =>
      selectedPcdId != null && selectedPcdId != _nenhunmaSpecialNeedsId;

  bool get hasIncompatibleOccupations => incompatibleOccupations.isNotEmpty;

  Gender? get selectedGenderEnum =>
      Gender.values.firstWhereOrNull((g) => g.label == selectedGender);

  String? get selectedNationalityId {
    if (nacionalityController.text.isEmpty) return null;
    try {
      return _nationalityOptions
          .firstWhere((e) => e.name == nacionalityController.text)
          .id;
    } catch (_) {
      return null;
    }
  }

  List<KinshipType> get kinshipOptions =>
      KinshipType.values.where((k) => k.value != 1).toList();

  List<Map<String, dynamic>> get incompatibleOccupations {
    return addedOccupations.where((o) {
      final typeId = o['occupationTypeId'] as String?;
      if (typeId == null) return false;
      final type = _occupationTypes.firstWhereOrNull((t) => t.id == typeId);
      if (type == null) return false;
      return !type.isCompatibleWith(age: age, hasPwd: hasPwd);
    }).toList();
  }

  List<OccupationTypeEntity> get compatibleOccupationTypes {
    return _occupationTypes
        .where((t) => t.isCompatibleWith(age: age, hasPwd: hasPwd))
        .toList();
  }

  void setCpfError(String? error) {
    cpfError = error;
    notifyListeners();
  }

  void setCurrentMemberId(String id) {
    _currentMemberId = id;
  }

  void updateOccupationTypes(List<OccupationTypeEntity> types) {
    _occupationTypes = types;
    _applyPendingOccupationNames();
    notifyListeners();
  }

  void updateExtraIncomeTypes(List<ExtraIncomeTypeEntity> types) {
    _extraIncomeTypes = types;
    notifyListeners();
  }

  void saveDobSnapshot() {
    _previousDob = dobController.text;
  }

  void restoreDob() {
    dobController.text = _previousDob;
    notifyListeners();
  }

  void removeIncompatibleOccupations() {
    addedOccupations.removeWhere((o) {
      final typeId = o['occupationTypeId'] as String?;
      if (typeId == null) return false;
      final type = _occupationTypes.firstWhereOrNull((t) => t.id == typeId);
      if (type == null) return false;
      return !type.isCompatibleWith(age: age, hasPwd: hasPwd);
    });
    notifyListeners();
  }

  void populateFromPerson(PersonEntity person) {
    nameController.text = person.name ?? '';
    if (person.birthDate != null) {
      dobController.text = DateFormat('dd/MM/yyyy').format(person.birthDate!);
    }
    if (person.gender != null) {
      selectedGender = _genderLabel(person.gender!);
    }
    if (person.maritalStatus != null) {
      maritalStatus = _maritalStatusFromInt(person.maritalStatus!);
    }
    if (person.rg != null) {
      rgController.text = person.rg!;
    }
    if (person.rgIssuingAuthority != null) {
      orgaoController.text = person.rgIssuingAuthority!;
    }
    if (person.hasCin != null) {
      possuiCIN = person.hasCin! ? 1 : 0;
    }
    notifyListeners();
  }

  void startEditing(int index) {
    _editingIndex = index;
    final entity = familyMemberEntities[index];
    _currentMemberId = entity.id;

    // Dados pessoais
    cpfController.text = _formatCpf(entity.personCpf ?? '');
    nameController.text = entity.name ?? '';
    if (entity.personBirthDate != null) {
      dobController.text =
          DateFormat('dd/MM/yyyy').format(entity.personBirthDate!);
    }
    selectedGender = _genderLabel(entity.personGender!);
    maritalStatus = MaritalStatus.fromValue(entity.maritalStatus);
    kinshipType = KinshipType.fromValue(entity.kinshipType);
    seraCandidato = entity.isCandidate == true ? 1 : 0;
    naturalizado = entity.naturalized == true ? 1 : 0;
    possuiCIN = entity.personHasCin == true ? 1 : 0;
    rgController.text = entity.personRg ?? '';
    orgaoController.text = entity.personRgIssuingAuthority ?? '';

    // Saúde
    possuiDoenca = entity.hasChronicDisease == true ? 1 : 0;
    tipoDoencaController.text = entity.chronicDiseaseName ?? '';
    superdotacao = entity.hasHighAbilityGiftedness == true ? 1 : 0;
    espectro = entity.hasAutismSpectrumDisorder == true ? 1 : 0;

    // PcD — busca pelo id
    _pendingSpecialNeedsId = entity.specialNeedsId;
    _applyPendingSpecialNeeds();

    // CadÚnico
    cadunicoValue = entity.hasCadUnico == true ? 1 : 0;
    nisController.text = entity.governmentBeneficiaryNis ?? '';

    // Benefícios
    recebePensaoAlimenticia = entity.hasAlimony == true ? 1 : 0;
    if (entity.alimonyAmount != null) {
      pensionValueController.text = MoneyFormatter.format(entity.alimonyAmount);
    }
    recebeOutroBeneficioINSS = entity.hasInssAssistance == true ? 1 : 0;
    if (entity.inssAssistanceAmount != null) {
      beneficioValueController.text =
          MoneyFormatter.format(entity.inssAssistanceAmount);
    }
    recebePrevidenciaPrivada = entity.hasPrivatePension == true ? 1 : 0;
    if (entity.privatePensionAmount != null) {
      previdenciaValueController.text =
          MoneyFormatter.format(entity.privatePensionAmount);
    }
    recebePensao = entity.receivePension == true ? 1 : 0;
    aposentado = entity.isRetired == true ? 1 : 0;
    temCarteira = entity.hasWorkBooklet == true ? 1 : 0;
    trabalhadorRural = entity.ruralWorker == true ? 1 : 0;
    irpfCondition = entity.declarationType;
    declarouEsseAno = entity.declared == true ? 1 : 0;

    // Nacionalidade
    _pendingNationalityId = entity.nationalityId;
    _applyPendingNationality();

    // Ocupações
    addedOccupations.clear();
    for (final o in entity.occupations) {
      final typeName = _occupationTypes
              .firstWhereOrNull((t) => t.id == o.occupationTypeId)
              ?.name ??
          '';

      final details = <String, dynamic>{};
      if (o.companyName?.isNotEmpty == true) details['Empresa'] = o.companyName;
      if (o.function?.isNotEmpty == true) {
        details['Função'] = o.function;
        details['Função/Atuação'] = o.function;
      }
      if (o.cnpj?.isNotEmpty == true) details['CNPJ'] = o.cnpj;
      if (o.companyType != null) details['companyType'] = o.companyType;
      if (o.situation != null) details['Situação'] = o.situation?.toString();
      if (o.hadActivityLastYear != null) {
        details['Houve movimentacao?'] =
            o.hadActivityLastYear == true ? 'Sim' : 'Não';
      }
      if (o.simplesNacionalTax != null) {
        details['Optante Simples nacional?'] =
            o.simplesNacionalTax == true ? 'Sim' : 'Não';
      }
      if (o.unemploymentInsurance != null) {
        details['Recebe seguro desemprego?'] =
            o.unemploymentInsurance == true ? 'Sim' : 'Não';
      }

      addedOccupations.add({
        'id': o.id,
        'occupationTypeId': o.occupationTypeId,
        'occupation': typeName,
        'headerTitle': MoneyFormatter.format(o.monthlyIncome ?? 0),
        'monthlyIncome': o.monthlyIncome?.toString() ?? '0',
        'occupationDetails': details,
        'pension': recebePensaoAlimenticia ?? 0,
        'previdencia': recebePrevidenciaPrivada ?? 0,
        'inss': recebeOutroBeneficioINSS ?? 0,
      });
    }

    // Outras rendas
    addedOtherIncomes.clear();
    possuiOutraFonteRenda = entity.extraIncomes.isEmpty ? 0 : 1;
    for (final e in entity.extraIncomes) {
      final typeName = _extraIncomeTypes
              .firstWhereOrNull((t) => t.id == e.extraIncomeTypeId)
              ?.name ??
          '';
      addedOtherIncomes.add({
        'id': e.id,
        'type': typeName,
        'extraIncomeTypeId': e.extraIncomeTypeId,
        'monthlyIncome': MoneyFormatter.format(e.amount ?? 0),
        'description': e.description,
      });
    }

    notifyListeners();
  }

  void _applyPendingSpecialNeeds() {
    if (_pendingSpecialNeedsId == null) return;
    final found = _specialNeedsOptions
        .firstWhereOrNull((s) => s.id == _pendingSpecialNeedsId);
    if (found != null) {
      selectedPcd = found.name;
      _pendingSpecialNeedsId = null;
      notifyListeners();
    }
  }

  void _applyPendingNationality() {
    if (_pendingNationalityId == null) return;
    final found = _nationalityOptions
        .firstWhereOrNull((n) => n.id == _pendingNationalityId);
    if (found != null) {
      nacionalityController.text = found.name ?? '';
      _pendingNationalityId = null;
      notifyListeners();
    }
  }

  void _applyPendingOccupationNames() {
    if (!_hasPendingOccupationNames) return;
    for (final o in addedOccupations) {
      if ((o['occupation'] as String?)?.isEmpty == true) {
        final typeId =
            (o['ocupationTypeId'] ?? o['occupationTypeId']) as String?;
        final typeName =
            _occupationTypes.firstWhereOrNull((t) => t.id == typeId)?.name ??
                '';
        o['occupation'] = typeName;
      }
    }
    _hasPendingOccupationNames = false;
    notifyListeners();
  }

  String _formatCpf(String cpf) {
    final clean = cpf.replaceAll(RegExp(r'\D'), '');
    if (clean.length != 11) return cpf;
    return '${clean.substring(0, 3)}.${clean.substring(3, 6)}.${clean.substring(6, 9)}-${clean.substring(9)}';
  }

  String _genderLabel(int gender) {
    switch (gender) {
      case 1:
        return 'Feminino';
      case 2:
        return 'Masculino';
      default:
        return 'Feminino';
    }
  }

  MaritalStatus? _maritalStatusFromInt(int value) {
    return MaritalStatus.fromValue(value);
  }

  List<MaritalStatus> get maritalOptions => MaritalStatus.values;
  String maritalDisplay(MaritalStatus m) => m.label;

  void setMarital(MaritalStatus? m) {
    maritalStatus = m;
    if (m != MaritalStatus.widower) recebePensao = null;
    notifyListeners();
  }

  void setRecebePensao(int? v) {
    recebePensao = v;
    if (v != 1) aposentado = null;
    notifyListeners();
  }

  void setAposentado(int? v) {
    aposentado = v;
    notifyListeners();
  }

  void setSeraCandidato(int? v) {
    seraCandidato = v;
    notifyListeners();
  }

  void setNaturalizado(int? v) {
    naturalizado = v;
    notifyListeners();
  }

  void setSelectedGender(String? v) {
    selectedGender = v;
    notifyListeners();
  }

  void setKinshipType(KinshipType? k) {
    kinshipType = k;
    notifyListeners();
  }

  void setSelectedGenderEnum(Gender? g) {
    selectedGender = g?.label;
    notifyListeners();
  }

  void setSelectedResponsible(String? v) {
    selectedResponsible = v;
    notifyListeners();
  }

  void setSelectedPcd(String? v) {
    selectedPcd = v;
    notifyListeners();
  }

  void updatePcdOptions(List<SpecialNeedsEntity> options) {
    _specialNeedsOptions = options;
    _applyPendingSpecialNeeds();
    notifyListeners();
  }

  void setNationality(String value) {
    nacionalityController.text = value;
    notifyListeners();
  }

  void updateNationalityOptions(List<NationalitiesEntity> options) {
    _nationalityOptions = options;
    _applyPendingNationality();
    notifyListeners();
  }

  void setPossuiCIN(int? v) {
    possuiCIN = v;
    notifyListeners();
  }

  void setCadunicoValue(int? v) {
    cadunicoValue = v;
    notifyListeners();
  }

  void setEspectro(int? v) {
    espectro = v;
    notifyListeners();
  }

  void setSuperdotacao(int? v) {
    superdotacao = v;
    notifyListeners();
  }

  void setPossuiDoenca(int? v) {
    possuiDoenca = v;
    notifyListeners();
  }

  void setIrpfCondition(int? v) {
    irpfCondition = v;
    notifyListeners();
  }

  void setDeclarouEsseAno(int? v) {
    declarouEsseAno = v;
    notifyListeners();
  }

  void setTemCarteira(int? v) {
    temCarteira = v;
    notifyListeners();
  }

  void setTrabalhadorRural(int? v) {
    trabalhadorRural = v;
    notifyListeners();
  }

  void setDob(DateTime date) {
    dobController.text = DateFormat('dd/MM/yyyy').format(date);
    notifyListeners();
  }

  void setRecebePensaoAlimenticia(int value, {bool acknowledged = false}) {
    recebePensaoAlimenticia = value;
    if (value != 1) {
      pensionValueController.clear();
      pensionIncomeAcknowledged = false;
      showPensionValueField = false;
    } else if (acknowledged) {
      pensionIncomeAcknowledged = true;
      showPensionValueField = true;
    } else {
      pensionIncomeAcknowledged = false;
      showPensionValueField = false;
    }
    notifyListeners();
  }

  void acknowledgePensionIncome() {
    if (recebePensaoAlimenticia == 1) {
      pensionIncomeAcknowledged = true;
      showPensionValueField = true;
      notifyListeners();
    }
  }

  void resetRecebePensaoAlimenticia() {
    recebePensaoAlimenticia = null;
    pensionValueController.clear();
    pensionIncomeAcknowledged = false;
    showPensionValueField = false;
    notifyListeners();
  }

  void setRecebePrevidenciaPrivada(int value) {
    recebePrevidenciaPrivada = value;
    showPrevidenciaValueField = value == 1;
    if (value != 1) previdenciaValueController.clear();
    notifyListeners();
  }

  void setRecebeOutroBeneficioINss(int value, {bool acknowledged = false}) {
    recebeOutroBeneficioINSS = value;
    if (value != 1) {
      beneficioValueController.clear();
      inssBenefitAcknowledged = false;
      showInssValueField = false;
    } else if (acknowledged) {
      inssBenefitAcknowledged = true;
      showInssValueField = true;
    } else {
      inssBenefitAcknowledged = false;
      showInssValueField = false;
    }
    notifyListeners();
  }

  void acknowledgeInssBenefit() {
    if (recebeOutroBeneficioINSS == 1) {
      inssBenefitAcknowledged = true;
      showInssValueField = true;
      notifyListeners();
    }
  }

  void resetRecebeOutroBeneficioINss() {
    recebeOutroBeneficioINSS = null;
    beneficioValueController.clear();
    inssBenefitAcknowledged = false;
    showInssValueField = false;
    notifyListeners();
  }

  void setPossuiOutraFonteRenda(int value) {
    possuiOutraFonteRenda = value;
    if (value != 1) addedOtherIncomes.clear();
    notifyListeners();
  }

  void clearOtherIncomeSelection() {
    possuiOutraFonteRenda = null;
    addedOtherIncomes.clear();
    notifyListeners();
  }

  void addOtherIncome(Map<dynamic, dynamic> result) {
    addedOtherIncomes.add(Map<String, dynamic>.from(result));
    possuiOutraFonteRenda = 1;
    notifyListeners();
  }

  void updateOtherIncomeAt(int index, Map<dynamic, dynamic> result) {
    if (index < 0 || index >= addedOtherIncomes.length) return;
    addedOtherIncomes[index] = Map<String, dynamic>.from(result);
    notifyListeners();
  }

  void removeOtherIncomeAt(int index) {
    if (index < 0 || index >= addedOtherIncomes.length) return;
    addedOtherIncomes.removeAt(index);
    notifyListeners();
  }

  void setRecebeValorImovelAlugado(int value) {
    recebeValorImovelAlugado = value;
    if (value != 1) imovelAlugadoValueController.clear();
    notifyListeners();
  }

  void setAjudaFinanceira(int value) {
    ajudaFinanceira = value;
    if (value != 1) ajudaFamiliarValueController.clear();
    if (value != 2) {
      ajudaOutroDeQuemController.clear();
      ajudaOutroValueController.clear();
    }
    notifyListeners();
  }

  void setBeneficiarioProgramaGoverno(int value) {
    beneficiarioProgramaGoverno = value;
    if (value != 1) {
      programaGovernoController.clear();
      programaGovernoValueController.clear();
    }
    notifyListeners();
  }

  void setPossuiImovelProprio(int value) {
    possuiImovelProprio = value;
    if (value != 1) addedProperties.clear();
    notifyListeners();
  }

  void setPossuiInvestimentoFinanceiro(int value) {
    possuiInvestimentoFinanceiro = value;
    if (value != 1) addedInvestments.clear();
    notifyListeners();
  }

  void setPossuiVeiculo(int value) {
    possuiVeiculo = value;
    if (value != 1) addedVehicles.clear();
    notifyListeners();
  }

  void applyOccupationResult(Map<dynamic, dynamic> result) {
    final p = result['pension'];
    if (p is int) {
      setRecebePensaoAlimenticia(
        p,
        acknowledged: p == 1 && pensionIncomeAcknowledged,
      );
    } else if (p is String) {
      final parsed = int.tryParse(p);
      if (parsed != null) {
        setRecebePensaoAlimenticia(
          parsed,
          acknowledged: parsed == 1 && pensionIncomeAcknowledged,
        );
      }
    }

    final previd = result['previdencia'];
    if (previd is int) {
      setRecebePrevidenciaPrivada(previd);
    } else if (previd is String) {
      final parsed = int.tryParse(previd);
      if (parsed != null) setRecebePrevidenciaPrivada(parsed);
    }

    final inss = result['inss'];
    if (inss is int) {
      setRecebeOutroBeneficioINss(
        inss,
        acknowledged: inss == 1 && inssBenefitAcknowledged,
      );
    } else if (inss is String) {
      final parsed = int.tryParse(inss);
      if (parsed != null) {
        setRecebeOutroBeneficioINss(
          parsed,
          acknowledged: parsed == 1 && inssBenefitAcknowledged,
        );
      }
    }

    final occupation = result['occupation'];
    if (occupation is String) {
      if (occupation != 'Nenhum') {
        addedOccupations.add(Map<String, dynamic>.from(result));
      }
      hasOccupation = addedOccupations.isNotEmpty;
      notifyListeners();
    }
  }

  void updateOccupationAt(int index, Map<dynamic, dynamic> result) {
    addedOccupations[index] = Map<String, dynamic>.from(result);
    hasOccupation = addedOccupations.isNotEmpty;
    notifyListeners();
  }

  void removeOccupationAt(int index) {
    addedOccupations.removeAt(index);
    hasOccupation = addedOccupations.isNotEmpty;
    notifyListeners();
  }

  void upsertProperty(Map<String, dynamic> data, {int? editIndex}) {
    if (editIndex != null) {
      addedProperties[editIndex] = data;
    } else {
      addedProperties.add(data);
    }
    notifyListeners();
  }

  void removePropertyAt(int index) {
    addedProperties.removeAt(index);
    notifyListeners();
  }

  void upsertInvestment(Map<String, dynamic> data, {int? editIndex}) {
    if (editIndex != null) {
      addedInvestments[editIndex] = data;
    } else {
      addedInvestments.add(data);
    }
    notifyListeners();
  }

  void removeInvestmentAt(int index) {
    addedInvestments.removeAt(index);
    notifyListeners();
  }

  void upsertVehicle(Map<String, dynamic> data, {int? editIndex}) {
    if (editIndex != null) {
      addedVehicles[editIndex] = data;
    } else {
      addedVehicles.add(data);
    }
    notifyListeners();
  }

  void removeVehicleAt(int index) {
    addedVehicles.removeAt(index);
    notifyListeners();
  }

  void removeFamilyMemberAt(int index) {
    addedFamilyMembers.removeAt(index);
    familyMemberEntities.removeAt(index);
    notifyListeners();
  }

  bool _isFieldFilled(TextEditingController controller) =>
      controller.text.trim().isNotEmpty;

  bool isPersonalDataSubStepComplete() {
    if (!_isFieldFilled(cpfController) ||
        cpfController.text.length < 14 ||
        cpfError != null) {
      return false;
    }
    if (!_isFieldFilled(nameController)) return false;
    if (!_isFieldFilled(dobController)) return false;
    try {
      final dob = DateFormat('dd/MM/yyyy').parse(dobController.text.trim());
      if (dob.isAfter(DateTime.now())) return false;
    } catch (_) {
      return false;
    }
    if (selectedGender == null) return false;
    if (!isFirstMember && kinshipType == null) return false;
    if (maritalStatus == null) return false;
    if (showReceivesPension && recebePensao == null) return false;
    if (showIsRetired && aposentado == null) return false;
    if (showCandidateField(
          isFirstMember: addedFamilyMembers.isEmpty,
          isHigherEducation: isHigherEducation,
        ) &&
        seraCandidato == null) {
      return false;
    }
    if (seraCandidato == 1 && !_isFieldFilled(nacionalityController)) {
      return false;
    }
    if (showNaturalizedField && naturalizado == null) return false;
    if (possuiCIN == null) return false;
    if (showCINFields) {
      if (!_isFieldFilled(rgController)) return false;
      if (!_isFieldFilled(orgaoController)) return false;
    }
    if (cadunicoValue == null) return false;
    if (showNisField && !_isFieldFilled(nisController)) return false;
    if (espectro == null) return false;
    if (superdotacao == null) return false;
    if (possuiDoenca == null) return false;
    if (showDiseaseType && !_isFieldFilled(tipoDoencaController)) return false;
    if (selectedPcd == null) return false;
    if (legalAge && irpfCondition == null) return false;
    if (legalAge && declarouEsseAno == null) return false;
    if (temCarteira == null) return false;
    if (trabalhadorRural == null) return false;
    return true;
  }

  bool isOccupationSubStepComplete() => hasOccupation;

  bool isOtherIncomeSubStepComplete() {
    if (possuiOutraFonteRenda == null) return false;
    if (possuiOutraFonteRenda == 1 && addedOtherIncomes.isEmpty) return false;
    return true;
  }

  bool isAssetsSubStepComplete() {
    if (possuiImovelProprio == null ||
        possuiInvestimentoFinanceiro == null ||
        possuiVeiculo == null) {
      return false;
    }
    if (possuiImovelProprio == 1 && addedProperties.isEmpty) return false;
    if (possuiInvestimentoFinanceiro == 1 && addedInvestments.isEmpty) {
      return false;
    }
    if (possuiVeiculo == 1 && addedVehicles.isEmpty) return false;
    return true;
  }

  bool canAdvanceSubStep(int subStep) {
    switch (subStep) {
      case 1:
        return isPersonalDataSubStepComplete();
      case 2:
        return isOccupationSubStepComplete();
      case 3:
        return isOtherIncomeSubStepComplete();
      case 4:
        return addedFamilyMembers.isNotEmpty;
      case 5:
        return isAssetsSubStepComplete();
      case 6:
        return true;
      default:
        return false;
    }
  }

  void clearPersonData() {
    nameController.clear();
    dobController.clear();
    rgController.clear();
    orgaoController.clear();
    selectedGender = null;
    maritalStatus = null;
    possuiCIN = null;
    recebePensao = null;
    aposentado = null;
    notifyListeners();
  }

  void resetMemberForm() {
    _editingIndex = null;
    _currentMemberId = null;
    kinshipType = null;
    cpfController.clear();
    nameController.clear();
    dobController.clear();
    nacionalityController.clear();
    rgController.clear();
    orgaoController.clear();
    nisController.clear();
    tipoDoencaController.clear();
    selectedGender = null;
    maritalStatus = null;
    selectedResponsible = null;
    selectedPcd = null;
    cadunicoValue = null;
    recebePensao = null;
    aposentado = null;
    seraCandidato = null;
    naturalizado = null;
    possuiCIN = null;
    possuiDoenca = null;
    irpfCondition = null;
    declarouEsseAno = null;
    temCarteira = null;
    trabalhadorRural = null;
    superdotacao = null;
    espectro = null;
    addedOccupations.clear();
    hasOccupation = false;
    recebePensaoAlimenticia = null;
    recebePrevidenciaPrivada = null;
    recebeOutroBeneficioINSS = null;
    showPensionValueField = false;
    showPrevidenciaValueField = false;
    showInssValueField = false;
    pensionIncomeAcknowledged = false;
    inssBenefitAcknowledged = false;
    pensionValueController.clear();
    previdenciaValueController.clear();
    beneficioValueController.clear();
    possuiOutraFonteRenda = null;
    addedOtherIncomes.clear();
    recebeValorImovelAlugado = null;
    ajudaFinanceira = null;
    beneficiarioProgramaGoverno = null;
    possuiImovelProprio = null;
    possuiInvestimentoFinanceiro = null;
    possuiVeiculo = null;
    imovelAlugadoValueController.clear();
    ajudaFamiliarValueController.clear();
    ajudaOutroDeQuemController.clear();
    ajudaOutroValueController.clear();
    programaGovernoController.clear();
    programaGovernoValueController.clear();
    addedProperties.clear();
    addedInvestments.clear();
    addedVehicles.clear();
    notifyListeners();
  }

  bool get hasCurrentMemberToCommit =>
      nameController.text.trim().isNotEmpty ||
      cpfController.text.trim().isNotEmpty ||
      hasOccupation ||
      addedOtherIncomes.isNotEmpty ||
      possuiOutraFonteRenda != null;

  void commitCurrentMemberToList() {
    final map = {
      'id': _currentMemberId,
      'cpf': cpfController.text.trim(),
      'name': nameController.text.trim(),
      'dob': dobController.text.trim(),
      'maritalStatus': maritalStatus?.label,
      'isScholarshipCandidate': seraCandidato == 1,
      'isResponsible': isFirstMember,
      'kinshipType': kinshipType?.value,
      'occupations': List<Map<String, dynamic>>.from(addedOccupations),
      'hasOtherIncome': possuiOutraFonteRenda == 1,
      'otherIncomes': List<Map<String, dynamic>>.from(addedOtherIncomes),
    };

    final entity = toFamilyMemberEntity();

    if (_editingIndex != null) {
      // Atualiza o existente
      addedFamilyMembers[_editingIndex!] = map;
      familyMemberEntities[_editingIndex!] = entity;
      _editingIndex = null;
    } else {
      // Adiciona novo
      addedFamilyMembers.add(map);
      familyMemberEntities.add(entity);
    }

    resetMemberForm();
  }

  double computeGrossFamilyIncome() {
    var total = 0.0;

    for (final member in addedFamilyMembers) {
      final occupations = member['occupations'];
      if (occupations is! List) continue;

      for (final occupation in occupations) {
        if (occupation is! Map) continue;
        total += MoneyFormatter.parse(
          occupation['monthlyIncome'] ?? occupation['headerTitle'],
        );
      }
    }

    if (recebeValorImovelAlugado == 1) {
      total += MoneyFormatter.parse(imovelAlugadoValueController.text);
    }
    if (ajudaFinanceira == 1) {
      total += MoneyFormatter.parse(ajudaFamiliarValueController.text);
    } else if (ajudaFinanceira == 2) {
      total += MoneyFormatter.parse(ajudaOutroValueController.text);
    }
    if (beneficiarioProgramaGoverno == 1) {
      total += MoneyFormatter.parse(programaGovernoValueController.text);
    }

    return total;
  }

  int get incomeDependents =>
      addedFamilyMembers.isEmpty ? 1 : addedFamilyMembers.length;

  double get perCapitaIncome => computeGrossFamilyIncome() / incomeDependents;

  String formatSalaryRatio(double perCapitaIncome) {
    final ratio = perCapitaIncome / minimumWage;
    return '${NumberFormat('#,##0.00', 'pt_BR').format(ratio)} '
        '${AppI18n.current.salaryRatioSuffix}';
  }

  SummaryData get summaryData {
    final grossIncome = computeGrossFamilyIncome();
    final perCapita = perCapitaIncome;
    return SummaryData(
      grossIncome: grossIncome,
      incomeDependents: incomeDependents,
      perCapitaIncome: perCapita,
      minimumWage: minimumWage,
      salaryRatioLabel: formatSalaryRatio(perCapita),
    );
  }

  FamilyMemberEntity toFamilyMemberEntity({String? existingId}) {
    return FamilyMemberEntity(
      id: existingId ?? _currentMemberId ?? '',
      name: nameController.text.trim(),
      personCpf: cpfController.text.trim(),
      personBirthDate: _parseDob(),
      personGender: _parseGender(),
      kinshipType: isFirstMember ? 1 : (kinshipType?.value ?? 99),
      maritalStatus: _parseMaritalStatus(),
      nationalityId: selectedNationalityId,
      naturalized: naturalizado == 1,
      isCandidate: seraCandidato == 1,
      isRetired: aposentado == 1,
      hasWorkBooklet: temCarteira == 1,
      ruralWorker: trabalhadorRural == 1,
      declarationType: legalAge ? irpfCondition : null,
      declared: legalAge ? declarouEsseAno == 1 : null,
      personHasCin: possuiCIN == 1,
      personRg:
          rgController.text.trim().isEmpty ? null : rgController.text.trim(),
      personRgIssuingAuthority: orgaoController.text.trim().isEmpty
          ? null
          : orgaoController.text.trim(),
      hasChronicDisease: possuiDoenca == 1,
      chronicDiseaseName:
          possuiDoenca == 1 ? tipoDoencaController.text.trim() : null,
      hasHighAbilityGiftedness: superdotacao == 1,
      hasAutismSpectrumDisorder: espectro == 1,
      specialNeedsId: selectedPcdId ?? _nenhunmaSpecialNeedsId,
      hasCadUnico: cadunicoValue == 1,
      governmentBeneficiaryNis:
          cadunicoValue == 1 ? nisController.text.trim() : null,
      hasAlimony: recebePensaoAlimenticia == 1,
      alimonyAmount: recebePensaoAlimenticia == 1
          ? MoneyFormatter.parse(pensionValueController.text)
          : null,
      hasInssAssistance: recebeOutroBeneficioINSS == 1,
      inssAssistanceAmount: recebeOutroBeneficioINSS == 1
          ? MoneyFormatter.parse(beneficioValueController.text)
          : null,
      hasPrivatePension: recebePrevidenciaPrivada == 1,
      privatePensionAmount: recebePrevidenciaPrivada == 1
          ? MoneyFormatter.parse(previdenciaValueController.text)
          : null,
      receivePension: recebePensao == 1,
      occupations: _parseOccupations(),
      extraIncomes: _parseExtraIncomes(),
      noExtraIncomeDeclared: possuiOutraFonteRenda == 0,
    );
  }

  DateTime? _parseDob() {
    try {
      return DateFormat('dd/MM/yyyy').parse(dobController.text.trim());
    } catch (_) {
      return null;
    }
  }

  int _parseGender() {
    switch (selectedGender) {
      case 'Feminino':
        return 1;
      case 'Masculino':
        return 2;
      default:
        return 1;
    }
  }

  int _parseMaritalStatus() => maritalStatus?.value ?? 4;

  List<ExtraIncomeEntity> _parseExtraIncomes() {
    return addedOtherIncomes
        .map((o) => ExtraIncomeEntity(
              id: o['id'] as String?,
              extraIncomeTypeId: o['extraIncomeTypeId'] as String?,
              description: o['description'] as String?,
              amount:
                  MoneyFormatter.parse(o['monthlyIncome']?.toString() ?? '0'),
            ))
        .toList();
  }

  List<OccupationEntity> _parseOccupations() {
    return addedOccupations.map((o) {
      return OccupationEntity(
        id: o['id'] as String?,
        occupationTypeId:
            (o['occupationTypeId'] ?? o['occupationTypeId'] ?? '') as String,
        monthlyIncome: MoneyFormatter.parse(
          o['monthlyIncome']?.toString() ?? o['headerTitle']?.toString() ?? '0',
        ),
        companyName: o['companyName'] as String?,
        companyType: o['companyType'] as int?,
        cnpj: o['cnpj'] as String?,
        function: o['function'] as String?,
        situation: o['situation'] as int?,
        hadActivityLastYear: o['hadActivityLastYear'] as bool?,
        simplesNacionalTax: o['simplesNacionalTax'] as bool?,
        unemploymentInsurance: o['unemploymentInsurance'] as bool?,
      );
    }).toList();
  }

  GroupIncomeEntity toGroupIncomeEntity() {
    return GroupIncomeEntity(
      hasRentalPropertyValues: recebeValorImovelAlugado == 1,
      propertysAmount: recebeValorImovelAlugado == 1
          ? MoneyFormatter.parse(imovelAlugadoValueController.text)
          : null,
      financialHelpType: ajudaFinanceira,
      financialHelpAmount: ajudaFinanceira == 1
          ? MoneyFormatter.parse(ajudaFamiliarValueController.text)
          : ajudaFinanceira == 2
              ? MoneyFormatter.parse(ajudaOutroValueController.text)
              : null,
      financialHelper: ajudaFinanceira == 1
          ? null
          : ajudaFinanceira == 2
              ? ajudaOutroDeQuemController.text.trim()
              : null,
      isGovernmentBeneficiary: beneficiarioProgramaGoverno == 1,
      governmentProgramDescription: beneficiarioProgramaGoverno == 1
          ? programaGovernoController.text.trim()
          : null,
      governmentProgramAmount: beneficiarioProgramaGoverno == 1
          ? MoneyFormatter.parse(programaGovernoValueController.text)
          : null,
      hasProprietys: possuiImovelProprio == 1,
      hasFinancing: possuiInvestimentoFinanceiro == 1,
      hasVehicles: possuiVeiculo == 1,
      properties: addedProperties
          .map((p) => PropertyEntity(
                id: p['id'] as String?,
                assetTypeId: p['assetTypeId'] as int?,
                assetAmount:
                    MoneyFormatter.parse(p['assetAmount']?.toString() ?? '0'),
                installmentAmount: p['installmentAmount'] != null
                    ? MoneyFormatter.parse(p['installmentAmount'].toString())
                    : null,
              ))
          .toList(),
      financings: addedInvestments
          .map((f) => FinancingEntity(
                id: f['id'] as String?,
                assetTypeId: f['assetTypeId'] as int?,
                assetAmount:
                    MoneyFormatter.parse(f['assetAmount']?.toString() ?? '0'),
              ))
          .toList(),
      vehicles: addedVehicles
          .map((v) => VehicleEntity(
                id: v['id'] as String?,
                vehicleBrand: v['brand'] as String?,
                vehicleModel: v['model'] as String?,
                vehicleYear: v['year'] as String?,
                assetAmount:
                    MoneyFormatter.parse(v['assetValue']?.toString() ?? '0'),
                installmentAmount: v['installmentValue'] != null
                    ? MoneyFormatter.parse(v['installmentValue'].toString())
                    : null,
              ))
          .toList(),
    );
  }

  @override
  void dispose() {
    for (final controller in _trackedControllers) {
      controller.removeListener(notifyListeners);
      controller.dispose();
    }
    super.dispose();
  }
}

class SummaryData {
  const SummaryData({
    required this.grossIncome,
    required this.incomeDependents,
    required this.perCapitaIncome,
    required this.minimumWage,
    required this.salaryRatioLabel,
  });

  final double grossIncome;
  final int incomeDependents;
  final double perCapitaIncome;
  final double minimumWage;
  final String salaryRatioLabel;
}
