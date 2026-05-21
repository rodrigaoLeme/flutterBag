import 'package:flutter/material.dart';

import '../../../main/di/injection_container.dart';
import '../../../main/factories/pages/home/home_presenter_factory.dart';
import '../../../main/factories/pages/notices_terms/notices_terms_page_factory.dart';
import '../../../main/factories/pages/profile/profile_page_factory.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../share/current_account.dart';
import '../../components/components.dart';
import '../../helpers/themes/themes.dart';
import '../notices_terms/notices_terms_page.dart';
import '../notices_terms/notices_terms_presenter.dart';
import 'home_presenter.dart';
import 'home_tabs.dart';
import 'processes_page.dart';

final appStrings = AppI18n.current;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  HomeTab _currentTab = HomeTab.process;

  late final NoticesTermsPresenter _noticesPresenter;
  late final HomePresenter _homePresenter;

  @override
  void initState() {
    super.initState();
    _noticesPresenter = makeNoticesTermsPresenter();
    _homePresenter = makeHomePresenter();
  }

  @override
  void dispose() {
    _noticesPresenter.dispose();
    _homePresenter.dispose();
    super.dispose();
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
          '${appStrings.homeWelcome} ${sl<CurrentAccount>().name.split(' ').first}!',
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
            presenter: _noticesPresenter,
            showAppBar: false,
          ),
          ProcessesPage(
            presenter: _homePresenter,
          ),
          makeProfilePage(),
        ],
      ),
      bottomNavigationBar: EbolsaNavBar(
        currentTab: _currentTab,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
