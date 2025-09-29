import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../icons/ebolsas_icons_icons.dart';

class SmallSubGroupCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? leading;
  final Color? titleColor;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? splashColor;
  final EdgeInsets? internalMargin;
  final ShapeBorder? shapeBorder;

  const SmallSubGroupCard({Key? key, this.leading, required this.title, required this.onTap, this.trailing, this.backgroundColor, this.titleColor, this.splashColor, this.internalMargin, this.shapeBorder}) : super(key: key);

  const factory SmallSubGroupCard.initial({required String title, required VoidCallback onTap}) = _InitialStateSmallSubGroupCard;
  const factory SmallSubGroupCard.success({required String title, required VoidCallback onTap}) = _SuccessStateSmallSubGroupCard;
  const factory SmallSubGroupCard.error({required String title, required VoidCallback onTap}) = _ErrorStateSmallSubGroupCard;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: LimitedBox(
        child: Card(
          margin: const EdgeInsets.all(0),
          elevation: 0,
          color: backgroundColor,
          shape: shapeBorder ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
          child: InkWell(
            borderRadius: BorderRadius.circular(9),
            splashColor: splashColor,
            onTap: onTap,
            child: Container(
              margin: internalMargin ?? const EdgeInsets.all(14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 6)
                  ],
                  Text(
                    title,
                    style: TextStyle(color: titleColor, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InitialStateSmallSubGroupCard extends SmallSubGroupCard {
  const _InitialStateSmallSubGroupCard({required super.title, required super.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return UnconstrainedBox(
      child: LimitedBox(
        child: DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(9),
          color: primaryColor,
          strokeWidth: 0.5,
          child: SmallSubGroupCard(
            backgroundColor: Colors.white,
            title: title,
            onTap: onTap,
            titleColor: const Color(0xFF003B6F),
            splashColor: Colors.blue[400],
            internalMargin: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
            shapeBorder: const Border(),
          ),
        ),
      ),
    );
  }
}

class _SuccessStateSmallSubGroupCard extends SmallSubGroupCard {
  const _SuccessStateSmallSubGroupCard({required super.title, required super.onTap});

  @override
  Widget build(BuildContext context) {
    const successColor = Color(0xFF00A357);
    final primaryColor = Theme.of(context).colorScheme.primary;
    return SmallSubGroupCard(
      backgroundColor: const Color(0xFFDCFFEF),
      trailing: Icon(
        EbolsasIcons.icon_awesome_edit,
        color: primaryColor,
        size: 22,
      ),
      leading: const Icon(
        EbolsasIcons.check,
        color: successColor,
        size: 22,
      ),
      title: title,
      onTap: onTap,
      titleColor: primaryColor,
      splashColor: Colors.white,
      internalMargin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    );
  }
}

class _ErrorStateSmallSubGroupCard extends SmallSubGroupCard {
  const _ErrorStateSmallSubGroupCard({required super.title, required super.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return SmallSubGroupCard(
      backgroundColor: const Color(0xFFFFC2C2),
      trailing: const Icon(
        EbolsasIcons.icon_awesome_edit,
        color: Color(0xFFE62020),
      ),
      leading: leading,
      title: title,
      onTap: onTap,
      titleColor: primaryColor,
      splashColor: Colors.red[400],
    );
  }
}
