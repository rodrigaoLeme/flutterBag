import 'package:flutter/material.dart';

import 'custom_rounded_button.dart';

class SelectOptionWidget extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(int) onChanged;
  final int selectedIndex;
  const SelectOptionWidget({Key? key, required this.items, required this.onChanged, this.title = '', required this.selectedIndex}) : super(key: key);

  @override
  State<SelectOptionWidget> createState() => _SelectOptionWidgetState();
}

class _SelectOptionWidgetState extends State<SelectOptionWidget> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  void onSelect(int index) {
    widget.onChanged(index);
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final child = GridView.builder(
      shrinkWrap: true,
      itemCount: widget.items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisExtent: 40, mainAxisSpacing: 16),
      itemBuilder: (context, index) {
        final items = widget.items;
        return CustomRoundedButton(
          backgroundColor: selectedIndex == index ? primaryColor : const Color(0xFFF1FAFF),
          label: items[index],
          labelColor: selectedIndex == index ? Colors.white : primaryColor,
          onTap: () => onSelect(index),
        );
      },
    );
    final buildWidget = widget.title.isEmpty
        ? child
        : Column(
            children: [
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 16,
                  color: primaryColor
                ),
              ),
              const SizedBox(height: 24),
              child
            ],
          );
    return buildWidget;
  }
}
