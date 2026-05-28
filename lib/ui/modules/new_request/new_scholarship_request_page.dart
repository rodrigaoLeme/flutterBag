import 'package:flutter/material.dart';

import '../../../main/factories/pages/new_scholarship_request/new_scholarship_request_presenter_factory.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import 'new_scholarship_request_presenter.dart';
import 'steps/candidate/candidate_step.dart';
import 'steps/documents/documents_step.dart';
import 'steps/expenses/expenses_step.dart';
import 'steps/family/family_step.dart';
import 'steps/family/member_registration_page.dart';
import 'steps/housing/housing_step.dart';
import 'widgets/scholarship_step_indicator.dart';

class NewScholarshipRequestPage extends StatefulWidget {
  final NewScholarshipRequestPresenter? presenter;
  final String processPeriodId;

  const NewScholarshipRequestPage({
    super.key,
    this.presenter,
    required this.processPeriodId,
  });

  @override
  State<NewScholarshipRequestPage> createState() =>
      _NewScholarshipRequestPageState();
}

class _NewScholarshipRequestPageState extends State<NewScholarshipRequestPage> {
  int _currentStep = 1;
  int _currentSubStep = 0;

  late final NewScholarshipRequestPresenter _presenter;

  static const int _totalSteps = 5;

  @override
  void initState() {
    super.initState();
    _presenter = widget.presenter ??
        makeNewRequestPresenter(processPeriodId: widget.processPeriodId);
    _presenter.stepSubSteps;
    _presenter.currentStepStream
        .listen((s) => setState(() => _currentStep = s));
    _presenter.currentSubStepStream
        .listen((s) => setState(() => _currentSubStep = s));
  }

  void _goToStep(int step) {
    _presenter.goToStep(step);
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return ValueListenableBuilder<Map<String, String?>>(
          valueListenable: _presenter.fieldErrorsListenable,
          builder: (context, errors, _) {
            return HousingStep(
              currentSubStep: _currentSubStep,
              cepController: _presenter.cepController,
              numberController: _presenter.numberController,
              complementController: _presenter.complementController,
              addressController: _presenter.addressController,
              neighborhoodController: _presenter.neighborhoodController,
              cityController: _presenter.cityController,
              stateListenable: _presenter.stateListenable,
              residenceAreaListenable: _presenter.residenceAreaListenable,
              housingTypeListenable: _presenter.housingTypeListenable,
              onStateChanged: _presenter.updateStateValue,
              onResidenceAreaChanged: _presenter.updateResidenceArea,
              onHousingTypeChanged: _presenter.updateHousingType,
              onZipCodeComplete: _presenter.lookupZipCode,
              onClearAddressFields: _presenter.clearAddressFields,
              cepError: errors['cep'],
              numberError: errors['number'],
              addressError: errors['address'],
              neighborhoodError: errors['neighborhood'],
              cityError: errors['city'],
              stateError: errors['state'],
              residenceAreaError: errors['residenceArea'],
              housingTypeError: errors['housingType'],
            );
          },
        );

      case 2:
        return FamilyStep(
          currentSubStep: _currentSubStep,
          onAddMember: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MemberRegistrationPage()),
          ),
        );

      case 3:
        return ExpensesStep(currentSubStep: _currentSubStep);

      case 4:
        return CandidateStep(currentSubStep: _currentSubStep);

      case 5:
        return DocumentsStep(currentSubStep: _currentSubStep);

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppI18n.current.newProcess),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: ScholarshipStepIndicator(
                currentStep: _currentStep,
                onStepTap: _goToStep,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: _buildCurrentStep(),
              ),
            ),
            Visibility(
              visible: !(_currentStep == 2 && _currentSubStep == 1),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: EbolsaButton(
                  onPressed: () {
                    if (_currentStep == 1) {
                      _presenter.submitStep1();
                    } else {
                      _presenter.next();
                    }
                  },
                  label: _currentStep < _totalSteps ? 'Avançar' : 'Finalizar',
                  isSecondary: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
