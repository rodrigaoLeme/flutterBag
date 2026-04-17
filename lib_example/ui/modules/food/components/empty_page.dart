import 'package:flutter/material.dart';

class EmptyItemsPage extends StatelessWidget {
  const EmptyItemsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 220,
        ),
        Container(
          width: 110,
          height: 110,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Color(0xffFFFFE4),
                Color(0xffF8FF92),
                Color(0xffFDFFC5),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Image.asset(
              'lib/ui/assets/images/image_default.png',
              width: 50,
              height: 50,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Ops, você ainda não tem itens\ncadastrados para envio.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
