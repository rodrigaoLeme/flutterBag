import 'package:flutter/material.dart';

import '../family/member_registration_view_model.dart';

class OccupationDetailsViewModel {
  OccupationDetailsViewModel({required this.type}) {
    _init();
  }

  final OccupationType type;

  late final List<String> fieldHints;
  final Map<String, TextEditingController> controllers = {};

  final Map<String, List<String>> fieldOptions = {};

  bool showOptanteSimples = false;
  bool showMovimentacao = false;
  bool showUnemployed = false;

  String get title {
    switch (type) {
      case OccupationType.estudante:
        return 'Estudante';
      case OccupationType.assalariado:
        return 'Assalariado(a)';
      case OccupationType.propietario:
        return 'Proprietário(a) ou Sócio(a) de Empresa';
      case OccupationType.autonomo:
        return 'Autônomo(a) ou Profissional Liberal';
      case OccupationType.informal:
        return 'Trabalhador(a) Informal';
      case OccupationType.estagiario:
        return 'Estagiário';
      case OccupationType.estagioNaoRemunerado:
        return 'Estágio Não Remunerado';
      case OccupationType.aposentado:
        return 'Aposentado e/ou Pensionista';
      case OccupationType.beneficiario:
        return 'Beneficiário(a) de Prestação Continuada (BPC)';
      case OccupationType.desempregado:
        return 'Desempregado(a)';
      case OccupationType.doLar:
        return 'Do Lar';
    }
  }

  String get description {
    switch (type) {
      case OccupationType.estudante:
        return 'Pessoa matriculada em instituição de ensino onde os estudos são a atividade principal. Exemplos: alunos do ensino fundamental, médio, técnico, superior (graduação), pós-graduação, cursos profissionalizantes, idiomas ou preparatórios para concursos.';
      case OccupationType.assalariado:
        return 'Pessoa com vínculo empregatício formal registrado na CTPS (Carteira de Trabalho). Recebe salário mensal fixo e benefícios trabalhistas. Exemplos: funcionários de empresas privadas, públicas, ONGs, cooperativas, com direito a férias, 13º salário, FGTS e demais benefícios previstos na CLT.';
      case OccupationType.propietario:
        return 'Pessoa que possui ou é sócia de empresa, tendo participação nos lucros e responsabilidades do negócio. Exemplos: MEI (Microempreendedor Individual), ME (Microempresa), EPP (Empresa de Pequeno Porte), sócios de startups, franqueados, proprietários de comércio local ou prestadores de serviços empresariais.';
      case OccupationType.autonomo:
        return 'Profissional que trabalha por conta própria, sem vínculo empregatício, contribuindo para a Previdência Social como autônomo. Exemplos: advogados, médicos, dentistas, psicólogos, contadores, arquitetos, consultores, freelancers, profissionais com registro em conselhos profissionais.';
      case OccupationType.informal:
        return 'Pessoa que exerce atividade remunerada sem vínculo empregatício formal e sem contribuição previdenciária. Exemplos: vendedores ambulantes, diaristas, entregadores por aplicativo, prestadores de serviços eventuais, artesãos, trabalhadores domésticos sem carteira assinada.';
      case OccupationType.estagiario:
        return 'Estudante que desenvolve atividades práticas em empresa ou órgão público, com supervisão profissional e carga horária reduzida, por período determinado conforme Lei do Estágio. Exemplos: estagiários de ensino médio, técnico, superior, com contrato específico e bolsa-auxílio (não salário).';
      case OccupationType.estagioNaoRemunerado:
        return 'Trabalha sob a supervisão de um profissional na área de estudo, com carga horária reduzida e por um período determinado, conforme o contrato de estágio sem remuneração';
      case OccupationType.aposentado:
        return 'Pessoa que recebe benefício previdenciário do INSS ou previdência privada. Exemplos: aposentados por tempo de contribuição, idade, invalidez, pensionistas por morte do cônjuge/companheiro, beneficiários de fundos de pensão de empresas, servidores públicos aposentados.';
      case OccupationType.beneficiario:
        return 'Pessoa com deficiência ou idoso acima de 65 anos em situação de vulnerabilidade social, que recebe um salário mínimo mensal do governo federal. Exemplos: pessoas com deficiência física, intelectual, mental ou sensorial de longo prazo, idosos em famílias com renda per capita inferior a 1/4 do salário mínimo.';
      case OccupationType.desempregado:
        return 'Pessoa sem trabalho que está ativamente procurando emprego e disponível para trabalhar. Exemplos: pessoas em busca do primeiro emprego, demitidas recentemente, em transição de carreira, podendo ou não receber seguro-desemprego, participando de processos seletivos ou capacitações profissionais.';
      case OccupationType.doLar:
        return 'Pessoa que dedica seu tempo integral aos cuidados domésticos e familiares, sem exercer atividade remunerada externa. Exemplos: responsáveis pelos cuidados da casa, crianças, idosos, pessoas com deficiência ou doentes, organização familiar, sendo esta sua ocupação principal e reconhecida socialmente.';
    }
  }

  void _init() {
    switch (type) {
      case OccupationType.estudante:
        fieldHints = [];
        break;
      case OccupationType.assalariado:
        fieldHints = ['Função', 'Empresa'];
        fieldOptions['Função'] = [
          'Operacional',
          'Técnico',
          'Analista',
          'Coordenador',
          'Gerente',
          'Diretor',
          'Outro'
        ];
        break;
      case OccupationType.propietario:
        fieldHints = ['CNPJ', 'Porte da empresa', 'Situação', 'Função/Atuação'];
        fieldOptions['Porte da empresa'] = [
          'Microempreendedor Individual (MEI)',
          'Microempresa (ME) ',
          'Empresa de Pequeno Porte (EPP)',
          'Empresa de Médio Porte ',
          'Empresa de Grande Porte',
        ];
        fieldOptions['Situação'] = [
          'Ativa',
          'Baixada',
          'Inapta',
          'Suspensa',
          'Nula',
        ];

        showOptanteSimples = true;
        showMovimentacao = true;
        break;
      case OccupationType.autonomo:
        fieldHints = ['Função'];
        fieldOptions['Função'] = [
          'Prestador de Serviços',
          'Profissional Liberal',
          'Comerciante',
          'Outro'
        ];
        break;
      case OccupationType.informal:
        fieldHints = ['Função'];
        break;
      case OccupationType.estagiario:
        fieldHints = ['Função', 'Empresa'];
        break;
      case OccupationType.estagioNaoRemunerado:
        fieldHints = [];
        break;
      case OccupationType.aposentado:
        fieldHints = [];
        break;
      case OccupationType.beneficiario:
        fieldHints = [];
        break;
      case OccupationType.desempregado:
        fieldHints = [];
        showUnemployed = true;
        break;
      case OccupationType.doLar:
        fieldHints = [];
        break;
    }

    for (final hint in fieldHints) {
      controllers[hint] = TextEditingController();
    }

    if (showOptanteSimples) {
      controllers['Optante Simples nacional?'] = TextEditingController();
    }
    if (showMovimentacao) {
      controllers['Houve movimentacao?'] = TextEditingController();
    }
    if (showUnemployed) {
      controllers['Recebe seguro desemprego?'] = TextEditingController();
    }
  }

  Future<Map<String, String>> save() async {
    final Map<String, String> result = {};
    for (final entry in controllers.entries) {
      result[entry.key] = entry.value.text;
    }
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return result;
  }

  void dispose() {
    for (final c in controllers.values) {
      c.dispose();
    }
  }
}
