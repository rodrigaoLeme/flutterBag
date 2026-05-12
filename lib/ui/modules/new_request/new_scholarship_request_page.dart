import 'package:flutter/material.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';

import 'widgets/scholarship_step_indicator.dart';
import 'steps/housing/housing_step.dart';
import 'steps/family/family_step.dart';
import 'steps/expenses/expenses_step.dart';
import 'steps/candidate/candidate_step.dart';
import 'steps/documents/documents_step.dart';
import '../../../main/factories/pages/new_scholarship_request/new_scholarship_request_presenter_factory.dart';
import 'new_scholarship_request_presenter.dart';

class NewScholarshipRequestPage extends StatefulWidget {
  final NewScholarshipRequestPresenter? presenter;

  const NewScholarshipRequestPage({super.key, this.presenter});

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
    _presenter = widget.presenter ?? makeNewRequestPresenter();
    _presenter.stepSubSteps;
    _presenter.currentStepStream
        .listen((s) => setState(() => _currentStep = s));
    _presenter.currentSubStepStream
        .listen((s) => setState(() => _currentSubStep = s));
  }

  void _goToStep(int step) {
    _presenter.goToStep(step);
  }

  void _next() {
    _presenter.next();
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
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
        );

      case 2:
        return FamilyStep(currentSubStep: _currentSubStep);

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
            Padding(
              padding: const EdgeInsets.all(16),
              child: EbolsaButton(
                onPressed: _next,
                label: _currentStep < _totalSteps ? 'Avançar' : 'Finalizar',
                isSecondary: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
