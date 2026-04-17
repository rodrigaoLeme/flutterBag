import 'package:flutter/material.dart';

import '../../presentation/mixins/mixins.dart';
import '../../share/utils/app_color.dart';

void hideLoading(BuildContext context) {
  if (Navigator.canPop(context)) {
    Navigator.of(context).pop();
  }
}

Future<void> showLoading(BuildContext context, LoadingData data) async {
  Future.delayed(Duration.zero, () async {
    await showDialog(
      barrierColor: data.style == LoadingStyle.light
          ? AppColors.primaryLight.withAlpha(90)
          : AppColors.primaryLight,
      context: context,
      barrierDismissible: false,
      builder: (context) => SimpleDialog(
        titlePadding: EdgeInsets.zero,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        shadowColor: data.style == LoadingStyle.light
            ? Colors.transparent
            : AppColors.primaryLight,
        backgroundColor: data.style == LoadingStyle.light
            ? Colors.transparent
            : AppColors.primaryLight,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                color: data.style == LoadingStyle.light
                    ? AppColors.primaryLight
                    : Colors.white,
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  });
}
