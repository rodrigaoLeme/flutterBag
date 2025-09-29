import 'package:flutter/material.dart';

class DocumentsResult extends StatelessWidget {
  const DocumentsResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
        color: Colors.white,
        child: const Text(
          'Em caso de dúvida, entre em contato com a unidade escolar.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff758EB3),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.sticky_note_2,
                color: Color(0xFFF2A600),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Resultado',
                style: TextStyle(
                  color: Color(0xFFF2A600),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ResultadoCard(
            nome: 'João Silva',
            curso: '3 TIA',
            statusDeferido: true,
            message:
                'Informamos que com base na análise do perfil socioeconômico e demais critérios '
                'estabelecidos pela entidade, a solicitação de Bolsa de Estudo para o ano letivo '
                'de {ano_do_processo} foi deferida com percentual de 50%.\n\n'
                'Em consonância com o Edital, para receber o benefício supra, o responsável legal '
                'deverá comparecer à secretaria escolar, até a data xx/xx/xxxx, munido de todos os '
                'documentos necessários para efetivar a matrícula do bolsista, consonante aos '
                'prazos previstos no cronograma descrito no Edital. A não efetivação da matrícula '
                'do estudante, pelo responsável legal, cancela o processo de recebimento do '
                'benefício da bolsa de estudo.',
          ),
        ],
      ),
    );
  }
}

class ResultadoCard extends StatelessWidget {
  final String nome;
  final String curso;
  final bool statusDeferido;
  final String message;

  const ResultadoCard({
    super.key,
    required this.nome,
    required this.curso,
    required this.statusDeferido,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final Color corStatus =
        statusDeferido ? const Color(0xff00A357) : const Color(0xffE62020);
    final String textoStatus = statusDeferido ? 'Deferido 100%' : 'Indeferido';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              nome,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003366),
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: corStatus.withOpacity(0.1),
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
        Text(
          'Colégio UNASP Hortolândia\nCurso: $curso\nAno Letivo: (ano do processo)\n'
          'Processo: Ensino Básico - Renovação - (02/06/2025 à 07/07/2025)',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff758EB3),
          ),
        ),
        const SizedBox(height: 32),
        Card(
          elevation: 0,
          color: const Color(0xffF5F5F5),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  message,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff56595D),
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
