import 'dart:async';

import 'package:flutter/material.dart';

class CustomRoundedButton extends StatefulWidget {
  final Color backgroundColor;
  final String label;
  final Color labelColor;
  final FutureOr<void> Function()? onTap;
  final FocusNode? focusNode;
  final double? height;
  final double? width;
  const CustomRoundedButton({Key? key, required this.backgroundColor, required this.label, required this.labelColor, this.onTap, this.focusNode, this.height, this.width}) : super(key: key);

  @override
  State<CustomRoundedButton> createState() => _CustomRoundedButtonState();
}

class _CustomRoundedButtonState extends State<CustomRoundedButton> {
  var isLoading = false;

  Future<void> _onTapSetLoadingTrue() async {
    final onTap = widget.onTap;
    if (onTap != null) {
      setState(() {
        isLoading = true;
      });
      await onTap();
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height ?? 48,
      width: widget.width,
      child: Material(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          focusNode: widget.focusNode,
          borderRadius: BorderRadius.circular(24),
          onTap: isLoading ? null : _onTapSetLoadingTrue,
          splashColor: const Color.fromARGB(255, 0, 174, 255),
          child: Center(
            child: isLoading
                ? const CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white,
                  )
                : Text(
                    widget.label,
                    style: TextStyle(color: widget.labelColor, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ),
      ),
    );
  }
}
