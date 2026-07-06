import 'package:flutter/material.dart';

import '../../../../../../main/i18n/app_i18n.dart';
import '../../../../../components/ebolsa_button.dart';
import '../../../../../components/ebolsa_member_card.dart';
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
              headerTitle: vm.addedFamilyMembers[i]['cpf']?.toString() ?? '',
              tag: vm.addedFamilyMembers[i]['isScholarshipCandidate'] == true
                  ? AppI18n.current.scholarshipCandidateTag
                  : null,
              title: vm.addedFamilyMembers[i]['name']?.toString() ?? '',
              subtitle:
                  vm.addedFamilyMembers[i]['maritalStatus']?.toString(),
              content: const [],
              onEdit: () => onEditMember(i),
              onDelete: () => onDeleteMember(i),
            ),
            const SizedBox(height: 12),
          ],
        const SizedBox(height: 200),
      ],
    );
  }
}
