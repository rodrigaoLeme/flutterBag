import 'package:flutter/material.dart';

import '../../../../components/components.dart';
import '../../../../helpers/themes/themes.dart';
import '../family/member_registration_view_model.dart';
import 'ocupation_details_view_model.dart';

class OccupationPage extends StatefulWidget {
  const OccupationPage({
    super.key,
    this.initialPension = 0,
    this.initialPrevidencia = 0,
    this.initialInss = 0,
  });

  final int initialPension;
  final int initialPrevidencia;
  final int initialInss;

  @override
  State<OccupationPage> createState() => _OccupationPageState();
}

class _OccupationPageState extends State<OccupationPage> {
  late int _recebePensaoAlimenticia;
  late int _recebePrevidenciaPrivada;
  late int _recebeOutroBeneficioINSS;

  final List<String> _occupationOptions = const [
    'Nenhum',
    'Estudante',
    'Assalariado(a)',
    'Proprietário(a) ou Sócio(a) de Empresa',
    'Autônomo(a) ou Profissional Liberal',
    'Trabalhador(a) Informal',
    'Estagiário',
    'Estágio não Remunerado',
    'Aposentado e/ou Pensionista',
    'Beneficiário(a) de Prestação Continuada (BPC)',
    'Desempregado(a)',
    'Do Lar',
  ];

  String? _selectedOccupation;
  OccupationDetailsViewModel? _detailsViewModel;
  String? _genericLabel;
  TextEditingController? _incomeController;

  @override
  void initState() {
    super.initState();

    _recebePensaoAlimenticia = widget.initialPension;
    _recebePrevidenciaPrivada = widget.initialPrevidencia;
    _recebeOutroBeneficioINSS = widget.initialInss;
  }

  void _saveAndReturn() {
    final Map<String, dynamic> result = {
      'pension': _recebePensaoAlimenticia,
      'previdencia': _recebePrevidenciaPrivada,
      'inss': _recebeOutroBeneficioINSS,
      'occupation': _selectedOccupation,
    };

    if (_detailsViewModel != null) {
      result['occupationDetails'] =
          _detailsViewModel!.controllers.map((k, v) => MapEntry(k, v.text));
      result['monthlyIncome'] = _incomeController?.text;
    } else if (_genericLabel != null) {
      result['occupationDetails'] = {'label': _genericLabel};
      result['monthlyIncome'] = _incomeController?.text;
    }

    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _detailsViewModel?.dispose();
    _incomeController?.dispose();
    super.dispose();
  }

