import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../domain/entities/family_member_entity.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../../presentation/presenters/member_registration/stream_member_registration_presenter.dart';
import '../../../../components/components.dart';
import '../../../../components/ebolsa_step_header.dart';
import '../../../../helpers/themes/themes.dart';
import '../../dev_navigation_overrides.dart';
import '../../widgets/scholarship_step_indicator.dart';
import '../ocupation/occupation_page.dart';
import 'financial_investment_page.dart';
import 'member_registration_presenter.dart';
import 'member_registration_sub_step_config.dart';
import 'member_registration_view_model.dart';
import 'other_income_none_confirmation_page.dart';
import 'other_income_source_page.dart';
import 'own_property_page.dart';
import 'sub_steps/member_registration_assets_sub_step.dart';
import 'sub_steps/member_registration_family_members_sub_step.dart';
import 'sub_steps/member_registration_occupation_sub_step.dart';
import 'sub_steps/member_registration_other_income_sub_step.dart';
import 'sub_steps/member_registration_personal_data_sub_step.dart';
import 'sub_steps/member_registration_summary_sub_step.dart';
import 'vehicle_page.dart';
import 'widgets/member_registration_dialogs.dart';
import 'widgets/member_registration_footer.dart';
import 'widgets/member_registration_sub_step_nav.dart';

const String kAdvanceToExpensesResult = 'advanceToExpenses';

class MemberRegistrationPage extends StatefulWidget {
  const MemberRegistrationPage({
    super.key,
    this.presenter,
    required this.scholarshipId,
    required this.processPeriodId,
    required this.initialFamilyMembers,
  });

  final MemberRegistrationPresenter? presenter;
  final String scholarshipId;
  final String processPeriodId;
  final List<FamilyMemberEntity> initialFamilyMembers;

  @override
  State<MemberRegistrationPage> createState() => _MemberRegistrationPageState();
}

class _MemberRegistrationPageState extends State<MemberRegistrationPage> {
  late final MemberRegistrationPresenter _presenter;
  late final ScrollController _scrollController;
  StreamSubscription<int>? _subStepSubscription;
  int _currentSubStep = 1;

  MemberRegistrationViewModel get _vm => _presenter.viewModel;

