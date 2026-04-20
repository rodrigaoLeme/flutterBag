import 'package:flutter/material.dart';

Future<T?> showCustomModalBottomSheet<T>({required BuildContext context, bool hasScrollIcon = false, required WidgetBuilder content, bool isScrollControlled = false, bool isDismissible = true}) {
  return showModalBottomSheet<T?>(
    isScrollControlled: isScrollControlled,
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
    backgroundColor: Colors.white,
    isDismissible: isDismissible,
    builder: (newContext) {
      return hasScrollIcon
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 4,
                  width: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCED4D8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(child: content(newContext)),
              ],
            )
          : content(newContext);
    },
  );
}
