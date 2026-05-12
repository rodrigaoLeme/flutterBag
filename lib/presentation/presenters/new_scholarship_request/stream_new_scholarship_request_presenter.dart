import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

import '../../../ui/modules/new_request/new_scholarship_request_presenter.dart';
import '../../mixins/mixins.dart';

class StreamNewScholarshipRequestPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements NewScholarshipRequestPresenter {
  // Step/substep state
  final Map<int, int> _stepSubSteps = {1: 1, 2: 5, 3: 3, 4: 2, 5: 1, 6: 1};

  final _navigationController = StreamController<String?>.broadcast();
  final _currentStepController = StreamController<int>.broadcast();
  final _currentSubStepController = StreamController<int>.broadcast();

  int _currentStep = 1;
  int _currentSubStep = 1;

  // Form controllers for housing step
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  // Housing state values
  String? _stateValue;
  String _residenceArea = 'Urbana';
  String? _housingType;

  // ValueNotifiers for UI binding
  final ValueNotifier<String?> _cepNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _numberNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _complementNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _addressNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String?> _neighborhoodNotifier =
      ValueNotifier<String?>(null);
  final ValueNotifier<String?> _cityNotifier = ValueNotifier<String?>(null);

  final ValueNotifier<String?> _stateNotifier = ValueNotifier<String?>(null);
  final ValueNotifier<String> _residenceAreaNotifier =
      ValueNotifier<String>('Urbana');
  final ValueNotifier<String?> _housingTypeNotifier =
      ValueNotifier<String?>(null);

  StreamNewScholarshipRequestPresenter() {
    // push initial values
    _currentStepController.add(_currentStep);
    _currentSubStepController.add(_currentSubStep);

    // sync controllers to notifiers
    _cepController.addListener(() => _cepNotifier.value = _cepController.text);
    _numberController
        .addListener(() => _numberNotifier.value = _numberController.text);
    _complementController.addListener(
        () => _complementNotifier.value = _complementController.text);
    _addressController
        .addListener(() => _addressNotifier.value = _addressController.text);
    _neighborhoodController.addListener(
        () => _neighborhoodNotifier.value = _neighborhoodController.text);
    _cityController
        .addListener(() => _cityNotifier.value = _cityController.text);

    _stateNotifier.value = _stateValue;
    _residenceAreaNotifier.value = _residenceArea;
    _housingTypeNotifier.value = _housingType;
  }

  @override
  Stream<String?> get navigationRouteStream => _navigationController.stream;

  @override
  Stream<int> get currentStepStream => _currentStepController.stream;

  @override
  Stream<int> get currentSubStepStream => _currentSubStepController.stream;

  @override
  Map<int, int> get stepSubSteps => Map.unmodifiable(_stepSubSteps);

  // expose controllers and values
  @override
  @override
  TextEditingController get cepController => _cepController;

  @override
  TextEditingController get numberController => _numberController;

  @override
  TextEditingController get complementController => _complementController;

  @override
  TextEditingController get addressController => _addressController;

  @override
  TextEditingController get neighborhoodController => _neighborhoodController;

  @override
  TextEditingController get cityController => _cityController;

  @override
  String? get stateValue => _stateValue;

  @override
  String get residenceArea => _residenceArea;

  @override
  String? get housingType => _housingType;

  @override
  void updateStateValue(String? v) {
    _stateValue = v;
    _stateNotifier.value = v;
  }

  @override
  void updateResidenceArea(String v) {
    _residenceArea = v;
    _residenceAreaNotifier.value = v;
  }

  @override
  void updateHousingType(String? v) {
    _housingType = v;
    _housingTypeNotifier.value = v;
  }

  // ValueListenable getters
  @override
  ValueListenable<String?> get cepListenable => _cepNotifier;

  @override
  ValueListenable<String?> get numberListenable => _numberNotifier;

  @override
  ValueListenable<String?> get complementListenable => _complementNotifier;

  @override
  ValueListenable<String?> get addressListenable => _addressNotifier;

  @override
  ValueListenable<String?> get neighborhoodListenable => _neighborhoodNotifier;

  @override
  ValueListenable<String?> get cityListenable => _cityNotifier;

  @override
  ValueListenable<String?> get stateListenable => _stateNotifier;

  @override
  ValueListenable<String> get residenceAreaListenable => _residenceAreaNotifier;

  @override
  ValueListenable<String?> get housingTypeListenable => _housingTypeNotifier;

  @override
  void goToStep(int step) {
    final newStep = step.clamp(1, _stepSubSteps.length);
    _currentStep = newStep;
    _currentSubStep = 1;
    _currentStepController.add(_currentStep);
    _currentSubStepController.add(_currentSubStep);
  }

  @override
  void next() {
    final totalSub = _stepSubSteps[_currentStep] ?? 1;
    if (_currentSubStep < totalSub) {
      _currentSubStep++;
      _currentSubStepController.add(_currentSubStep);
      return;
    }

    if (_currentStep < _stepSubSteps.length) {
      _currentStep++;
      _currentSubStep = 1;
      _currentStepController.add(_currentStep);
      _currentSubStepController.add(_currentSubStep);
    } else {
      // finished flow - emit navigation or finish event
      _navigationController.add(null);
    }
  }

  @override
  void previous() {
    if (_currentSubStep > 1) {
      _currentSubStep--;
      _currentSubStepController.add(_currentSubStep);
      return;
    }

    if (_currentStep > 1) {
      _currentStep--;
      _currentSubStep = _stepSubSteps[_currentStep] ?? 1;
      _currentStepController.add(_currentStep);
      _currentSubStepController.add(_currentSubStep);
    }
  }

  Future<void> loadData() async {}

  @override
  Future<void> checkSession() async {
    // default no-op for now
    return;
  }

  @override
  void dispose() {
    _navigationController.close();
    _currentStepController.close();
    _currentSubStepController.close();
    _cepController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
  }
}