  @override
  void initState() {
    super.initState();
    _presenter = widget.presenter ?? StreamMemberRegistrationPresenter();
    _currentSubStep = _presenter.currentSubStep;
    _scrollController = ScrollController();
    if (_presenter is StreamMemberRegistrationPresenter) {
      _subStepSubscription = (_presenter).currentSubStepStream.listen((step) {
        if (mounted) setState(() => _currentSubStep = step);
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _subStepSubscription?.cancel();
    if (widget.presenter == null) {
      _presenter.dispose();
    }
    super.dispose();
  }

  Future<void> _selectDate() async {
    DateTime initial = DateTime.now().subtract(const Duration(days: 365 * 18));
    if (_vm.dobController.text.trim().isNotEmpty) {
      try {
        initial = DateFormat('dd/MM/yyyy').parse(_vm.dobController.text);
      } catch (_) {}
      if (initial.isAfter(DateTime.now())) {
        initial = DateTime.now();
      }
    }

    final picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendar,
    );

    if (picked != null) _vm.setDob(picked);
  }

  Future<void> _openNationalitySelector() async {
    final appStrings = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: appStrings.nationalityLabel,
      options: _vm.nationalityOptions,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _vm.nacionalityController.text.isNotEmpty
          ? _vm.nacionalityController.text
          : null,
    );
    if (selected != null) _vm.setNationality(selected);
  }

  Future<void> _openPcdSelector() async {
    final appStrings = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<String>(
      context: context,
      title: appStrings.pcdLabel,
      options: _vm.pcdOptions,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: appStrings.noticesTermsBottomSheetSearchHelp,
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: _vm.selectedPcd,
    );
    if (selected != null) _vm.setSelectedPcd(selected);
  }

  Future<void> _openOccupationPage({Map<String, dynamic>? initial}) async {
    final res = await Navigator.of(context).push<Map<dynamic, dynamic>>(
      MaterialPageRoute(
        builder: (_) => OccupationPage(
          initialPension: _vm.recebePensaoAlimenticia ?? 0,
          initialPrevidencia: _vm.recebePrevidenciaPrivada ?? 0,
          initialInss: _vm.recebeOutroBeneficioINSS ?? 0,
          initialOccupation: initial?['occupation'] as String?,
          initialOccupationDetails: initial?['occupationDetails'] != null
              ? Map<String, String>.from(
                  initial!['occupationDetails'] as Map,
                )
              : null,
          initialMonthlyIncome: initial?['monthlyIncome']?.toString() ??
              initial?['headerTitle']?.toString(),
        ),
      ),
    );
    if (res == null || !mounted) return;
    if (initial != null) {
      final index = _vm.addedOccupations.indexOf(initial);
      if (index >= 0) _vm.updateOccupationAt(index, res);
    } else {
      _vm.applyOccupationResult(res);
    }
  }

  Future<void> _deleteOccupation(int index) async {
    final name = _vm.addedOccupations[index]['occupation']?.toString() ??
        'tipo da ocupação';
    final confirmed =
        await MemberRegistrationDialogs.showOccupationDeleteDialog(
      context,
      name,
    );
    if (confirmed == true) _vm.removeOccupationAt(index);
  }

  Future<void> _openOtherIncomeSourcePage(
      {Map<String, dynamic>? initial}) async {
    final res = await Navigator.of(context).push<Map<dynamic, dynamic>>(
      MaterialPageRoute(
        builder: (_) => OtherIncomeSourcePage(
          initialType: initial?['type'] as String?,
          initialMonthlyIncome: initial?['monthlyIncome']?.toString(),
          initialDescription: initial?['description']?.toString(),
        ),
      ),
    );
    if (res == null || !mounted) return;
    if (initial != null) {
      final index = _vm.addedOtherIncomes.indexOf(initial);
      if (index >= 0) _vm.updateOtherIncomeAt(index, res);
    } else {
      _vm.addOtherIncome(res);
    }
  }

  Future<void> _deleteOtherIncome(int index) async {
    final name =
        _vm.addedOtherIncomes[index]['type']?.toString() ?? 'fonte de renda';
    final confirmed =
        await MemberRegistrationDialogs.showOtherIncomeDeleteDialog(
      context,
      name,
    );
    if (confirmed == true) _vm.removeOtherIncomeAt(index);
  }

  Future<bool> _confirmNoOtherIncome() async {
    final confirmed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => const OtherIncomeNoneConfirmationPage(),
      ),
    );
    return confirmed == true;
  }

  Future<void> _openOwnPropertyForm({int? editIndex}) async {
    Map<String, dynamic>? initial;
    if (editIndex != null) initial = _vm.addedProperties[editIndex];

    final res = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => OwnPropertyPage(
          initialType: initial?['type'] as String?,
          initialInstallmentValue: initial?['installmentValue'] as String?,
          initialAssetValue: initial?['assetValue'] as String?,
        ),
      ),
    );
    if (res == null || !mounted) return;
    _vm.upsertProperty(res, editIndex: editIndex);
  }

  Future<void> _openFinancialInvestmentForm({int? editIndex}) async {
    Map<String, dynamic>? initial;
    if (editIndex != null) initial = _vm.addedInvestments[editIndex];

    final res = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => FinancialInvestmentPage(
          initialType: initial?['type'] as String?,
          initialValue: initial?['value'] as String?,
        ),
      ),
    );
    if (res == null || !mounted) return;
    _vm.upsertInvestment(res, editIndex: editIndex);
  }

  Future<void> _openVehicleForm({int? editIndex}) async {
    Map<String, dynamic>? initial;
    if (editIndex != null) initial = _vm.addedVehicles[editIndex];

    final res = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(
        builder: (_) => VehiclePage(
          initialBrand: initial?['brand'] as String?,
          initialModel: initial?['model'] as String?,
          initialYear: initial?['year'] as String?,
          initialInstallmentValue: initial?['installmentValue'] as String?,
          initialAssetValue: initial?['assetValue'] as String?,
        ),
      ),
    );
    if (res == null || !mounted) return;
    _vm.upsertVehicle(res, editIndex: editIndex);
  }

  void _showFamilyInfo() {
    EbolsaInfoBottomSheet.show(
      context,
      iconData: Icons.info_outline,
      iconColor: AppColors.warning,
      sections: [
        EbolsaInfoSection(
          title: AppI18n.current.familyInfoGroupTitle,
          description: AppI18n.current.familyInfoGroupDescription,
        ),
        EbolsaInfoSection(
          title: AppI18n.current.familyInfoIncomeTitle,
          description: AppI18n.current.familyInfoIncomeDescription,
        ),
        EbolsaInfoSection(
          title: AppI18n.current.familyInfoKinshipTitle,
          description: AppI18n.current.familyInfoKinshipDescription,
        ),
      ],
      closeLabel: AppI18n.current.noticesTermsCloseAction,
    );
  }

  Future<void> _onFooterBack() async {
    if (_currentSubStep == 1) {
      Navigator.of(context).pop();
      return;
    }
    if (_currentSubStep == 6) {
      final confirmed =
          await MemberRegistrationDialogs.showSummaryBackDialog(context);
      if (confirmed == true && mounted) _presenter.decrementSubStep();
      return;
    }
    _presenter.decrementSubStep();
  }

  void _advanceFromOtherIncome() {
    if (_vm.hasCurrentMemberToCommit) {
      _presenter.commitMemberAndAdvance();
      return;
    }
    _presenter.incrementSubStep();
  }

  Future<void> _onFooterAdvance() async {
    if (_currentSubStep == 3) {
      _advanceFromOtherIncome();
      return;
    }

    if (DevNavigationOverrides.allowAdvanceWithoutFill) {
      if (_currentSubStep < _presenter.totalSubSteps) {
        _presenter.incrementSubStep();
        return;
      }
      if (!mounted) return;
      Navigator.of(context).pop(kAdvanceToExpensesResult);
      return;
    }

    if (!_presenter.canAdvance) return;

    if (_currentSubStep == 4) {
      final confirmed =
          await MemberRegistrationDialogs.showFamilyMembersConfirmDialog(
              context, _vm);
      if (confirmed == true && mounted) _presenter.incrementSubStep();
      return;
    }

    if (_currentSubStep < _presenter.totalSubSteps) {
      _presenter.incrementSubStep();
      return;
    }

    if (!mounted) return;
    Navigator.of(context).pop(kAdvanceToExpensesResult);
  }

  Future<void> _onNavForward() async {
    if (_currentSubStep == 3) {
      _advanceFromOtherIncome();
      return;
    }

    if (DevNavigationOverrides.allowAdvanceWithoutFill) {
      if (_currentSubStep < _presenter.totalSubSteps) {
        _presenter.incrementSubStep();
      }
      return;
    }

    if (_currentSubStep == 4) {
      if (!_presenter.canAdvance) return;
      final confirmed =
          await MemberRegistrationDialogs.showFamilyMembersConfirmDialog(
              context, _vm);
      if (confirmed == true && mounted) _presenter.incrementSubStep();
      return;
    }
    if (_presenter.canAdvance) _presenter.incrementSubStep();
  }

  Widget _buildStepHeader() {
    final config = memberRegistrationSubStepConfig(_currentSubStep);

    return EbolsaStepHeader(
      key: ValueKey('member-registration-header-$_currentSubStep'),
      title: config.headerTitle,
      description: config.headerDescription,
      descriptionWidget: config.headerDescriptionWidget,
      trailing: config.showFamilyInfoIcon
          ? GestureDetector(
              onTap: _showFamilyInfo,
              child: const Icon(
                Icons.info_outline,
                color: AppColors.warning,
                size: 24,
              ),
            )
          : null,
    );
  }

  Widget _buildCurrentSubStep() {
    switch (_currentSubStep) {
      case 1:
        return MemberRegistrationPersonalDataSubStep(
          vm: _vm,
          onSelectDate: _selectDate,
          onOpenNationality: _openNationalitySelector,
          onOpenPcd: _openPcdSelector,
        );
      case 2:
        return MemberRegistrationOccupationSubStep(
          vm: _vm,
          onAddOccupation: () => _openOccupationPage(),
          onEditOccupation: (i) =>
              _openOccupationPage(initial: _vm.addedOccupations[i]),
          onDeleteOccupation: _deleteOccupation,
        );
      case 3:
        return MemberRegistrationOtherIncomeSubStep(
          vm: _vm,
          onAddOtherIncome: () => _openOtherIncomeSourcePage(),
          onEditOtherIncome: (i) =>
              _openOtherIncomeSourcePage(initial: _vm.addedOtherIncomes[i]),
          onDeleteOtherIncome: _deleteOtherIncome,
          onConfirmNoOtherIncome: _confirmNoOtherIncome,
        );
      case 4:
        return MemberRegistrationFamilyMembersSubStep(
          vm: _vm,
          onAddMember: () {
            _vm.resetMemberForm();
            _presenter.goToSubStep(1);
          },
          onEditMember: (_) => _presenter.goToSubStep(1),
          onDeleteMember: _vm.removeFamilyMemberAt,
        );
      case 5:
        return MemberRegistrationAssetsSubStep(
          vm: _vm,
          onOpenProperty: _openOwnPropertyForm,
          onOpenInvestment: _openFinancialInvestmentForm,
          onOpenVehicle: _openVehicleForm,
          onDeleteProperty: _vm.removePropertyAt,
          onDeleteInvestment: _vm.removeInvestmentAt,
          onDeleteVehicle: _vm.removeVehicleAt,
        );
      case 6:
        return MemberRegistrationSummarySubStep(vm: _vm);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _vm,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(AppI18n.current.memberRegistrationAppBarTitle),
            centerTitle: true,
            leading: const BackButton(color: Colors.white),
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: ScholarshipStepIndicator(
                    currentStep: 2,
                    completedStep: 2,
                    onStepTap: (_) {},
                  ),
                ),
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    thumbVisibility: true,
                    thickness: 2,
                    radius: const Radius.circular(8),
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildStepHeader(),
                          MemberRegistrationSubStepNav(
                            navTitle: memberRegistrationSubStepConfig(
                              _currentSubStep,
                            ).navTitle,
                            canGoBack: _currentSubStep > 1,
                            canGoForward:
                                _currentSubStep < _presenter.totalSubSteps &&
                                    (DevNavigationOverrides
                                            .allowAdvanceWithoutFill ||
                                        _presenter.canAdvance),
                            onBack: _onFooterBack,
                            onForward: _onNavForward,
                          ),
                          _buildCurrentSubStep(),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                MemberRegistrationFooter(
                  canAdvance: DevNavigationOverrides.allowAdvanceWithoutFill ||
                      _presenter.canAdvance,
                  showBack: _currentSubStep != 3,
                  advanceLabel: _currentSubStep == 3
                      ? AppI18n.current.saveMemberAction
                      : null,
                  onBack: _onFooterBack,
                  onAdvance: _onFooterAdvance,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
