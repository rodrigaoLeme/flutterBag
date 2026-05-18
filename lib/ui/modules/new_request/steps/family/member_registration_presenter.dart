import 'package:flutter/foundation.dart';
import 'member_registration_view_model.dart';

class MemberRegistrationPresenter extends ChangeNotifier {
  MaritalStatus? maritalStatus;
  int? recebePensao;

  MemberRegistrationPresenter();

  List<MaritalStatus> get maritalOptions => MaritalStatus.values;

  String maritalDisplay(MaritalStatus m) {
    return m.toKey();
  }

  bool get showReceivesPension => maritalStatus == MaritalStatus.viuvo;

  void setMarital(MaritalStatus? m) {
    maritalStatus = m;
    if (m != MaritalStatus.viuvo) recebePensao = null;
    notifyListeners();
  }

  void setRecebePensao(int? v) {
    recebePensao = v;
    notifyListeners();
  }
}
