import 'package:flutter/material.dart';

class EBolsaYearSelector extends StatefulWidget {
  final List<int> years;
  final int selectedYear;
  final ValueChanged<int> onYearSelected;

  const EBolsaYearSelector({
    super.key,
    required this.years,
    required this.selectedYear,
    required this.onYearSelected,
  });

  @override
  State<EBolsaYearSelector> createState() => _EBolsaYearSelectorState();
}

class _EBolsaYearSelectorState extends State<EBolsaYearSelector> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSelected());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelected() {
    final index = widget.years.indexOf(widget.selectedYear);
    if (index == -1) return;

    const itemWidth = 80.0;
    final screenWidth = MediaQuery.of(context).size.width;
    final offset = (index * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        itemCount: widget.years.length,
        itemExtent: 120,
        itemBuilder: (context, index) {
          final year = widget.years[index];
          final isSelected = year == widget.selectedYear;

          return GestureDetector(
            onTap: () => widget.onYearSelected(year),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                year.toString(),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
