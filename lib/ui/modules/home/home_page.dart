import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../data/cache/cache.dart';
import '../../../main/di/injection_container.dart';
import '../../../main/routes/auth_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Início')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Usuário autenticado com sucesso!'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await sl<SecureStorage>().clean();
                Modular.to.navigate(AuthRoutes.login);
              },
              child: const Text('Sair'),
            ),
          ],
        ),
      ),
    );
  }
}
