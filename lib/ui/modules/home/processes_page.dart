import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'helpers/processes_cards_page.dart';
import 'helpers/processes_finished_page.dart';

class ProcessesPage extends StatefulWidget {
  const ProcessesPage({super.key});

  @override
  State<ProcessesPage> createState() => _ProcessesPageState();
}

class _ProcessesPageState extends State<ProcessesPage> {
  final List<int> _years = [2027, 2026, 2025, 2024, 2023, 2022, 2021, 2020];
  int _selectedYear = 2027;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Image.asset(
            'lib/ui/assets/images/banner-home.png',
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _YearSelectorDelegate(
            child: EBolsaYearSelector(
              years: _years,
              selectedYear: _selectedYear,
              onYearSelected: (year) => setState(() => _selectedYear = year),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.backgroundLight,
            child: _selectedYear == 2027
                ? const ProcessesEmptyPage()
                : _selectedYear == 2024
                    ? const ProcessesFinishedPage()
                    : Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            'Conteúdo do ano $_selectedYear',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
          ),
        ),
      ],
    );
  }
}

class _YearSelectorDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  const _YearSelectorDelegate({required this.child});

  @override
  double get minExtent => 50;

  @override
  double get maxExtent => 50;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: AppColors.backgroundLight,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_YearSelectorDelegate oldDelegate) =>
      oldDelegate.child != child;
}
