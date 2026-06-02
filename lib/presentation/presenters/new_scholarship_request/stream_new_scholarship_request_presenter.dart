import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../data/cache/enrollment_draft_storage.dart';
import '../../../domain/entities/enrollment_enums.dart';
import '../../../domain/entities/housing_entity.dart';
import '../../../domain/usecases/enrollment/lookup_zip_code_usecase.dart';
import '../../../domain/usecases/enrollment/save_step_1_usecase.dart';
import '../../../infra/repositories/enrollment/remote_save_step_1_usecase.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../ui/modules/new_request/new_scholarship_request_presenter.dart';
import '../../mixins/mixins.dart';

class StreamNewScholarshipRequestPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements NewScholarshipRequestPresenter {
  final String processPeriodId;
  final SaveStep1Usecase saveStep1Usecase;
  final LookupZipCodeUsecase lookupZipCodeUsecase;
  final EnrollmentDraftStorage draftStorage;

  StreamNewScholarshipRequestPresenter({
    required this.processPeriodId,
    required this.saveStep1Usecase,
    required this.lookupZipCodeUsecase,
    required this.draftStorage,
  }) {
    _currentStepController.add(_currentStep);
    _currentStepController.add(_currentSubStep);
    _syncControllersToNotifiers();
    _loadDraft();
  }

  // Step/substep state
  final Map<int, int> _stepSubSteps = {1: 1, 2: 5, 3: 3, 4: 2, 5: 1, 6: 1};

  final _navigationController = StreamController<String?>.broadcast();
  final _currentStepController = StreamController<int>.broadcast();
  final _currentSubStepController = StreamController<int>.broadcast();
  final _zipCodeLoadingController = StreamController<bool>.broadcast();

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
  String? _residenceArea;
  String? _housingType;
  ResidenceType? _residenceType;

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
  final ValueNotifier<String?> _residenceAreaNotifier = ValueNotifier(null);
  final ValueNotifier<ResidenceType?> _housingTypeNotifier =
      ValueNotifier(null);
  final ValueNotifier<Map<String, String?>> _fieldErrorsNotifier =
      ValueNotifier({});

  void _syncControllersToNotifiers() {
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
  }

  Future<void> _loadDraft() async {
    try {
      final draft = await draftStorage.loadStep1(processPeriodId);
      if (draft == null) return;
      final entity = HousingEntity.fromJson(draft);
      _cepController.text = entity.zipCode;
      _numberController.text = entity.number ?? '';
      _complementController.text = entity.complement ?? '';
      _addressController.text = entity.street ?? '';
      _neighborhoodController.text = entity.district ?? '';
      _cityController.text = entity.city ?? '';
      _stateValue = entity.state;
      _stateNotifier.value = entity.state;
      if (entity.residenceAreaType != null) {
        _residenceArea = entity.residenceAreaType!.label;
        _residenceAreaNotifier.value = _residenceArea;
      }
      if (entity.residenceType != null) {
        _residenceType = entity.residenceType;
        _housingTypeNotifier.value = _residenceType;
      }
    } catch (_) {}
  }

  void _saveDraftSilently() {
    try {
      final entity = _buildHousingEntity();
      draftStorage.saveStep1(processPeriodId, entity.toJson());
    } catch (_) {}
  }

  HousingEntity _buildHousingEntity() => HousingEntity(
        processPeriodId: processPeriodId,
        zipCode: _cepController.text.replaceAll(RegExp(r'\D'), ''),
        street: _addressController.text,
        number: _numberController.text,
        complement: _complementController.text.isEmpty
            ? null
            : _complementController.text,
        district: _neighborhoodController.text,
        city: _cityController.text,
        state: _stateValue,
        residenceAreaType: ResidenceAreaType.values.firstWhereOrNull(
          (e) => e.label == _residenceArea,
        ),
        residenceType: _residenceType,
      );

  @override
  Stream<String?> get navigationRouteStream => _navigationController.stream;

  @override
  Stream<int> get currentStepStream => _currentStepController.stream;

  @override
  Stream<int> get currentSubStepStream => _currentSubStepController.stream;

  @override
  Stream<bool> get zipCodeLoadingStream => _zipCodeLoadingController.stream;

  @override
  Map<int, int> get stepSubSteps => Map.unmodifiable(_stepSubSteps);

  // expose controllers and values
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
  String? get residenceArea => _residenceArea;

  @override
  String? get housingType => _housingType;

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
  ValueListenable<String?> get residenceAreaListenable =>
      _residenceAreaNotifier;

