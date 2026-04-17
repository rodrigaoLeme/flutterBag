import 'package:flutter/material.dart';

import 'components.dart';

class SavedRestaurantSection extends StatelessWidget {
  const SavedRestaurantSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 12.0),
          child: SavedRestaurantCell(),
        );
      },
    );
  }
}
