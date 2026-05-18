import 'package:flutter/material.dart';

enum MaritalStatus { solteiro, casado, divorciado, viuvo }

extension MaritalStatusExtension on MaritalStatus {
  String toKey() {
    switch (this) {
      case MaritalStatus.solteiro:
        return 'Solteiro(a)';
      case MaritalStatus.casado:
        return 'Casado(a)';
      case MaritalStatus.divorciado:
        return 'Divorciado(a)';
      case MaritalStatus.viuvo:
        return 'Viúvo(a)';
    }
  }
}

class MemberRegistrationViewModel extends ChangeNotifier {
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController responsibleController = TextEditingController();
  final TextEditingController maritalController = TextEditingController();
  final TextEditingController nacionalityController = TextEditingController();
  final TextEditingController rgController = TextEditingController();
  final TextEditingController orgaoController = TextEditingController();
  final TextEditingController nisController = TextEditingController();
  final TextEditingController tipoDoencaController = TextEditingController();
  final List<String> genderOptions = ['Masculino', 'Feminino', 'Outro'];
  final List<String> responsibleOptions = ['Pai', 'Mãe', 'Outro'];
  final List<String> pcdOptions = [
    'Nenhuma',
    'Auditiva',
    'Visual',
    'Fisica',
    'Mental',
    'Multipla'
  ];
  final List<String> nationalityOptions = [
    'Brasileira',
    'Argentina',
    'Chile',
    'Bolívia',
    'Colômbia',
    'Paraguai',
    'Uruguai',
    'Venezuela',
    'Estados Unidos',
    'Portugal',
    'Espanha',
    'Outro'
  ];

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

  MemberRegistrationViewModel() {
    cpfController.text = '';
    nameController.text = '';
    dobController.text = '';
    genderController.text = '';
    responsibleController.text = '';
    maritalController.text = '';
    nacionalityController.text = '';
  }

  bool get showReceivesPension => maritalStatus == MaritalStatus.viuvo;
  bool get showIsRetired => recebePensao == 1;
  bool get showCINFields => possuiCIN == 1;
  bool get showNisField => cadunicoValue == 1;
  bool get showDiseaseType => possuiDoenca == 1;

  List<MaritalStatus> get maritalOptions => MaritalStatus.values;

  String maritalDisplay(MaritalStatus m) => m.toKey();

  void setMarital(MaritalStatus? m) {
    maritalStatus = m;
    if (m != MaritalStatus.viuvo) recebePensao = null;
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

  @override
  void dispose() {
    cpfController.dispose();
    nameController.dispose();
    dobController.dispose();
    genderController.dispose();
    responsibleController.dispose();
    maritalController.dispose();
    nacionalityController.dispose();
    rgController.dispose();
    orgaoController.dispose();
    nisController.dispose();
    tipoDoencaController.dispose();
    super.dispose();
  }
}