  @override
  ValueListenable<ResidenceType?> get housingTypeListenable =>
      _housingTypeNotifier;

  @override
  ValueListenable<Map<String, String?>> get fieldErrorsListenable =>
      _fieldErrorsNotifier;

  @override
  void updateStateValue(String? v) {
    _stateValue = v;
    _stateNotifier.value = v;
    _saveDraftSilently();
  }

  @override
  void updateResidenceArea(String v) {
    _residenceArea = v;
    _residenceAreaNotifier.value = v;
    _saveDraftSilently();
  }

  @override
  void updateHousingType(String? v) {
    _residenceType = ResidenceType.values.firstWhereOrNull(
      (e) => e.label == v,
    );
    _housingTypeNotifier.value = _residenceType;
    _saveDraftSilently();
  }

  @override
  void updateHousingTypeEnum(ResidenceType? type) {
    _residenceType = type;
    _housingTypeNotifier.value = type;
    _saveDraftSilently();
  }

  // --- Parada do CEP ---

  @override
  Future<void> lookupZipCode(String cep) async {
    if (cep.length != 8) return;

    _clearAddresFields();
    _zipCodeLoadingController.add(true);

    final currentErrors = Map<String, String?>.from(_fieldErrorsNotifier.value);
    currentErrors.remove('cep');
    _fieldErrorsNotifier.value = currentErrors;

    try {
      final result = await lookupZipCodeUsecase.lookup(cep);
      _addressController.text = result.street ?? '';
      _neighborhoodController.text = result.neighborhood ?? '';
      _cityController.text = result.city ?? '';
      _stateValue = result.state;
      _stateNotifier.value = result.state;
      _saveDraftSilently();
    } on ZipCodeNotFoundException {
      final errors = Map<String, String?>.from(_fieldErrorsNotifier.value);
      errors['cep'] = AppI18n.current.zipCodeInvalid;
      _fieldErrorsNotifier.value = errors;
    } catch (_) {
      uiError = AppI18n.current.errorUnexpected;
    } finally {
      _zipCodeLoadingController.add(false);
    }
  }

  void _clearAddresFields() {
    _addressController.text = '';
    _neighborhoodController.text = '';
    _cityController.text = '';
    _stateValue = null;
    _stateNotifier.value = null;
  }

  @override
  void clearAddressFields() => _clearAddresFields();

  // --- Submit step 1 ---

  @override
  Future<void> submitStep1() async {
    final errors = <String, String?>{};
    final appStrings = AppI18n.current;

    final cep = _cepController.text.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) errors['cep'] = appStrings.fieldRequired;
    if (_numberController.text.trim().isEmpty) {
      errors['number'] = appStrings.fieldRequired;
    }
    if (_addressController.text.trim().isEmpty) {
      errors['address'] = appStrings.fieldRequired;
    }
    if (_neighborhoodController.text.trim().isEmpty) {
      errors['neighborhood'] = appStrings.fieldRequired;
    }
    if (_cityController.text.trim().isEmpty) {
      errors['city'] = appStrings.fieldRequired;
    }
    if (_stateValue == null || _stateValue!.isEmpty) {
      errors['state'] = appStrings.fieldRequired;
    }
    final areaType = ResidenceAreaType.values.firstWhereOrNull(
      (e) => e.label == _residenceArea,
    );
    if (areaType == null) errors['residenceArea'] = appStrings.fieldRequired;
    if (_residenceType == null) {
      errors['housingType'] = appStrings.fieldRequired;
    }

    _fieldErrorsNotifier.value = errors;

    if (errors.isNotEmpty) return;

    isLoading = LoadingData(isLoading: true);

    try {
      final entity = _buildHousingEntity();
      await saveStep1Usecase.save(entity);
      next();
    } on SaveStep1Exception catch (e) {
      uiError = e.message;
    } catch (_) {
      uiError = AppI18n.current.errorUnexpected;
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }

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

  @override
  Future<void> checkSession() async {}

  @override
  void dispose() {
    _navigationController.close();
    _currentStepController.close();
    _currentSubStepController.close();
    _zipCodeLoadingController.close();
    _cepController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _addressController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _cepNotifier.dispose();
    _numberNotifier.dispose();
    _complementNotifier.dispose();
    _addressNotifier.dispose();
    _neighborhoodNotifier.dispose();
    _cityNotifier.dispose();
    _stateNotifier.dispose();
    _residenceAreaNotifier.dispose();
    _housingTypeNotifier.dispose();
  }
}
