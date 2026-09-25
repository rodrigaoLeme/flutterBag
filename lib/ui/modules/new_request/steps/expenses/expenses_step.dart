import 'package:flutter/material.dart';

import '../../../../../domain/entities/expenses_entity.dart';
import '../../../../../domain/entities/family_member_entity.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/money_formatter.dart';
import '../../../../helpers/themes/themes.dart';
import '../../dev_navigation_overrides.dart';
import 'expenses_automobile_sub_step.dart';
import 'expenses_education_sub_step.dart';
import 'expenses_food_sub_step.dart';
import 'expenses_health_sub_step.dart';
import 'expenses_housing_sub_step.dart';
import 'expenses_loans_sub_step.dart';

class ExpensesStep extends StatefulWidget {
  final int currentSubStep;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onFormChanged;
  final List<FamilyMemberEntity> familyMembers;

  const ExpensesStep({
    super.key,
    required this.currentSubStep,
    this.onPrevious,
    this.onNext,
    this.onFormChanged,
    this.familyMembers = const [],
  });

  @override
  State<ExpensesStep> createState() => ExpensesStepState();
}

class ExpensesStepState extends State<ExpensesStep> {
  final GlobalKey<ExpensesEducationSubStepState> _educationSubStepKey =
      GlobalKey<ExpensesEducationSubStepState>();
  final GlobalKey<ExpensesHealthSubStepState> _healthSubStepKey =
      GlobalKey<ExpensesHealthSubStepState>();
  final GlobalKey<ExpensesLoansSubStepState> _loansSubStepKey =
      GlobalKey<ExpensesLoansSubStepState>();

  bool canAdvanceCurrentSubStep() {
    switch (widget.currentSubStep) {
      case 1: // Moradia — opcional
      case 2: // Alimentação — opcional
      case 3: // Saúde — opcional
      case 5: // Automóvel — opcional
      case 6: // Financiamento / empréstimo — opcional
        return true;
      case 4: // Educação — obrigatório
        return _educationSubStepKey.currentState?.canAdvance ?? false;
      default:
        return false;
    }
  }

  bool validateCurrentSubStep() {
    if (widget.currentSubStep == 4) {
      return _educationSubStepKey.currentState?.validate() ?? false;
    }
    return canAdvanceCurrentSubStep();
  }

  ExpensesEntity buildExpensesEntity() {
    final education = _educationSubStepKey.currentState;

    return ExpensesEntity(
      familyResidenceRentalAmount: _amountOrNull(_rentController),
      iptuAmount: _amountOrNull(_iptuController),
      condominiumAmount: _amountOrNull(_condoController),
      gasAmount: _amountOrNull(_gasController),
      energyAmount: _amountOrNull(_electricityController),
      waterAmount: _amountOrNull(_waterController),
      phoneAmount: _amountOrNull(_phoneInternetController),
      otherResidenceAmount: _amountOrNull(_financingController),
      foodAmount: _amountOrNull(_foodValueController),
      healthPlanAmount: _amountOrNull(_healthPlanController),
      otherHealthAmount: _amountOrNull(_otherHealthServicesController),
      otherHealthDescription:
          _textOrNull(_otherHealthServicesSpecifyController),
      chronicDiseaseAmount: _amountOrNull(_chronicDiseaseController),
      hasEducationSpending: education?.hasEducationSpending,
      educationSpendings: education?.educationSpendings ?? const [],
      schoolTransportType: education?.schoolTransportType,
      schoolTransportAmount:
          education?.schoolTransportType?.requiresAmount == true
              ? _amountOrNull(_educationValueController)
              : null,
      ipvaAmount: _amountOrNull(_ipvaController),
      carInsuranceAmount: _amountOrNull(_carInsuranceController),
      bankDebtsAmount: _amountOrNull(_bankLoansController),
      otherBankDebtsAmount: _amountOrNull(_loansOtherServicesController),
      otherBankDebtsDescription:
          _textOrNull(_loansOtherServicesDescribeController),
    );
  }

  double? _amountOrNull(TextEditingController controller) {
    final text = controller.text.trim();
    if (text.isEmpty) return null;
    return MoneyFormatter.parse(text);
  }

  String? _textOrNull(TextEditingController controller) {
    final text = controller.text.trim();
    return text.isEmpty ? null : text;
  }

  void _handleNext() {
    if (!DevNavigationOverrides.allowAdvanceWithoutFill &&
        !validateCurrentSubStep()) {
      return;
    }
    widget.onNext?.call();
  }

  void _notifyFormChanged() => widget.onFormChanged?.call();

  void _attachFormListeners(TextEditingController controller) {
    controller.addListener(_notifyFormChanged);
  }

  late final TextEditingController _rentController;
  late final TextEditingController _financingController;
  late final TextEditingController _iptuController;
  late final TextEditingController _condoController;
  late final TextEditingController _electricityController;
  late final TextEditingController _waterController;
  late final TextEditingController _gasController;
  late final TextEditingController _phoneInternetController;
  late final TextEditingController _foodValueController;
  late final TextEditingController _healthPlanController;
  late final TextEditingController _chronicDiseaseController;
  late final TextEditingController _otherHealthServicesController;
  late final TextEditingController _otherHealthServicesSpecifyController;
  late final TextEditingController _educationValueController;
  late final TextEditingController _ipvaController;
  late final TextEditingController _carInsuranceController;
  late final TextEditingController _vehicleFinancingController;
  late final TextEditingController _bankLoansController;
  late final TextEditingController _loansOtherServicesController;
  late final TextEditingController _loansOtherServicesDescribeController;

