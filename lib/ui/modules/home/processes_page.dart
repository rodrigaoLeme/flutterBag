import 'dart:async';

import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import 'components/cards/processes_cards_current.dart';
import 'helpers/processes_cards_page.dart';
import 'home_presenter.dart';

class ProcessesPage extends StatefulWidget {
  final HomePresenter presenter;

  const ProcessesPage({super.key, required this.presenter});

  @override
  State<ProcessesPage> createState() => _ProcessesPageState();
}

class _ProcessesPageState extends State<ProcessesPage> {
  late StreamSubscription<List<int>> _yearsSubscription;
  late StreamSubscription _loadingSubscription;

  List<int> _years = [];
  int _selectedYear = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _yearsSubscription = widget.presenter.yearsStream.listen((years) {
      if (!mounted) return;
      setState(() {
        _years = years;
        _selectedYear = widget.presenter.selectedYear;
      });
    });

    _loadingSubscription = widget.presenter.isLoadingStream.listen((data) {
      if (!mounted) return;
      setState(() => _isLoading = data?.isLoading ?? false);
    });

    widget.presenter.loadInitialData();
  }

  @override
  void dispose() {
    _yearsSubscription.cancel();
    _loadingSubscription.cancel();
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Image.asset(AppImages.bannerHome),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _YearSelectorDelegate(
            hasYears: _years.isNotEmpty,
            child: _years.isEmpty
                ? const SizedBox.shrink()
                : EBolsaYearSelector(
                    years: _years,
                    selectedYear: _selectedYear,
                    onYearSelected: (year) {
                      setState(() => _selectedYear = year);
                      widget.presenter.onYearSelected(year);
                    },
                  ),
          ),
        ),
        SliverToBoxAdapter(
          child: _isLoading
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : _buildContent(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (_years.isEmpty) return const SizedBox.shrink();

    return StreamBuilder(
      stream: widget.presenter.scholarshipsStream,
      builder: (context, snapshot) {
        final scholarships = snapshot.data ?? [];

        // Sem incrições no ano -> tela vazia
        if (scholarships.isEmpty) {
          return ProcessesEmptyPage(
            yearSelected: _selectedYear,
          );
        }

        //TODO: dependendo do retorno exibe telas diferentes
        return ProcessesCurrentPage(
          yearSelected: _selectedYear,
          processesBanner: ProcessesBanner.warning,
        );
      },
    );
  }
}

class _YearSelectorDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final bool hasYears;

  const _YearSelectorDelegate({
    required this.child,
    required this.hasYears,
  });

  @override
  double get minExtent => hasYears ? 50 : 0;

  @override
  double get maxExtent => hasYears ? 50 : 0;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    if (!hasYears) return const SizedBox.shrink();
    return Container(
      color: AppColors.backgroundLight,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_YearSelectorDelegate oldDelegate) =>
      oldDelegate.child != child || oldDelegate.hasYears != hasYears;

// TODO: Remover depois
// Tipos de Retornos para processes_page para consulta posterior
// Container(
//             color: AppColors.backgroundLight,
//             child: _selectedYear == 2027
//                 ? const ProcessesEmptyPage()
//                 : _selectedYear == 2026
//                     ? ProcessesCurrentPage(
//                         yearSelected: _selectedYear,
//                         processesBanner: ProcessesBanner.warning,
//                       )
//                     : _selectedYear == 2025
//                         ? ProcessesCurrentPage(
//                             yearSelected: _selectedYear,
//                             processesBanner: ProcessesBanner.pending)
//                         : _selectedYear == 2024
//                             ? ProcessesCurrentPage(
//                                 yearSelected: _selectedYear,
//                                 processesBanner: ProcessesBanner.error)
//                             : _selectedYear == 2023
//                                 ? ProcessesFinishedPage(
//                                     yearSelected: _selectedYear,
//                                   )
//                                 : Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(24),
//                                       child: Text(
//                                         'Conteúdo do ano $_selectedYear',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyLarge,
//                                       ),
//                                     ),
//                                   ),
//           ),
}
