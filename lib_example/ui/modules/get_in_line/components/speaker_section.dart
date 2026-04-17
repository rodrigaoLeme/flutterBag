import 'package:flutter/material.dart';

import '../../modules.dart';

class SpeakerSection extends StatelessWidget {
  const SpeakerSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: SpeakerCell(),
        );
      },
      itemCount: 6,
    );
  }
}
