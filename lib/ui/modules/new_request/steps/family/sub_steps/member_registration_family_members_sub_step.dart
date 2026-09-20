import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../domain/entities/enrollment_enums.dart';
import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/ebolsa_button.dart';
import '../../../../../components/ebolsa_member_card.dart';
import '../../../../../helpers/money_formatter.dart';
import '../../../../../helpers/themes/themes.dart';
import '../member_registration_view_model.dart';

class MemberRegistrationFamilyMembersSubStep extends StatelessWidget {
  const MemberRegistrationFamilyMembersSubStep({
    super.key,
    required this.vm,
    required this.onAddMember,
    required this.onEditMember,
    required this.onDeleteMember,
  });

  final MemberRegistrationViewModel vm;
  final VoidCallback onAddMember;
  final void Function(int index) onEditMember;
  final void Function(int index) onDeleteMember;

  String _calculateAge(String? dob) {
    if (dob == null || dob.isEmpty) return '-';
    try {
      final date = DateFormat('dd/MM/yyyy').parse(dob);
      final now = DateTime.now();
      int age = now.year - date.year;
      if (now.month < date.month ||
          (now.month == date.month && now.day < date.day)) {
        age--;
      }
      return '$age';
    } catch (_) {
      return '-';
    }
  }

  double _calculateIncome(Map<String, dynamic> member) {
    final occupations = member['occupations'];
    if (occupations is! List) return 0;
    return occupations.fold(0.0, (sum, o) {
      return sum +
          MoneyFormatter.parse(
            o['monthlyIncome'] ?? o['headerTitle'] ?? '0',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EbolsaButton(
          height: 48,
          borderRadius: 8,
          backgroundColor: AppColors.secondaryContainer,
          onPressed: onAddMember,
          label: '+ Adicionar membro familiar',
          textStyle: AppTextStyles.ebolsaTitleMedium.copyWith(
            color: AppColors.onPrimaryContainer,
          ),
        ),
        const SizedBox(height: 16),
        if (vm.addedFamilyMembers.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Nenhum membro registrado ainda.',
                style: AppTextStyles.bodyMedium,
              ),
            ),
          )
        else
          for (var i = 0; i < vm.addedFamilyMembers.length; i++) ...[
            EbolsaMemberCard(
              isResponsible: vm.addedFamilyMembers[i]['isResponsible'],
              headerTitle: null,
              tag: vm.addedFamilyMembers[i]['isResponsible'] == true
                  ? AppI18n.current.scholarshipResponsibleTag
                  : vm.addedFamilyMembers[i]['isScholarshipCandidate'] == true
                      ? AppI18n.current.scholarshipCandidateTag
                      : null,
              title: vm.addedFamilyMembers[i]['name']?.toString() ?? '',
              subtitle:
                  null, //vm.addedFamilyMembers[i]['maritalStatus']?.toString(),
              content: [
                Text('CPF: ${vm.addedFamilyMembers[i]['cpf'] ?? ''}',
                    style: AppTextStyles.labelMedium),
                const SizedBox(height: 2),
                Text('Dt. Nascimento: ${vm.addedFamilyMembers[i]['dob'] ?? ''}',
                    style: AppTextStyles.labelMedium),
                const SizedBox(height: 2),
                Text('Idade: ${_calculateAge(vm.addedFamilyMembers[i]['dob'])}',
                    style: AppTextStyles.labelMedium),
                const SizedBox(height: 2),
                Text(
                    'Estado Civil: ${vm.addedFamilyMembers[i]['maritalStatus'] ?? ''}',
                    style: AppTextStyles.labelMedium),
                const SizedBox(height: 2),
                Text(
                  'Parentesco: ${vm.addedFamilyMembers[i]['isResponsible'] == true ? 'Responsável' : KinshipType.fromValue(vm.addedFamilyMembers[i]['kinshipType'] as int?)?.label ?? '-'}',
                  style: AppTextStyles.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  'Renda Bruta: ${MoneyFormatter.format(_calculateIncome(vm.addedFamilyMembers[i]))}',
                  style: AppTextStyles.labelMedium,
                ),
              ],
              onEdit: () => onEditMember(i),
              onDelete: () => onDeleteMember(i),
            ),
          ],
        const SizedBox(height: 200),
      ],
    );
  }
}
