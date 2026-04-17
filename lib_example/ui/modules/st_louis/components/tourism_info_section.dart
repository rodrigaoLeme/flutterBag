import 'package:flutter/material.dart';

class TourismInfoSection extends StatelessWidget {
  const TourismInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return const Column(
          children: [
            TourismInfoSection(),
          ],
        );
      },
      itemCount: 5,
    );
  }
}
