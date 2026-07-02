import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../helpers/themes/themes.dart';
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

  const ExpensesStep({
    super.key,
    required this.currentSubStep,
    this.onPrevious,
    this.onNext,
  });

  @override
  State<ExpensesStep> createState() => ExpensesStepState();
}

class ExpensesStepState extends State<ExpensesStep> {
  final GlobalKey<ExpensesEducationSubStepState> _educationSubStepKey =
      GlobalKey<ExpensesEducationSubStepState>();

  bool validateCurrentSubStep() {
    if (widget.currentSubStep == 4) {
      return _educationSubStepKey.currentState?.validate() ?? false;
    }
    return true;
  }

  void _handleNext() {
    if (!validateCurrentSubStep()) return;
    widget.onNext?.call();
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
                isEnabled: widget.currentSubStep < expensesSubStepCount,
                onTap: _handleNext,
              ),
            ],
          ),
        ),
        if (widget.currentSubStep == 1)
          ExpensesHousingSubStep(
            rentController: _rentController,
            financingController: _financingController,
            iptuController: _iptuController,
            condoController: _condoController,
            electricityController: _electricityController,
            waterController: _waterController,
            gasController: _gasController,
            phoneInternetController: _phoneInternetController,
          )
        else if (widget.currentSubStep == 2)
          ExpensesFoodSubStep(foodValueController: _foodValueController)
        else if (widget.currentSubStep == 3)
          ExpensesHealthSubStep(
            healthPlanController: _healthPlanController,
            chronicDiseaseController: _chronicDiseaseController,
            otherServicesController: _otherHealthServicesController,
            otherServicesSpecifyController:
                _otherHealthServicesSpecifyController,
          )
        else if (widget.currentSubStep == 4)
          ExpensesEducationSubStep(
            key: _educationSubStepKey,
            educationValueController: _educationValueController,
          )
        else if (widget.currentSubStep == 5)
          ExpensesAutomobileSubStep(
            ipvaController: _ipvaController,
            carInsuranceController: _carInsuranceController,
            vehicleFinancingController: _vehicleFinancingController,
          )
        else if (widget.currentSubStep == 6)
          ExpensesLoansSubStep(
            bankLoansController: _bankLoansController,
            otherServicesController: _loansOtherServicesController,
            otherServicesDescribeController:
                _loansOtherServicesDescribeController,
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
