import 'package:flutter/material.dart';

import './components.dart';

class EmergencySection extends StatelessWidget {
  const EmergencySection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 24.0),
          child: EmergencyCell(),
        );
      },
      itemCount: 4,
    );
  }
}