  @override
  void initState() {
    super.initState();
    _rentController = TextEditingController();
    _financingController = TextEditingController();
    _iptuController = TextEditingController();
    _condoController = TextEditingController();
    _electricityController = TextEditingController();
    _waterController = TextEditingController();
    _gasController = TextEditingController();
    _phoneInternetController = TextEditingController();
    _foodValueController = TextEditingController();
    _healthPlanController = TextEditingController();
    _chronicDiseaseController = TextEditingController();
    _otherHealthServicesController = TextEditingController();
    _otherHealthServicesSpecifyController = TextEditingController();
    _educationValueController = TextEditingController();
    _ipvaController = TextEditingController();
    _carInsuranceController = TextEditingController();
    _vehicleFinancingController = TextEditingController();
    _bankLoansController = TextEditingController();
    _loansOtherServicesController = TextEditingController();
    _loansOtherServicesDescribeController = TextEditingController();

    for (final controller in [
      _rentController,
      _financingController,
      _iptuController,
      _condoController,
      _electricityController,
      _waterController,
      _gasController,
      _phoneInternetController,
      _foodValueController,
      _healthPlanController,
      _chronicDiseaseController,
      _otherHealthServicesController,
      _otherHealthServicesSpecifyController,
      _educationValueController,
      _ipvaController,
      _carInsuranceController,
      _vehicleFinancingController,
      _bankLoansController,
      _loansOtherServicesController,
      _loansOtherServicesDescribeController,
    ]) {
      _attachFormListeners(controller);
    }
  }

  @override
  void dispose() {
    _rentController.dispose();
    _financingController.dispose();
    _iptuController.dispose();
    _condoController.dispose();
    _electricityController.dispose();
    _waterController.dispose();
    _gasController.dispose();
    _phoneInternetController.dispose();
    _foodValueController.dispose();
    _healthPlanController.dispose();
    _chronicDiseaseController.dispose();
    _otherHealthServicesController.dispose();
    _otherHealthServicesSpecifyController.dispose();
    _educationValueController.dispose();
    _ipvaController.dispose();
    _carInsuranceController.dispose();
    _vehicleFinancingController.dispose();
    _bankLoansController.dispose();
    _loansOtherServicesController.dispose();
    _loansOtherServicesDescribeController.dispose();
    super.dispose();
  }

  Widget _buildSubStepNavArrow({
    required IconData icon,
    required bool isEnabled,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isEnabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isEnabled ? AppColors.primary : AppColors.surface,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isEnabled ? Colors.white : AppColors.outline,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(i18n.expensesStepTitle, style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        Text(i18n.expensesStepDescription, style: AppTextStyles.bodyMedium),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Row(
            children: [
              _buildSubStepNavArrow(
                icon: Icons.arrow_back,
                isEnabled: widget.currentSubStep > 1,
                onTap: widget.onPrevious,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Center(
                  child: Text(
                    expensesSubStepNavTitle(widget.currentSubStep),
                    style: AppTextStyles.titleLarge,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildSubStepNavArrow(
                icon: Icons.arrow_forward,
                isEnabled: widget.currentSubStep < expensesSubStepCount &&
                    (DevNavigationOverrides.allowAdvanceWithoutFill ||
                        canAdvanceCurrentSubStep()),
                onTap: _handleNext,
              ),
            ],
          ),
        ),
        if (widget.currentSubStep >= 1 &&
            widget.currentSubStep <= expensesSubStepCount)
          IndexedStack(
            index: widget.currentSubStep - 1,
            sizing: StackFit.loose,
            children: [
              ExpensesHousingSubStep(
                rentController: _rentController,
                financingController: _financingController,
                iptuController: _iptuController,
                condoController: _condoController,
                electricityController: _electricityController,
                waterController: _waterController,
                gasController: _gasController,
                phoneInternetController: _phoneInternetController,
              ),
              ExpensesFoodSubStep(foodValueController: _foodValueController),
              ExpensesHealthSubStep(
                key: _healthSubStepKey,
                healthPlanController: _healthPlanController,
                chronicDiseaseController: _chronicDiseaseController,
                otherServicesController: _otherHealthServicesController,
                otherServicesSpecifyController:
                    _otherHealthServicesSpecifyController,
                onFormChanged: _notifyFormChanged,
              ),
              ExpensesEducationSubStep(
                key: _educationSubStepKey,
                educationValueController: _educationValueController,
                familyMembers: widget.familyMembers,
                onFormChanged: _notifyFormChanged,
              ),
              ExpensesAutomobileSubStep(
                ipvaController: _ipvaController,
                carInsuranceController: _carInsuranceController,
                vehicleFinancingController: _vehicleFinancingController,
              ),
              ExpensesLoansSubStep(
                key: _loansSubStepKey,
                bankLoansController: _bankLoansController,
                otherServicesController: _loansOtherServicesController,
                otherServicesDescribeController:
                    _loansOtherServicesDescribeController,
                onFormChanged: _notifyFormChanged,
              ),
            ],
          )
        else
          Center(
            child: Text(
              'Expenses - Substep ${widget.currentSubStep}',
              style: AppTextStyles.titleLarge,
            ),
          ),
      ],
    );
  }
}
