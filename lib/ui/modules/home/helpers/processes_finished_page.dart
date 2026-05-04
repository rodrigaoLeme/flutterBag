import 'package:flutter/material.dart';

import '../../../../main/i18n/app_i18n.dart';
import '../components/processes_cards_result.dart';

class ProcessesFinishedPage extends StatefulWidget {
  const ProcessesFinishedPage({super.key});

  @override
  State<ProcessesFinishedPage> createState() => _ProcessesFinishedPageState();
}

class _ProcessesFinishedPageState extends State<ProcessesFinishedPage> {
  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 12, top: 20, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            appStrings.homeTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Veja os processos que você participou em 2024', // appStrings.homeSubtitleFinishedProcess,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          ProcessCard(
            studentName: 'Ana Silva',
            schoolUnit: 'Colégio Adventista de Hortolândia',
            course: '6º Ano - Ensino Fundamental',
            processCode: '12345ABCDE',
            result: ProcessResult.desclassificado,
            enrollmentStatus: EnrollmentStatus.semMatricula,
            onViewProcess: () {
              // abre o PDF do processo
            },
          ),
        ],
      ),
    );
  }
}
