import 'package:flutter/material.dart';

import '../icons/ebolsas_icons_icons.dart';

class GroupCard extends StatelessWidget {
  final Widget leading;
  final String title;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? splashColor;

  const GroupCard({Key? key, required this.leading, required this.title, required this.onTap, this.trailing, this.backgroundColor, this.titleColor, this.splashColor}) : super(key: key);

  const factory GroupCard.initial({required Widget leading, required String title, required VoidCallback onTap}) = _InitialStateGroupCard;
  const factory GroupCard.success({required Widget leading, required String title, required VoidCallback onTap}) = _SuccessStateGroupCard;
  const factory GroupCard.error({required Widget leading, required String title, required VoidCallback onTap}) = _ErrorStateGroupCard;

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
          margin: const EdgeInsets.all(14),
          child: Row(
            children: [
              leading,
              const SizedBox(width: 17),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing != null) trailing!
            ],
          ),
        ),
      ),
    );
  }
}

class _InitialStateGroupCard extends GroupCard {
  const _InitialStateGroupCard({required super.leading, required super.title, required super.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GroupCard(
      backgroundColor: const Color(0xFFF1FAFF),
      trailing: Icon(
        Icons.navigate_next_rounded,
        color: primaryColor,
      ),
      leading: leading,
      title: title,
      onTap: onTap,
      titleColor: primaryColor,
      splashColor: Colors.blue[400],
    );
  }
}

class _SuccessStateGroupCard extends GroupCard {
  const _SuccessStateGroupCard({required super.leading, required super.title, required super.onTap});

  @override
  Widget build(BuildContext context) {
    const successColor = Color(0xFF00A357);
    return GroupCard(
      backgroundColor: const Color(0xFFDCFFEF),
      trailing: const Icon(
        EbolsasIcons.check,
        color: successColor,
      ),
      leading: leading,
      title: title,
      onTap: onTap,
      titleColor: successColor,
      splashColor: Colors.white,
    );
  }
}

class _ErrorStateGroupCard extends GroupCard {
  const _ErrorStateGroupCard({required super.leading, required super.title, required super.onTap});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return GroupCard(
      backgroundColor: const Color(0xFFFFC2C2),
      trailing: Icon(
        Icons.navigate_next_rounded,
        color: primaryColor,
      ),
      leading: leading,
      title: title,
      onTap: onTap,
      titleColor: primaryColor,
      splashColor: Colors.red[400],
    );
  }
}
