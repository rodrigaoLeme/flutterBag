import 'package:flutter/material.dart';

import 'voting_result_user_cell.dart';

class VotingResultUserSection extends StatelessWidget {
  const VotingResultUserSection({super.key});

  // Lista de dados mockados para os componentes
  final List<Map<String, String>> votingResults = const [
    {
      'image': 'lib/ui/assets/images/person_3.png',
      'position': 'Pres. DSA',
    },
    {
      'image': 'lib/ui/assets/images/person_1.png',
      'position': 'Sec. DSA',
    },
    {
      'image': 'lib/ui/assets/images/person_2.png',
      'position': 'Treas. DSA',
    },
    {
      'image': 'lib/ui/assets/images/person.png',
      'position': 'Secretary',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: votingResults.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        final item = votingResults[index];
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 16 : 8,
            right: index == votingResults.length - 1 ? 16 : 24,
          ),
          child: VotingResultUserCell(
            image: item['image'] ?? '',
            position: item['position'] ?? '',
          ),
        );
      },
    );
  }
}
