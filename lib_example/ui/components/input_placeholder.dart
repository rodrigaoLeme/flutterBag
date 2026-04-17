import 'package:flutter/material.dart';

import '../../share/utils/app_color.dart';

class InputPlaceholder extends StatefulWidget {
  final String hint;
  final Widget? icon;
  final TextStyle style;
  final TextEditingController? controller;
  final Widget? iconLeading;
  final VoidCallback? onIconLeadingTap;
  final double? height;
  final void Function(String)? onChanged;

  const InputPlaceholder({
    super.key,
    required this.hint,
    this.icon,
    required this.style,
    this.controller,
    this.iconLeading,
    this.onIconLeadingTap,
    this.height,
    this.onChanged,
  });

  @override
  State<InputPlaceholder> createState() => _InputPlaceholderState();
}

class _InputPlaceholderState extends State<InputPlaceholder> {
  late final TextEditingController _controller;
  bool _showSuffixIcon = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_handleTextChanged);
    _showSuffixIcon = _controller.text.isNotEmpty;
  }

  void _handleTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _showSuffixIcon) {
      setState(() {
        _showSuffixIcon = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_handleTextChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: widget.style,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: AppColors.neutralHigh),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            borderSide: BorderSide(color: AppColors.neutralHigh),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          prefixIcon: widget.iconLeading != null
              ? GestureDetector(
                  onTap: widget.onIconLeadingTap,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.iconLeading,
                  ),
                )
              : null,
          suffixIcon: _showSuffixIcon && widget.icon != null
              ? GestureDetector(
                  onTap: () {
                    _controller.clear();
                    widget.onChanged?.call('');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.icon,
                  ),
                )
              : null,
        ),
        keyboardType: TextInputType.name,
        maxLines: null,
      ),
    );
  }
}
