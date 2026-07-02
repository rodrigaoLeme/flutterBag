import 'package:flutter/material.dart';

import '../../../domain/entities/process_enums.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../helpers/themes/themes.dart';
import 'components/cards/processes_cards_result.dart';

class ProcessCandidatesPage extends StatelessWidget {
  // Por enquanto mockado — futuramente receberá List<StudentEntity>
  const ProcessCandidatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(appStrings.processDetailCandidates),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              appStrings.processCandidatesTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              appStrings.processCandidatesSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
            ),
            const SizedBox(height: 24),

            // Mock — substituir por lista real quando tiver os dados
            ProcessCardResult(
              studentName: 'Maria Julia Padilha da Silva',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.analysis,
              enrollmentStatus: RegistrationStatus.noRegistration,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
            ProcessCardResult(
              studentName: 'Chafun di Fórnio',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.approved50,
              enrollmentStatus: RegistrationStatus.reserveSpot,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
            ProcessCardResult(
              studentName: 'Chafun di Fórnio',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.approved100,
              enrollmentStatus: RegistrationStatus.registered,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
            ProcessCardResult(
              studentName: 'Chafun di Fórnio',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.rejected,
              enrollmentStatus: RegistrationStatus.completed,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
            ProcessCardResult(
              studentName: 'Chafun di Fórnio',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.disqualified,
              enrollmentStatus: RegistrationStatus.locked,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
            ProcessCardResult(
              studentName: 'Chafun di Fórnio',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.waitingList,
              enrollmentStatus: RegistrationStatus.withdrawal,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
            ProcessCardResult(
              studentName: 'Chafun di Fórnio',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.analysis,
              enrollmentStatus: RegistrationStatus.canceled,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
            ProcessCardResult(
              studentName: 'Chafun di Fórnio',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.analysis,
              enrollmentStatus: RegistrationStatus.awaitingApproval,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
            ProcessCardResult(
              studentName: 'Chafun di Fórnio',
              schoolUnit: 'UNASP - Hortolândia',
              course: 'Psicologia',
              processCode: '12345ABCDE',
              result: ResultStatus.analysis,
              enrollmentStatus: RegistrationStatus.transferred,
              onViewProcess: () {
                // TODO: abrir PDF do processo
              },
            ),
          ],
        ),
      ),
    );
  }
}
