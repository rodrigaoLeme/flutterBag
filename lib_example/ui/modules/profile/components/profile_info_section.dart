import 'package:flutter/material.dart';

import '../../modules.dart';

class ProfileInfoSection extends StatelessWidget {
  const ProfileInfoSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 16.0),
          child: ProfileInfoCell(),
        );
      },
      itemCount: 3,
    );
  }
}
