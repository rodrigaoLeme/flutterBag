import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class NewScholarshipRequestPresenter {
  Stream<String?> get navigationRouteStream;
  Stream<int> get currentStepStream;
  Stream<int> get currentSubStepStream;
  Map<int, int> get stepSubSteps;

  void goToStep(int step);
  void next();
  void previous();

  TextEditingController get cepController;
  TextEditingController get numberController;
  TextEditingController get complementController;
  TextEditingController get addressController;
  TextEditingController get neighborhoodController;
  TextEditingController get cityController;

  String? get stateValue;
  String? get residenceArea;
  String? get housingType;

  void updateStateValue(String? v);
  void updateResidenceArea(String v);
  void updateHousingType(String? v);

  ValueListenable<String?> get cepListenable;
  ValueListenable<String?> get numberListenable;
  ValueListenable<String?> get complementListenable;
  ValueListenable<String?> get addressListenable;
  ValueListenable<String?> get neighborhoodListenable;
  ValueListenable<String?> get cityListenable;
  ValueListenable<String?> get stateListenable;
  ValueListenable<String?> get residenceAreaListenable;
  ValueListenable<String?> get housingTypeListenable;
  ValueListenable<Map<String, String?>> get fieldErrorsListenable;

  Stream<void> get isLoadingStream;
  Stream<String?> get uiErrorStream;
  Stream<bool> get zipCodeLoadingStream;

  Future<void> lookupZipCode(String cep);
  Future<void> submitStep1();

  void clearAddressFields();

  Future<void> checkSession();
  void dispose();
}
