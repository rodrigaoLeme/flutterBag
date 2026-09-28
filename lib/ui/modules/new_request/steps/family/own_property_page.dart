import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../../../domain/entities/asset_type_entity.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/money_text_input_formatter.dart';
import '../../../../helpers/themes/themes.dart';

class OwnPropertyPage extends StatefulWidget {
  const OwnPropertyPage({
    super.key,
    this.initialType,
    this.initialAssetTypeId,
    this.initialInstallmentValue,
    this.initialAssetValue,
    this.assetTypes = const [],
  });

  final String? initialType;
  final int? initialAssetTypeId;
  final String? initialInstallmentValue;
  final String? initialAssetValue;
  final List<AssetTypeEntity> assetTypes;

  @override
  State<OwnPropertyPage> createState() => _OwnPropertyPageState();
}

class _OwnPropertyPageState extends State<OwnPropertyPage> {
  String? _selectedType;
  late final TextEditingController _installmentValueController;
  late final TextEditingController _assetValueController;

  AssetTypeEntity? _selectedAssetType;

  @override
  void initState() {
    super.initState();
    if (widget.initialAssetTypeId != null) {
      _selectedAssetType = widget.assetTypes.firstWhereOrNull(
        (t) => t.id == widget.initialAssetTypeId,
      );
    }

    _selectedType = widget.initialType;
    _installmentValueController = TextEditingController(
      text: widget.initialInstallmentValue ?? '',
    );
    _assetValueController = TextEditingController(
      text: widget.initialAssetValue ?? '',
    );
  }

  @override
  void dispose() {
    _installmentValueController.dispose();
    _assetValueController.dispose();
    super.dispose();
  }

  bool get _canSave {
    if (_selectedAssetType != null) {
      if (_assetValueController.text.trim().isNotEmpty) {
        if (_assetValueController.text != '0,00') {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _openTypeSelector() async {
    final i18n = AppI18n.current;
    final selected = await SearchableOptionsBottomSheet.show<AssetTypeEntity>(
        context: context,
        title: i18n.typeLabel,
        options: widget.assetTypes,
        searchHint: i18n.noticesTermsSearchHint,
        helperText: i18n.noticesTermsBottomSheetSearchHelp,
        emptyStateText: i18n.noticesTermsBottomSheetNoResults,
        closeTooltip: i18n.noticesTermsCloseAction,
        selectedValue: _selectedAssetType,
        labelBuilder: (t) => t.name ?? '',
        searchTextBuilder: (t) => t.name ?? '',
        showSearchInput: false);

    if (selected != null) {
      setState(() => _selectedAssetType = selected);
    }
  }

  void _saveAndReturn() {
    if (!_canSave) return;

    Navigator.of(context).pop({
      'type': _selectedAssetType?.name,
      'assetTypeId': _selectedAssetType?.id,
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
        title: Text(i18n.ownPropertyPageTitle),
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
              i18n.ownPropertyPageTitle,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              i18n.ownPropertyPageDescription,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 56,
              child: InkWell(
                onTap: _openTypeSelector,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: InputDecoration(
                    hintText: i18n.typeLabel,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(Icons.keyboard_arrow_down),
                  ),
                  child: Text(
                    _selectedAssetType?.name ?? i18n.typeLabel,
                    style: _selectedType == null
                        ? AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onSurface.withValues(alpha: 0.6),
                          )
                        : AppTextStyles.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 56,
              child: EbolsaTextField(
                controller: _installmentValueController,
                label: i18n.installmentValueLabel,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [MoneyTextInputFormatter()],
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
                inputFormatters: [MoneyTextInputFormatter()],
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
              i18n.savePropertyAction,
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
