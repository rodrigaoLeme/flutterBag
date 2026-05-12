import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';
import '../../../../../main/i18n/app_i18n.dart';

class HousingStep extends StatelessWidget {
  final int currentSubStep;
  final TextEditingController cepController;
  final TextEditingController numberController;
  final TextEditingController complementController;
  final TextEditingController addressController;
  final TextEditingController neighborhoodController;
  final TextEditingController cityController;
  final ValueListenable<String?> stateListenable;
  final ValueListenable<String> residenceAreaListenable;
  final ValueListenable<String?> housingTypeListenable;
  final ValueChanged<String?> onStateChanged;
  final ValueChanged<String> onResidenceAreaChanged;
  final ValueChanged<String?> onHousingTypeChanged;

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
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        Text(AppI18n.current.housingStepResidenceTitle,
            style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        Text(
          AppI18n.current.housingStepResidenceDescription,
          style: AppTextStyles.bodyMedium,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: EbolsaTextField(
                controller: cepController,
                label: AppI18n.current.addressCepLabel,
                keyboardType: TextInputType.number,
                borderRadius: 16,
                borderWidth: 1,
                borderColor: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 120,
              child: EbolsaTextField(
                controller: numberController,
                label: AppI18n.current.addressNumberLabel,
                keyboardType: TextInputType.number,
                borderRadius: 16,
                borderWidth: 1,
                borderColor: AppColors.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        EbolsaTextField(
          controller: complementController,
          label: AppI18n.current.addressComplementLabel,
          borderRadius: 16,
          borderWidth: 1,
          borderColor: AppColors.secondary,
        ),
        const SizedBox(height: 12),
        EbolsaTextField(
          controller: addressController,
          label: AppI18n.current.addressLabel,
          borderRadius: 16,
          borderWidth: 1,
          borderColor: AppColors.secondary,
        ),
        const SizedBox(height: 12),
        EbolsaTextField(
          controller: neighborhoodController,
          label: AppI18n.current.addressNeighborhoodLabel,
          borderRadius: 16,
          borderWidth: 1,
          borderColor: AppColors.secondary,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: EbolsaTextField(
                controller: cityController,
                label: AppI18n.current.addressCityLabel,
                borderRadius: 16,
                borderWidth: 1,
                borderColor: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 12),
            SizedBox(
              width: 140,
              child: ValueListenableBuilder<String?>(
                valueListenable: stateListenable,
                builder: (context, stateVal, _) {
                  return DropdownButtonFormField<String>(
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: AppColors.textPrimaryLight),
                    decoration: InputDecoration(
                      labelText: AppI18n.current.addressStateLabel,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: AppColors.secondary, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide:
                            BorderSide(color: AppColors.secondary, width: 1),
                      ),
                    ),
                    value: stateVal,
                    items: const [
                      DropdownMenuItem(value: 'AC', child: Text('AC')),
                      DropdownMenuItem(value: 'AL', child: Text('AL')),
                      DropdownMenuItem(value: 'AP', child: Text('AP')),
                      DropdownMenuItem(value: 'AM', child: Text('AM')),
                      DropdownMenuItem(value: 'BA', child: Text('BA')),
                      DropdownMenuItem(value: 'CE', child: Text('CE')),
                      DropdownMenuItem(value: 'DF', child: Text('DF')),
                      DropdownMenuItem(value: 'ES', child: Text('ES')),
                      DropdownMenuItem(value: 'GO', child: Text('GO')),
                      DropdownMenuItem(value: 'MA', child: Text('MA')),
                      DropdownMenuItem(value: 'MT', child: Text('MT')),
                      DropdownMenuItem(value: 'MS', child: Text('MS')),
                      DropdownMenuItem(value: 'MG', child: Text('MG')),
                      DropdownMenuItem(value: 'PA', child: Text('PA')),
                      DropdownMenuItem(value: 'PB', child: Text('PB')),
                      DropdownMenuItem(value: 'PR', child: Text('PR')),
                      DropdownMenuItem(value: 'PE', child: Text('PE')),
                      DropdownMenuItem(value: 'PI', child: Text('PI')),
                      DropdownMenuItem(value: 'RJ', child: Text('RJ')),
                      DropdownMenuItem(value: 'RN', child: Text('RN')),
                      DropdownMenuItem(value: 'RS', child: Text('RS')),
                      DropdownMenuItem(value: 'RO', child: Text('RO')),
                      DropdownMenuItem(value: 'RR', child: Text('RR')),
                      DropdownMenuItem(value: 'SC', child: Text('SC')),
                      DropdownMenuItem(value: 'SP', child: Text('SP')),
                      DropdownMenuItem(value: 'SE', child: Text('SE')),
                      DropdownMenuItem(value: 'TO', child: Text('TO')),
                    ],
                    onChanged: onStateChanged,
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(AppI18n.current.housingTitle, style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        Text(AppI18n.current.housingAreaQuestion,
            style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        ValueListenableBuilder<String>(
          valueListenable: residenceAreaListenable,
          builder: (context, residenceVal, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppI18n.current.housingAreaUrban),
                  value: AppI18n.current.housingAreaUrban,
                  groupValue: residenceVal,
                  onChanged: (v) => onResidenceAreaChanged(
                      v ?? AppI18n.current.housingAreaUrban),
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppI18n.current.housingAreaRural),
                  value: AppI18n.current.housingAreaRural,
                  groupValue: residenceVal,
                  onChanged: (v) => onResidenceAreaChanged(
                      v ?? AppI18n.current.housingAreaRural),
                ),
                RadioListTile<String>(
                  contentPadding: EdgeInsets.zero,
                  title: Text(AppI18n.current.housingAreaVulnerability),
                  value: AppI18n.current.housingAreaVulnerability,
                  groupValue: residenceVal,
                  onChanged: (v) => onResidenceAreaChanged(
                      v ?? AppI18n.current.housingAreaVulnerability),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Text(AppI18n.current.housingGroupQuestion,
            style: AppTextStyles.bodyMedium),
        const SizedBox(height: 8),
        ValueListenableBuilder<String?>(
          valueListenable: housingTypeListenable,
          builder: (context, housingVal, _) {
            return DropdownButtonFormField<String>(
              style: AppTextStyles.bodyLarge
                  .copyWith(color: AppColors.textPrimaryLight),
              decoration: InputDecoration(
                hintText: AppI18n.current.housingTypeHint,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.secondary, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: AppColors.secondary, width: 1),
                ),
              ),
              value: housingVal,
              items: [
                DropdownMenuItem(
                    value: AppI18n.current.housingTypeAlugada,
                    child: Text(AppI18n.current.housingTypeAlugada)),
                DropdownMenuItem(
                    value: AppI18n.current.housingTypeCedida,
                    child: Text(AppI18n.current.housingTypeCedida)),
                DropdownMenuItem(
                    value: AppI18n.current.housingTypeFinanciada,
                    child: Text(AppI18n.current.housingTypeFinanciada)),
                DropdownMenuItem(
                    value: AppI18n.current.housingTypePropria,
                    child: Text(AppI18n.current.housingTypePropria)),
              ],
              onChanged: onHousingTypeChanged,
            );
          },
        ),
      ],
    );
  }
}
