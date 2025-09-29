import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final bool isSecret;
  final Color labelColor;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final void Function(String) onChanged;
  final VoidCallback? onEditingComplete;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? errorText;
  const CustomTextField({Key? key, required this.onChanged, required this.label, required this.labelColor, this.inputFormatters, this.keyboardType, this.onEditingComplete, this.isSecret = false, this.textInputAction, this.focusNode, this.errorText}) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(color: widget.labelColor, fontSize: 16),
        ),
        const SizedBox(height: 10),
        SizedBox(
          child: TextField(
            focusNode: widget.focusNode,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              border: const OutlineInputBorder(),
              errorText: widget.errorText,
            ),
            keyboardType: widget.keyboardType,
            onEditingComplete: widget.onEditingComplete,
            obscureText: widget.isSecret,
            textInputAction: widget.textInputAction,
          ),
        ),
      ],
    );
  }
}
