import 'package:flutter/material.dart';

class PersonCard extends StatelessWidget {
  final String name;
  final String cpf;

  final String? tag;
  final DateTime? birthDate;
  final int? age;
  final String? maritalStatus;
  final String? relationship;
  final double? income;

  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const PersonCard({
    super.key,
    required this.name,
    required this.cpf,
    this.tag,
    this.birthDate,
    this.age,
    this.maritalStatus,
    this.relationship,
    this.income,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (tag != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(tag!),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('CPF: $cpf'),
                    if (birthDate != null)
                      Text(
                        'Dt. Nascimento: ${birthDate!.day}/${birthDate!.month}/${birthDate!.year}',
                      ),
                    if (age != null) Text('Idade: $age'),
                    if (maritalStatus != null)
                      Text('Estado Civil: $maritalStatus'),
                    if (relationship != null) Text('Parentesco: $relationship'),
                    if (income != null)
                      Text(
                        'Renda Bruta: R\$ ${income!.toStringAsFixed(2)}',
                      ),
                  ],
                ),
              ),
              Column(
                children: [
                  if (onEdit != null)
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined),
                    ),
                  if (onDelete != null)
                    IconButton(
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
