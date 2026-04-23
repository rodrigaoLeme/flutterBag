import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../main/routes/auth_routes.dart';
import '../../helpers/themes/app_colors.dart';
import 'splash_presenter.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late StreamSubscription<bool?> _authSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeStreams();
    widget.presenter.checkSession();
  }

  void _subscribeStreams() {
    _authSubscription =
        widget.presenter.isAuthenticatedStream.listen((isAuthenticated) {
      if (isAuthenticated == true) {
        //Modular.to.navigate(); // home após implementar
      } else {
        Modular.to.navigate(AuthRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo — substitua pelo asset real
            const Icon(Icons.school, size: 80, color: Colors.white),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
