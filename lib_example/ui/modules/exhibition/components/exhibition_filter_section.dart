import 'package:flutter/material.dart';

import '../../modules.dart';

class ExhibitionFilterSection extends StatelessWidget {
  const ExhibitionFilterSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: ExhibitionFilterCell(),
        );
      },
    );
  }
}
