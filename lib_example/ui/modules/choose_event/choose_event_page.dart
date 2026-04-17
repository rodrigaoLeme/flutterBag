import 'package:flutter/material.dart';

import '../../../presentation/presenters/navigation_bar/tab_bar_itens.dart';
import '../../../share/utils/app_color.dart';
import '../../components/empty_state_view.dart';
import '../../helpers/helpers.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import '../navigation/navigation_bar_presenter.dart';
import 'choose_event_presenter.dart';
import 'choose_event_view_model.dart';
import 'components/event_main_section.dart';

class ChooseEventPage extends StatefulWidget {
  final ChooseEventPresenter presenter;
  final NavigationBarPresenter tabBarPresenter;

  const ChooseEventPage({
    super.key,
    required this.presenter,
    required this.tabBarPresenter,
  });

  @override
  ChooseEventPageState createState() => ChooseEventPageState();
}

class ChooseEventPageState extends State<ChooseEventPage>
    with NavigationManager, LoadingManager {
  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToStream);
    handleLoading(context, widget.presenter.isLoadingStream);
    super.initState();
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      widget.presenter.loadData();

      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: StreamBuilder<ChooseEventViewModel?>(
            stream: widget.presenter.viewModel,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              if (snapshot.data == null ||
                  snapshot.data?.result.isEmpty == true) {
                return SizedBox(
                  width: ResponsiveLayout.of(context).wp(100),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 32, horizontal: 32),
                    child: EmptyStateView(
                      icon: 'lib/ui/assets/images/icon/error_icon.png',
                      title: R.string.anErrorHasOccurred,
                      subtitle: R.string.eventsAvailableSoon,
                      onPressed: widget.presenter.loadData,
                    ),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: EventMainSection(
                    viewModel: snapshot.data,
                    onTap: (event) async {
                      await widget.presenter.selectCurrentEvent(event);
                      widget.tabBarPresenter
                          .setCurrentTab(tab: TabBarItens.home);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
    });
  }
}
