import 'package:flutter/material.dart';

import 'result_cell.dart';

class ResultSection extends StatelessWidget {
  const ResultSection({super.key});

  final List<Map<String, dynamic>> results = const [
    {
      'image': 'lib/ui/assets/images/person_3.png',
      'name': 'Pr. Alexander',
      'position': 'President',
      'labelImage': 'SID'
    },
    {
      'image': 'lib/ui/assets/images/person_1.png',
      'name': 'Sophia',
      'position': 'Secretary',
      'labelImage': 'GCAS'
    },
    {
      'image': 'lib/ui/assets/images/person_2.png',
      'name': 'Pr. James',
      'position': 'Treasurer',
      'labelImage': 'PARL'
    },
    {
      'image': 'lib/ui/assets/images/person.png',
      'name': 'Olivia',
      'position': 'Associate',
      'labelImage': 'STW'
    },
    {
      'image': 'lib/ui/assets/images/person.png',
      'name': 'Carla',
      'position': 'Treasurer',
      'labelImage': 'STW'
    },
    {
      'image': 'lib/ui/assets/images/person.png',
      'name': 'July',
      'position': 'Associate',
      'labelImage': 'PARL'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: results.length,
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        final item = results[index];
        return Padding(
          padding: EdgeInsets.only(
            left: index == 0 ? 16 : 8,
            right: index == results.length - 1 ? 16 : 24,
          ),
          child: ResultCell(
            image: item['image'],
            name: item['name'],
            position: item['position'],
            labelImage: item['labelImage'],
          ),
        );
      },
    );
  }
}
