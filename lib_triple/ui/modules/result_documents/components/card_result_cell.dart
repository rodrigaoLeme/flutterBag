import 'package:flutter/material.dart';

import '../../../../app/core/constants/process_type.dart';
import '../../../../presentation/presenters/result_documents/result_documents_view_model.dart';

class ResultCardCell extends StatefulWidget {
  final ResultStudentViewModel? viewModel;

  const ResultCardCell({
    super.key,
    required this.viewModel,
  });

  @override
  State<ResultCardCell> createState() => _ResultCardCellState();
}

class _ResultCardCellState extends State<ResultCardCell> {
  bool _isExpanded = false;

  String buildMensagem(ResultStudentViewModel? viewModel) {
    final bool? aprovado = viewModel?.approvedGrant?.approved;
    final int? percentual = viewModel?.approvedGrant?.grantedPercentage;
    final int anoProcesso = viewModel?.year ?? 2022;
    final String? limitDate = viewModel?.limitDateFormatted;

    final String prazoTexto =
        limitDate != null ? 'até a data $limitDate ou no próximo dia útil' : '';

    if (aprovado == true && percentual == 100) {
      return '''
Informamos que com base na análise do perfil socioeconômico e demais critérios estabelecidos pela entidade, a solicitação de Bolsa de Estudo para o ano letivo de $anoProcesso foi deferida com percentual de 100%.

Em consonância com o Edital, para receber o benefício supra, o responsável legal, deverá comparecer à secretaria escolar, ${prazoTexto.isNotEmpty ? '$prazoTexto, ' : ''}munido de todos os documentos necessários para efetivar a matrícula do bolsista, consoante aos prazos previstos no cronograma descrito no Edital. A não efetivação da matrícula do estudante, pelo responsável legal, cancela o processo de recebimento do benefício da bolsa de estudo.

Em caso de dúvida, entre em contato com a unidade escolar.
''';
    } else if (aprovado == true && percentual == 50) {
      return '''
Informamos que com base na análise do perfil socioeconômico e demais critérios estabelecidos pela entidade, a solicitação de Bolsa de Estudo para o ano letivo de $anoProcesso foi deferida com percentual de 50%.

Em consonância com o Edital, para receber o benefício supra, o responsável legal, deverá comparecer à secretaria escolar, ${prazoTexto.isNotEmpty ? '$prazoTexto, ' : ''}munido de todos os documentos necessários para efetivar a matrícula do bolsista, consoante aos prazos previstos no cronograma descrito no Edital. A não efetivação da matrícula do estudante, pelo responsável legal, cancela o processo de recebimento do benefício da bolsa de estudo.

Em caso de dúvida, entre em contato com a unidade escolar.
''';
    } else if (percentual == 0 || aprovado == false) {
      return '''
Informamos que com base na análise do perfil socioeconômico e demais critérios estabelecidos pela entidade, a solicitação de Bolsa de Estudo para o ano letivo de $anoProcesso foi indeferida.

Em caso de dúvida, entre em contato com a unidade escolar.
''';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool? aprovado;
    final int? percentual;
    final ProcessType tipoProcesso = widget.viewModel!.tipoProcesso;
    final String processoNome;
    final String resultRelease = widget.viewModel!.resultRelease;
    bool exibeMsg = true;
    String textoStatus = '';
    Color corStatus = Colors.transparent;

    switch (tipoProcesso) {
      case ProcessType.renewal:
        processoNome = 'Renovação';
        if (widget.viewModel?.approvedGrant != null) {
          aprovado = widget.viewModel?.approvedGrant?.approved;
          percentual = widget.viewModel?.approvedGrant?.grantedPercentage;
          final resultado = verificaAproved(aprovado, percentual);
          textoStatus = resultado[0];
          corStatus = resultado[1];
        } else {
          exibeMsg = !exibeMsg;
          aprovado = widget.viewModel?.currentGrant?.approved;
          percentual = widget.viewModel?.currentGrant?.grantedPercentage;
          if (widget.viewModel?.currentGrant?.grantedPercentage == null ||
              widget.viewModel?.currentGrant?.grantedPercentage == -1) {
            if (verificaData(resultRelease)) {
              textoStatus = 'Em Análise';
              corStatus = const Color(0xFFF2A600);
            }
          }
        }

      case ProcessType.fresh:
        processoNome = 'Novo';

        if (widget.viewModel?.approvedGrant != null) {
          aprovado = widget.viewModel?.approvedGrant?.approved;
          percentual = widget.viewModel?.approvedGrant?.grantedPercentage;
          final resultado = verificaAproved(aprovado, percentual);
          textoStatus = resultado[0];
          corStatus = resultado[1];
        } else {
          exibeMsg = !exibeMsg;
          aprovado = widget.viewModel?.currentGrant?.approved;
          percentual = widget.viewModel?.currentGrant?.grantedPercentage;
          if (widget.viewModel?.currentGrant?.grantedPercentage == null ||
              widget.viewModel?.currentGrant?.grantedPercentage == -2) {
            if (verificaData(resultRelease)) {
              textoStatus = 'Lista de Espera';
              corStatus = const Color(0xFFF2A600);
            }
          } else if (widget.viewModel?.currentGrant?.grantedPercentage == -1) {
            if (verificaData(resultRelease)) {
              textoStatus = 'Em Análise';
              corStatus = const Color(0xFFF2A600);
            }
          }
        }
    }

    final String mensagemCompleta = buildMensagem(widget.viewModel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.viewModel?.familyMember?.name ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003366),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 16),
            if (textoStatus.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: corStatus.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  textoStatus.toUpperCase(),
                  style: TextStyle(
                    color: corStatus,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: exibeMsg
              ? () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Colégio ${widget.viewModel?.school?.name}\n'
                'Curso: ${widget.viewModel?.academicCourse?.name}\n'
                'Ano Letivo: ${widget.viewModel?.year ?? 2022}\n'
                'Processo: ${widget.viewModel!.academicCourse!.course!.courseLevelLabel} - $processoNome - (${widget.viewModel?.registerStartFormatted}  à ${widget.viewModel?.registerEndFormatted})',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff758EB3),
                ),
              ),
              if (exibeMsg) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _isExpanded ? 'Ver menos' : 'Ver mais',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF003366),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 400),
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF003366),
                        size: 18,
                      ),
                    ),
                  ],
                )
              ]
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (exibeMsg)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded && exibeMsg
                ? Card(
                    elevation: 0,
                    color: const Color(0xffF5F5F5),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        mensagemCompleta,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xff56595D),
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
      ],
    );
  }

  bool verificaData(String resultRelease) {
    DateTime dataDoJson = DateTime.parse(resultRelease);
    DateTime dataAtual = DateTime.now();

    if (dataAtual.isAfter(dataDoJson) ||
        dataAtual.isAtSameMomentAs(dataDoJson)) {
      return true;
    }
    return false;
  }

  List<dynamic> verificaAproved(bool? aproved, int? percentual) {
    if (aproved == true && (percentual ?? 0) > 0) {
      return ['Deferido $percentual%', const Color(0xff00A357)];
    } else {
      return ['Indeferido', const Color(0xffE62020)];
    }
  }
}
