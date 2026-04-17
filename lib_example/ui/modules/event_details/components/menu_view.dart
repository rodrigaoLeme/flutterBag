import 'package:flutter/material.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 1.0,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return null;

        // return const MenuCell();
      },
    );
  }
}
