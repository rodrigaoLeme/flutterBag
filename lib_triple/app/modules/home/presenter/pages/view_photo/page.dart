import 'package:flutter/material.dart';

import 'controller.dart';

class Page extends StatelessWidget {
  final Controller controller;
  const Page({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Align(alignment: Alignment.center, child: Image.file(controller.file)),
          Positioned(
            top: 20,
            left: 20,
            child: GestureDetector(
              onTap: controller.onTapClose,
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
