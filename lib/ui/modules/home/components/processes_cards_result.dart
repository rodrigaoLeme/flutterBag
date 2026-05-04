import 'package:flutter/material.dart';

import '../../../helpers/themes/themes.dart';

// ---------------------------------------------------------------------------
// Enums de status
// ---------------------------------------------------------------------------
enum ProcessResult {
  aprovado,
  desclassificado,
  emAnalise,
  pendente;

  String get label {
    switch (this) {
      case aprovado:
        return 'Aprovado';
      case desclassificado:
        return 'Desclassificado';
      case emAnalise:
        return 'Em Análise';
      case pendente:
        return 'Pendente';
    }
  }

  Color get color {
    switch (this) {
      case aprovado:
        return const Color(0xFF4CAF50);
      case desclassificado:
        return const Color(0xFFFF6B35);
      case emAnalise:
        return const Color(0xFF2196F3);
      case pendente:
        return const Color(0xFF9E9E9E);
    }
  }
}

enum EnrollmentStatus {
  semMatricula,
  matriculado,
  emProcesso;

  String get label {
    switch (this) {
      case semMatricula:
        return 'Sem Matrícula';
      case matriculado:
        return 'Matriculado';
      case emProcesso:
        return 'Em Processo';
    }
  }
}

// ---------------------------------------------------------------------------
// ProcessCard
// ---------------------------------------------------------------------------
class ProcessCard extends StatelessWidget {
  final String studentName;
  final String schoolUnit;
  final String course;
  final String processCode;
  final ProcessResult result;
  final EnrollmentStatus enrollmentStatus;
  final VoidCallback? onViewProcess;

  const ProcessCard({
    super.key,
    required this.studentName,
    required this.schoolUnit,
    required this.course,
    required this.processCode,
    required this.result,
    required this.enrollmentStatus,
    this.onViewProcess,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nome do aluno
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
            child: Center(
              child: Text(
                studentName,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),

          const Divider(
            height: 1,
            endIndent: 16,
            indent: 16,
          ),

          // Unidade Escolar e Curso
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  label: 'Unidade Escolar',
                  value: schoolUnit,
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: 'Curso',
                  value: course,
                ),
              ],
            ),
          ),

          // Processo + botão Visualizar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Processo',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        processCode,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onViewProcess,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.borderLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                  ),
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('Visualizar'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(
            height: 1,
            endIndent: 16,
            indent: 16,
          ),

          // // Resultado e Status Matrícula
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Resultado',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _ResultBadge(result: result),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Status Matrícula',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondaryLight,
                            ),
                      ),
                      const SizedBox(height: 8),
                      _EnrollmentBadge(status: enrollmentStatus),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Subwidgets internos
// ---------------------------------------------------------------------------
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondaryLight,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}

class _ResultBadge extends StatelessWidget {
  final ProcessResult result;

  const _ResultBadge({required this.result});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: result.color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        result.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _EnrollmentBadge extends StatelessWidget {
  final EnrollmentStatus status;

  const _EnrollmentBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFE0E2EC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (status == EnrollmentStatus.semMatricula)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                Icons.block_outlined,
                size: 16,
                color: AppColors.textSecondaryLight,
              ),
            ),
          Text(
            status.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.textSecondaryLight,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}
