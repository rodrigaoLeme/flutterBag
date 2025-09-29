import 'package:flutter/material.dart';

import '../icons/ebolsas_icons_icons.dart';

class SubGroupCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Widget? leading;
  final Color? titleColor;
  final Widget? trailing;
  final Color? backgroundColor;
  final Color? splashColor;
  final EdgeInsets? internalMargin;

  const SubGroupCard(
      {Key? key,
      this.leading,
      required this.title,
      required this.onTap,
      this.trailing,
      this.backgroundColor,
      this.titleColor,
      this.splashColor,
      this.internalMargin})
      : super(key: key);

  const factory SubGroupCard.initial({required String title, required VoidCallback onTap}) = _InitialStateSubGroupCard;
  const factory SubGroupCard.success({required String title, required VoidCallback onTap}) = _SuccessStateSubGroupCard;
  const factory SubGroupCard.error({required String title, required VoidCallback onTap}) = _ErrorStateSubGroupCard;
  factory SubGroupCard.builder({required String title, required VoidCallback onTap, required bool isError}) => isError
      ? _ErrorStateSubGroupCard(
          onTap: onTap,
          title: title,
        )
      : _SuccessStateSubGroupCard(onTap: onTap, title: title);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        splashColor: splashColor,
        onTap: onTap,
        child: Container(
          margin: internalMargin ?? const EdgeInsets.all(14),
          child: Row(
            children: [
              if (leading != null) ...[leading!, const SizedBox(width: 8)],
              Expanded(
                child: Text(title, style: TextStyle(color: titleColor, fontSize: 16), maxLines: 3, textAlign: TextAlign.center
                    //overflow: TextOverflow.ellipsis,
                    ),
              ),
              if (trailing != null) trailing!
            ],
          ),
        ),
      ),
    );
  }

  SubGroupCard copyWith({
    String? title,
    VoidCallback? onTap,
    Widget? leading,
    Color? backgroundColor,
    EdgeInsets? internalMargin,
    Color? splashColor,
    Color? titleColor,
    Widget? trailing,
  }) =>
      SubGroupCard(
        key: key,
        title: title ?? this.title,
        onTap: onTap ?? this.onTap,
        leading: leading ?? this.leading,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        internalMargin: internalMargin ?? this.internalMargin,
        splashColor: splashColor ?? this.splashColor,
        titleColor: titleColor ?? this.titleColor,
        trailing: trailing ?? this.trailing,
      );
}

class _InitialStateSubGroupCard extends SubGroupCard {
  const _InitialStateSubGroupCard({required super.title, required super.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return SubGroupCard(
      backgroundColor: const Color(0xFFF1FAFF),
      title: title,
      onTap: onTap,
      titleColor: primaryColor,
      splashColor: Colors.blue[400],
    );
  }

  @override
  _InitialStateSubGroupCard copyWith({
    String? title,
    VoidCallback? onTap,
    Widget? leading,
    Color? backgroundColor,
    EdgeInsets? internalMargin,
    Color? splashColor,
    Color? titleColor,
    Widget? trailing,
  }) =>
      _InitialStateSubGroupCard(
        title: title ?? this.title,
        onTap: onTap ?? this.onTap,
      );
}

class _SuccessStateSubGroupCard extends SubGroupCard {
  const _SuccessStateSubGroupCard({required super.title, required super.onTap, super.trailing});

  @override
  Widget build(BuildContext context) {
    const successColor = Color(0xFF00A357);
    final primaryColor = Theme.of(context).colorScheme.primary;
    return SubGroupCard(
      backgroundColor: const Color(0xFFDCFFEF),
      trailing: trailing ??
          Icon(
            EbolsasIcons.icon_awesome_edit,
            color: primaryColor,
            size: 20,
          ),
      leading: const Icon(
        EbolsasIcons.check,
        color: successColor,
        size: 26,
      ),
      title: title,
      onTap: onTap,
      titleColor: successColor,
      splashColor: Colors.white,
      internalMargin: const EdgeInsets.all(10),
    );
  }

  @override
  _SuccessStateSubGroupCard copyWith({
    String? title,
    VoidCallback? onTap,
    Widget? leading,
    Color? backgroundColor,
    EdgeInsets? internalMargin,
    Color? splashColor,
    Color? titleColor,
    Widget? trailing,
  }) =>
      _SuccessStateSubGroupCard(
        title: title ?? this.title,
        onTap: onTap ?? this.onTap,
        trailing: trailing ?? this.trailing,
      );
}

class _ErrorStateSubGroupCard extends SubGroupCard {
  const _ErrorStateSubGroupCard({required super.title, required super.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return SubGroupCard(
      backgroundColor: const Color(0xFFFFC2C2),
      trailing: const Icon(
        EbolsasIcons.icon_awesome_edit,
        color: Color(0xFFE62020),
        size: 22,
      ),
      leading: leading,
      title: title,
      onTap: onTap,
      titleColor: primaryColor,
      splashColor: Colors.red[400],
      internalMargin: const EdgeInsets.all(10),
    );
  }

  @override
  _ErrorStateSubGroupCard copyWith({
    String? title,
    VoidCallback? onTap,
    Widget? leading,
    Color? backgroundColor,
    EdgeInsets? internalMargin,
    Color? splashColor,
    Color? titleColor,
    Widget? trailing,
  }) =>
      _ErrorStateSubGroupCard(
        title: title ?? this.title,
        onTap: onTap ?? this.onTap,
      );
}
