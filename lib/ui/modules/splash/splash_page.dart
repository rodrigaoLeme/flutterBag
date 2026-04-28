import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';

import '../../../main/routes/routes.dart';
import '../../helpers/themes/app_colors.dart';
import 'splash_presenter.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late final DateTime _startTime;
  double _opacity = 1.0;
  final Duration _minDuration = const Duration(seconds: 3);
  final Duration _firstStageDuration = const Duration(milliseconds: 1200);
  final Duration _crossFadeDuration = const Duration(milliseconds: 700);
  final Duration _fadeDuration = const Duration(milliseconds: 700);
  bool _showSecond = false;
  bool _navigated = false;
  Timer? _stageTimer;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _stageTimer = Timer(_firstStageDuration, () {
      if (!mounted) return;
      setState(() => _showSecond = true);
    });

    _handleAuthFlow();

    widget.presenter.checkSession();
  }

  Future<void> _handleAuthFlow() async {
    try {
      final isAuthenticated =
          await widget.presenter.isAuthenticatedStream.first;

      if (_navigated) return;

      await _ensureMinimumSplashTime();

      if (!mounted) return;

      await _fadeOut();

      if (!mounted) return;

      _navigated = true;

      _navigate(isAuthenticated!);
    } catch (_) {
      if (!mounted) return;

      if (!_navigated) {
        Modular.to.navigate(Routes.login);
      }
    }
  }

  Future<void> _ensureMinimumSplashTime() async {
    final elapsed = DateTime.now().difference(_startTime);
    final remaining = _minDuration - elapsed;

    if (!remaining.isNegative) {
      await Future.delayed(remaining);
    }
  }

  Future<void> _fadeOut() async {
    setState(() => _opacity = 0.0);
    await Future.delayed(_fadeDuration);
  }

  void _navigate(bool isAuthenticated) {
    if (isAuthenticated) {
      Modular.to.navigate(Routes.onboarding);
    } else {
      Modular.to.navigate(Routes.login);
    }
  }

  @override
  void dispose() {
    _stageTimer?.cancel();
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _showSecond ? AppColors.primary : Colors.white,
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: _fadeDuration,
          curve: Curves.easeOut,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              AnimatedOpacity(
                opacity: _showSecond ? 0.0 : 1.0,
                duration: _crossFadeDuration,
                child: Container(
                  height: 172,
                  width: 172,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'lib/ui/assets/images/logo-white.svg',
                    height: 102,
                    width: 102,
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: _showSecond ? 1.0 : 0.0,
                duration: _crossFadeDuration,
                child: SvgPicture.asset(
                  'lib/ui/assets/images/logo-white.svg',
                  height: 102,
                  width: 102,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
