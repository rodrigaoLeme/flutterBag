import 'custom_app_bar.dart';
import 'package:flutter/material.dart';


class CustomScaffold extends StatelessWidget {
  final CustomAppBar? appBar;
  final Widget? body;

  const CustomScaffold({super.key, this.appBar, this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: body,
    );
  }
}
