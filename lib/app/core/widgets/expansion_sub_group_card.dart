import 'package:expansion_widget/expansion_widget.dart';
import 'package:flutter/material.dart';

import 'sub_group_card.dart';

///On E-Bolsas's mockup, it represents a `Comprovante de endereço`.

///Touch-based
class ExpansionSubGroupCard extends StatelessWidget {
  final SubGroupCard subGroupCard;
  final Widget content;
  final Widget? trailingWhenExpanded;
  const ExpansionSubGroupCard({Key? key, required this.subGroupCard, required this.content, this.trailingWhenExpanded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionWidget(
      titleBuilder: (animationValue, easeInValue, isExpanded, toggleFunction) => subGroupCard.copyWith(
        onTap: () {
          subGroupCard.onTap();
          toggleFunction(animated: true);
        },
        trailing: isExpanded ? trailingWhenExpanded : subGroupCard.trailing,
      ),
      content: content,
    );
  }
}

///I created this one because I needed the expansion to happen after `isExpanded` changed.
class ExpansionSubGroupCardV2 extends StatelessWidget {
  final SubGroupCard subGroupCard;
  final Widget content;
  final bool isExpanded;
  final Widget? trailingWhenExpanded;
  const ExpansionSubGroupCardV2({Key? key, required this.subGroupCard, required this.content, required this.isExpanded, this.trailingWhenExpanded}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpansionWidget(
      key: UniqueKey(),
      initiallyExpanded: isExpanded,
      titleBuilder: (_, __, ___, ____) => subGroupCard.copyWith(trailing: isExpanded ? trailingWhenExpanded : null),
      content: content,
    );
  }
}