  Future<void> _openOccupationSelector() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _occupationOptions.length,
            itemBuilder: (context, index) {
              final option = _occupationOptions[index];
              return ListTile(
                dense: true,
                visualDensity: const VisualDensity(vertical: -2),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 2,
                ),
                title: Text(
                  option,
                  style: AppTextStyles.bodyMedium,
                ),
                onTap: () {
                  Navigator.pop(context, option);
                },
              );
            },
          ),
        );
      },
    );

    if (selected != null) {
      setState(() {
        _selectedOccupation = selected;
      });

      switch (selected) {
        case 'Estudante':
          _setDetailsViewModel(OccupationType.estudante);
          break;
        case 'Proprietário(a) ou Sócio(a) de Empresa':
          _setDetailsViewModel(OccupationType.propietario);
          break;
        case 'Assalariado(a)':
          _setDetailsViewModel(OccupationType.assalariado);
          break;
        case 'Autônomo(a) ou Profissional Liberal':
          _setDetailsViewModel(OccupationType.autonomo);
          break;
        case 'Trabalhador(a) Informal':
          _setDetailsViewModel(OccupationType.informal);
          break;
        case 'Estagiário':
          _setDetailsViewModel(OccupationType.estagiario);
          break;
        case 'Estágio não Remunerado':
          _setDetailsViewModel(OccupationType.estagioNaoRemunerado);
          break;
        case 'Aposentado e/ou Pensionista':
          _setDetailsViewModel(OccupationType.aposentado);
          break;
        case 'Beneficiário(a) de Prestação Continuada (BPC)':
          break;
        case 'Desempregado(a)':
          _setDetailsViewModel(OccupationType.desempregado);
          break;
        case 'Do Lar':
          _setDetailsViewModel(OccupationType.doLar);
          break;
        case 'Nenhum':
          _clearDetails();
          break;
        default:
          _setGeneric(selected);
      }
    }
  }

  void _setDetailsViewModel(OccupationType type) {
    _detailsViewModel?.dispose();
    _genericLabel = null;
    _incomeController?.dispose();
    _incomeController = TextEditingController();
    _detailsViewModel = OccupationDetailsViewModel(type: type);
  }

  void _setGeneric(String label) {
    _detailsViewModel?.dispose();
    _detailsViewModel = null;
    _genericLabel = label;
    _incomeController?.dispose();
    _incomeController = TextEditingController();
  }

  void _clearDetails() {
    _detailsViewModel?.dispose();
    _detailsViewModel = null;
    _genericLabel = null;
    _incomeController?.dispose();
    _incomeController = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Ocupação'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ocupação',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Agora nos informe algumas informações referente a ocupação e renda do membro familiar',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 56,
                    child: InkWell(
                      onTap: _openOccupationSelector,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          hintText: 'Selecione o tipo de ocupação',
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
                          suffixIcon: const Icon(
                            Icons.keyboard_arrow_down,
                          ),
                        ),
                        child: Text(
                          _selectedOccupation ?? 'Selecione o tipo de ocupação',
                          style: _selectedOccupation == null
                              ? AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.onSurface.withOpacity(0.6),
                                )
                              : AppTextStyles.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (_detailsViewModel != null) ...[
                    EbolsaImportantBanner(
                      title: _detailsViewModel!.title,
                      message: _detailsViewModel!.description,
                      backgroundColor: Colors.white,
                    ),
                    ..._detailsViewModel!.fieldHints.map((hint) {
                      final options = _detailsViewModel!.fieldOptions[hint];
                      if (options != null && options.isNotEmpty) {
                        // render dropdown
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            value: _detailsViewModel!
                                    .controllers[hint]!.text.isNotEmpty
                                ? _detailsViewModel!.controllers[hint]!.text
                                : null,
                            decoration: InputDecoration(
                              hintText: hint,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            items: options
                                .map((o) => DropdownMenuItem(
                                      value: o,
                                      child: Text(o),
                                    ))
                                .toList(),
                            onChanged: (v) {
                              setState(() {
                                _detailsViewModel!.controllers[hint]!.text =
                                    v ?? '';
                              });
                            },
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EbolsaTextField(
                          controller: _detailsViewModel!.controllers[hint]!,
                          label: hint,
                          hint: hint,
                          keyboardType: TextInputType.text,
                          borderRadius: 12.0,
                        ),
                      );
                    }),
                    if (_detailsViewModel!.type != OccupationType.estudante &&
                        _detailsViewModel!.type !=
                            OccupationType.estagioNaoRemunerado &&
                        _detailsViewModel!.type !=
                            OccupationType.desempregado &&
                        _detailsViewModel!.type != OccupationType.doLar)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: EbolsaTextField(
                          controller: _incomeController ??=
                              TextEditingController(),
                          label: 'Recebimento mensal em R\$',
                          hint: 'Recebimento mensal em R\$',
                          keyboardType: TextInputType.number,
                          borderRadius: 12.0,
                        ),
                      ),
                  ] else if (_genericLabel != null) ...[
                    EbolsaImportantBanner(
                      title: _genericLabel!,
                      message: '',
                      backgroundColor: Colors.white,
                    ),
                    // For generic labels, show monthly income input
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: EbolsaTextField(
                        controller: _incomeController ??=
                            TextEditingController(),
                        label: 'Recebimento mensal em R\$',
                        hint: 'Recebimento mensal em R\$',
                        keyboardType: TextInputType.number,
                        borderRadius: 12.0,
                      ),
                    ),
                    if (_detailsViewModel != null &&
                        _detailsViewModel!.showOptanteSimples) ...[
                      const SizedBox(height: 8),
                      Text('Optante Simples nacional?',
                          style: AppTextStyles.titleSmall),
                      Row(
                        children: ['Não', 'Sim'].map((label) {
                          final controller = _detailsViewModel!
                              .controllers['Optante Simples nacional?']!;
                          return Expanded(
                            child: ListTile(
                              title: Text(label),
                              leading: Radio<String>(
                                value: label,
                                groupValue: controller.text.isEmpty
                                    ? null
                                    : controller.text,
                                onChanged: (v) {
                                  setState(() {
                                    controller.text = v ?? '';
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],

                    if (_detailsViewModel != null &&
                        _detailsViewModel!.showMovimentacao) ...[
                      const SizedBox(height: 8),
                      Text(
                          'Houve alguma movimentação na sua empresa no último ano?',
                          style: AppTextStyles.titleSmall),
                      Row(
                        children: ['Não', 'Sim'].map((label) {
                          final controller = _detailsViewModel!
                              .controllers['Houve movimentacao?']!;
                          return Expanded(
                            child: ListTile(
                              title: Text(label),
                              leading: Radio<String>(
                                value: label,
                                groupValue: controller.text.isEmpty
                                    ? null
                                    : controller.text,
                                onChanged: (v) {
                                  setState(() {
                                    controller.text = v ?? '';
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                    if (_detailsViewModel != null &&
                        _detailsViewModel!.showUnemployed) ...[
                      const SizedBox(height: 8),
                      Text('Recebe seguro desemprego?',
                          style: AppTextStyles.titleSmall),
                      Row(
                        children: ['Não', 'Sim'].map((label) {
                          final controller = _detailsViewModel!
                              .controllers['Recebe seguro desemprego?']!;
                          return Expanded(
                            child: ListTile(
                              title: Text(label),
                              leading: Radio<String>(
                                value: label,
                                groupValue: controller.text.isEmpty
                                    ? null
                                    : controller.text,
                                onChanged: (v) {
                                  setState(() {
                                    controller.text = v ?? '';
                                  });
                                },
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 32,
        ),
        child: SizedBox(
          height: 56,
          child: ElevatedButton(
            onPressed: _saveAndReturn,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.dividerLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: Text(
              'Adicionar ocupação',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.outline,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
