import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../../domain/entities/enrollment_enums.dart';
import '../../../../../main/i18n/app_i18n.dart';
import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';

class HousingStep extends StatefulWidget {
  final int currentSubStep;
  final TextEditingController cepController;
  final TextEditingController numberController;
  final TextEditingController complementController;
  final TextEditingController addressController;
  final TextEditingController neighborhoodController;
  final TextEditingController cityController;
  final ValueListenable<String?> stateListenable;
  final ValueListenable<String?> residenceAreaListenable;
  final ValueListenable<ResidenceType?> housingTypeListenable;
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String> onResidenceAreaChanged;
  final ValueChanged<ResidenceType?> onHousingTypeChanged;
  final Future<void> Function(String cep)? onZipCodeComplete;
  final VoidCallback? onClearAddressFields;

  final String? cepError;
  final String? numberError;
  final String? addressError;
  final String? neighborhoodError;
  final String? cityError;
  final String? stateError;
  final String? residenceAreaError;
  final String? housingTypeError;

  const HousingStep({
    super.key,
    required this.currentSubStep,
    required this.cepController,
    required this.numberController,
    required this.complementController,
    required this.addressController,
    required this.neighborhoodController,
    required this.cityController,
    required this.stateListenable,
    required this.residenceAreaListenable,
    required this.housingTypeListenable,
    required this.onStateChanged,
    required this.onResidenceAreaChanged,
    required this.onHousingTypeChanged,
    this.onZipCodeComplete,
    this.onClearAddressFields,
    this.cepError,
    this.numberError,
    this.addressError,
    this.neighborhoodError,
    this.cityError,
    this.stateError,
    this.residenceAreaError,
    this.housingTypeError,
  });

  @override
  State<HousingStep> createState() => _HousingStepState();
}

class _HousingStepState extends State<HousingStep> {
  final _cepMask = MaskTextInputFormatter(
    mask: '#####-###',
    filter: {'#': RegExp(r'\d')},
  );

  @override
  void initState() {
    super.initState();
    widget.cepController.addListener(_onCepChanged);
  }

  @override
  void dispose() {
    widget.cepController.removeListener(_onCepChanged);
    super.dispose();
  }

  void _onCepChanged() {
    final clean = widget.cepController.text.replaceAll(RegExp(r'\D'), '');

    if (clean.length < 8) {
      widget.onClearAddressFields?.call();
    }

    if (clean.length == 8) {
      widget.onZipCodeComplete?.call(clean);
    }
  }

  Future<void> _openHousingTypeSelector() async {
    final appStrings = AppI18n.current;
    final options = ResidenceType.values.toList();

    final current = widget.housingTypeListenable.value;
    final selected = await SearchableOptionsBottomSheet.show<ResidenceType>(
      context: context,
      title: appStrings.housingGroupQuestion,
      options: options,
      searchHint: appStrings.noticesTermsSearchHint,
      helperText: '',
      emptyStateText: appStrings.noticesTermsBottomSheetNoResults,
      closeTooltip: appStrings.noticesTermsCloseAction,
      selectedValue: current,
      labelBuilder: (item) => item.label,
      searchTextBuilder: (item) => item.label,
    );
    if (selected != null) {
      widget.onHousingTypeChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(appStrings.housingStepResidenceTitle,
            style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        Text(
          appStrings.housingStepResidenceDescription,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 16),

        // CEP e Número
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EbolsaTextField(
                controller: widget.cepController,
                label: appStrings.addressCepLabel,
                keyboardType: TextInputType.number,
                inputFormatters: [_cepMask],
                borderRadius: 16,
                borderWidth: 1,
                borderColor: AppColors.secondary,
                errorText: widget.cepError,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: EbolsaTextField(
                controller: widget.numberController,
                label: appStrings.addressNumberLabel,
                keyboardType: TextInputType.number,
                borderRadius: 16,
                borderWidth: 1,
                borderColor: AppColors.secondary,
                errorText: widget.numberError,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Complemento
        EbolsaTextField(
          controller: widget.complementController,
          label: appStrings.addressComplementLabel,
          borderRadius: 16,
          borderWidth: 1,
          borderColor: AppColors.secondary,
        ),
        const SizedBox(height: 12),

        // Endereço
        EbolsaTextField(
          controller: widget.addressController,
          label: appStrings.addressLabel,
          borderRadius: 16,
          borderWidth: 1,
          borderColor: AppColors.secondary,
          enabled: false,
          errorText: widget.addressError,
        ),
        const SizedBox(height: 12),

        // Bairro
        EbolsaTextField(
          controller: widget.neighborhoodController,
          label: appStrings.addressNeighborhoodLabel,
          borderRadius: 16,
          borderWidth: 1,
          borderColor: AppColors.secondary,
          enabled: false,
          errorText: widget.neighborhoodError,
        ),
        const SizedBox(height: 12),

        // Cidade / Estado
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: EbolsaTextField(
                controller: widget.cityController,
                label: appStrings.addressCityLabel,
                borderRadius: 16,
                borderWidth: 1,
                borderColor: AppColors.secondary,
                enabled: false,
                errorText: widget.cityError,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              child: ValueListenableBuilder<String?>(
                valueListenable: widget.stateListenable,
                builder: (context, stateVal, _) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: appStrings.addressStateLabel,
                      errorText: widget.stateError,
                      enabled: false,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.secondary,
                          width: 1,
                        ),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.borderLight,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      stateVal ?? '',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Tipo de área
        Text(appStrings.housingTitle, style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        Text(appStrings.housingAreaQuestion, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        ValueListenableBuilder<String?>(
          valueListenable: widget.residenceAreaListenable,
          builder: (context, residenceVal, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioGroup<String>(
                  groupValue: residenceVal,
                  onChanged: (value) {
                    if (value != null) widget.onResidenceAreaChanged(value);
                  },
                  child: Column(
                    children: ResidenceAreaType.values.map((type) {
                      return InkWell(
                        onTap: () => widget.onResidenceAreaChanged(type.label),
                        child: Row(
                          children: [
                            Radio<String>(
                              value: type.label,
                            ),
                            Text(type.label, style: AppTextStyles.bodyMedium),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (widget.residenceAreaError != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 12, top: 4),
                    child: Text(
                      widget.residenceAreaError!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),

        // Tipo de imóvel
        Text(appStrings.housingGroupQuestion, style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        ValueListenableBuilder<ResidenceType?>(
          valueListenable: widget.housingTypeListenable,
          builder: (context, housingVal, _) {
            final appStrings = AppI18n.current;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: _openHousingTypeSelector,
                  borderRadius: BorderRadius.circular(16),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      hintText: appStrings.housingTypeHint,
                      errorText: widget.housingTypeError,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 18,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppColors.secondary,
                          width: 1,
                        ),
                      ),
                      suffixIcon: const Icon(Icons.keyboard_arrow_down_rounded),
                    ),
                    child: Text(
                      housingVal?.label ?? appStrings.housingTypeHint,
                      style: housingVal == null
                          ? AppTextStyles.ebolsaBodyLargeOutline
                          : AppTextStyles.ebolsaBodyLarge,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
