import 'package:flutter/material.dart';

import '../../../main/factories/pages/notices_terms/notices_terms_page_factory.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import '../notices_terms/notices_terms_page.dart';
import '../notices_terms/notices_terms_presenter.dart';
import 'home_tabs.dart';

final appStrings = AppI18n.current;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeTab _currentTab = HomeTab.home;

  // ignore: unused_field
  late final NoticesTermsPresenter _noticesPresenter;

  @override
  void initState() {
    super.initState();
    _noticesPresenter = makeNoticesTermsPresenter();
  }

  void _onTabSelected(HomeTab tab) {
    setState(() => _currentTab = tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        titleSpacing: 20,
        actionsPadding: EdgeInsets.only(
          right: 4,
        ),
        centerTitle: false,
        title: Text(
          'Olá, Maria!',
          style: AppTextStyles.titleLarge.copyWith(
            fontSize: 22,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu), // Ícone do botão
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: EbolsaEndDrawer(
        currentTab: _currentTab,
        onTabSelected: _onTabSelected,
      ),
      body: IndexedStack(
        index: _currentTab.tabIndex,
        children: [
          NoticesTermsPage(
            presenter: makeNoticesTermsPresenter(),
            showAppBar: false,
          ),
          _HomeContent(currentTab: _currentTab),
          _PerfilPage(),
        ],
      ),
      bottomNavigationBar: EbolsaNavBar(
        currentTab: _currentTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  final HomeTab currentTab;
  const _HomeContent({required this.currentTab});

  @override
  State<_HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> {
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
                ? _Year2027Content()
                : Center(
                    child: Text(
                      'Conteúdo do ano $_selectedYear',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
          ),
        )
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
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.backgroundLight,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_YearSelectorDelegate oldDelegate) =>
      oldDelegate.child != child;
}

class _Year2027Content extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 12, top: 20, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            appStrings.homeTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            appStrings.homeSubtitleEmptyProcess,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 40),
          EbolsaButton(
            onPressed: () {},
            label: appStrings.homeRenewScholarshipButton,
          ),
          const SizedBox(height: 16),
          EbolsaButton(
            onPressed: () {},
            label: appStrings.homeNewScholarshipButton,
            isOutlined: true,
          ),
          const SizedBox(height: 40),
          EbolsaImportantBanner(
            title: appStrings.homeImportantTitle,
            message: appStrings.homeImportantMessage,
          ),
          const SizedBox(height: 23),
        ],
      ),
    );
  }
}

class _PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Perfil — Vem da Maira'));
  }
}
