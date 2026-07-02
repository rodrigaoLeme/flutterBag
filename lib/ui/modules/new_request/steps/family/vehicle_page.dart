import 'package:flutter/material.dart';

import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';

class VehiclePage extends StatefulWidget {
  const VehiclePage({
    super.key,
    this.initialBrand,
    this.initialModel,
    this.initialYear,
    this.initialInstallmentValue,
    this.initialAssetValue,
  });

  final String? initialBrand;
  final String? initialModel;
  final String? initialYear;
  final String? initialInstallmentValue;
  final String? initialAssetValue;

  @override
  State<VehiclePage> createState() => _VehiclePageState();
}

class _VehiclePageState extends State<VehiclePage> {
  late final TextEditingController _brandController;
  late final TextEditingController _modelController;
  late final TextEditingController _yearController;
  late final TextEditingController _installmentValueController;
  late final TextEditingController _assetValueController;

  @override
  void initState() {
    super.initState();
    _brandController = TextEditingController(text: widget.initialBrand ?? '');
    _modelController = TextEditingController(text: widget.initialModel ?? '');
    _yearController = TextEditingController(text: widget.initialYear ?? '');
    _installmentValueController = TextEditingController(
      text: widget.initialInstallmentValue ?? '',
    );
    _assetValueController = TextEditingController(
      text: widget.initialAssetValue ?? '',
    );
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _installmentValueController.dispose();
    _assetValueController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _brandController.text.trim().isNotEmpty &&
      _modelController.text.trim().isNotEmpty &&
      _yearController.text.trim().isNotEmpty &&
      _installmentValueController.text.trim().isNotEmpty &&
      _assetValueController.text.trim().isNotEmpty;

  void _saveAndReturn() {
    if (!_canSave) return;

    Navigator.of(context).pop({
      'brand': _brandController.text.trim(),
      'model': _modelController.text.trim(),
      'year': _yearController.text.trim(),
      'installmentValue': _installmentValueController.text.trim(),
      'assetValue': _assetValueController.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final i18n = AppI18n.current;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(i18n.vehiclePageTitle),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              i18n.vehiclePageTitle,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              i18n.vehiclePageDescription,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: EbolsaTextField(
                controller: _brandController,
                label: i18n.vehicleBrandLabel,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: EbolsaTextField(
                controller: _modelController,
                label: i18n.vehicleModelLabel,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: EbolsaTextField(
                controller: _yearController,
                label: i18n.vehicleYearLabel,
                keyboardType: TextInputType.number,
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: EbolsaTextField(
                controller: _installmentValueController,
                label: i18n.vehicleFinancingInstallmentLabel,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: EbolsaTextField(
                controller: _assetValueController,
                label: i18n.assetValueLabel,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                onChanged: (_) => setState(() {}),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _canSave ? _saveAndReturn : null,
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _canSave ? AppColors.primary : AppColors.dividerLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              i18n.saveVehicleAction,
              style: AppTextStyles.titleMedium.copyWith(
                color: _canSave ? Colors.white : AppColors.outline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
