import 'package:flutter/material.dart';

import '../../../share/ds/ds_logo.dart';
import '../../../share/utils/app_color.dart';
import '../../helpers/helpers.dart';
import '../../mixins/mixins.dart';
import './splash.dart';

class SplashPage extends StatefulWidget {
  final SplashPresenter presenter;

  const SplashPage({super.key, required this.presenter});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with NavigationManager {
  @override
  Widget build(BuildContext context) {
    widget.presenter.checkAccount();

    return Material(
      child: Builder(
        builder: (context) {
          handleNavigation(widget.presenter.navigateToStream);
          return Container(
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: ResponsiveLayout.of(context).hp(20),
                    child: const Hero(
                      tag: 'logo',
                      child: DSLogo(
                        type: DSLogoType.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
