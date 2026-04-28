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
  static const Duration _crossFadeDuration = Duration(milliseconds: 700);

  @override
  void initState() {
    super.initState();
    _listenToNavigation();
    widget.presenter.checkSession();
  }

  void _listenToNavigation() {
    widget.presenter.navigationRouteStream.listen(
      (route) {
        if (mounted) {
          Modular.to.navigate(route ?? Routes.login);
        }
      },
      onError: (_) {
        if (mounted) {
          Modular.to.navigate(Routes.login);
        }
      },
    );
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: widget.presenter.showSecondLogoStream,
      initialData: false,
      builder: (context, showSnapshot) {
        final showSecond = showSnapshot.data ?? false;

        return Scaffold(
          backgroundColor: showSecond ? AppColors.primary : Colors.white,
          body: Center(
            child: _buildAnimatedContent(),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedContent() {
    return StreamBuilder<double>(
      stream: widget.presenter.opacityStream,
      initialData: 1.0,
      builder: (context, opacitySnapshot) {
        final opacity = opacitySnapshot.data ?? 1.0;

        return StreamBuilder<bool>(
          stream: widget.presenter.showSecondLogoStream,
          initialData: false,
          builder: (context, showSnapshot) {
            final showSecond = showSnapshot.data ?? false;

            return AnimatedOpacity(
              opacity: opacity,
              duration: _crossFadeDuration,
              curve: Curves.easeOut,
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    opacity: showSecond ? 0.0 : 1.0,
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
                    opacity: showSecond ? 1.0 : 0.0,
                    duration: _crossFadeDuration,
                    child: SvgPicture.asset(
                      'lib/ui/assets/images/logo-white.svg',
                      height: 102,
                      width: 102,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
