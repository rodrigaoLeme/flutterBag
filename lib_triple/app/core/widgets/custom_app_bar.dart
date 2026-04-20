import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize; // default is 56.0

  final Widget? bottomWidget;
  final Widget? title;
  final Widget? leading;
  final Widget? trailing;
  final bool automaticallyImplyLeading;
  final EdgeInsetsGeometry internalPadding;

  const CustomAppBar({
    Key? key,
    this.preferredSize = const Size.fromHeight(54),
    this.bottomWidget,
    this.title,
    this.leading,
    this.trailing,
    this.automaticallyImplyLeading = true,
    this.internalPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      bottom: false,
      child: Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: const BorderRadius.only(
            bottomRight: Radius.circular(4),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                padding: widget.internalPadding,
                child: Row(
                  children: [
                    if (widget.automaticallyImplyLeading && navigator.canPop())
                      IconButton(
                        onPressed: navigator.pop,
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: colorScheme.secondary,
                        ),
                      ),
                    if (!widget.automaticallyImplyLeading && widget.leading != null) widget.leading!,
                    if (widget.title != null) Expanded(child: widget.title!),
                    if (widget.trailing != null) widget.trailing!
                  ],
                ),
              ),
            ),
            if (widget.bottomWidget != null) widget.bottomWidget!,
          ],
        ),
      ),
    );
  }
}
