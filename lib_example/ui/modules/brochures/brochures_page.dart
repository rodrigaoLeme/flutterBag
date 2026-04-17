import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../../ui/helpers/extensions/string_extension.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../components/view_page.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/navigation_manager.dart';
import 'brochures_presenter.dart';
import 'brochures_view_model.dart';

class BrochuresPage extends StatefulWidget {
  final BrochuresPresenter presenter;

  const BrochuresPage({
    super.key,
    required this.presenter,
  });

  @override
  BrochuresPageState createState() => BrochuresPageState();
}

class BrochuresPageState extends State<BrochuresPage>
    with NavigationManager, SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    handleNavigation(widget.presenter.navigateToStream);
    widget.presenter.loadData();
    super.initState();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Align(
          alignment: Alignment.centerLeft,
          child: GcText(
            text: R.string.brochuresLabel,
            textStyleEnum: GcTextStyleEnum.bold,
            textSize: GcTextSizeEnum.h3w5,
            color: AppColors.white,
            gcStyles: GcStyles.poppins,
          ),
        ),
      ),
      body: StreamBuilder<BrochuresViewModel?>(
        stream: widget.presenter.brochuresViewModel,
        builder: (context, snapshot) {
          final viewModel = snapshot.data;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox.shrink();
          }
          final brochures = viewModel?.brochures ?? [];
          if (brochures.isEmpty) {
            return EmptyState(
              icon: 'lib/ui/assets/images/icon/file-invoice.svg',
              title: R.string.messageEmpty,
            );
          }
          if (_tabController == null ||
              _tabController?.length != brochures.length) {
            _tabController =
                TabController(length: brochures.length, vsync: this);
          }
          return Column(
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                indicatorColor: AppColors.primaryLight,
                labelColor: AppColors.primaryLight,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                tabAlignment: TabAlignment.center,
                tabs: [
                  for (var brochure in brochures)
                    Tab(text: (brochure.title ?? '').formatToSentenceString),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    for (var brochure in brochures)
                      brochure.link == null
                          ? EmptyState(
                              icon:
                                  'lib/ui/assets/images/icon/file-invoice.svg',
                              title: R.string.messageEmpty,
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 2.0),
                              child: ViewPage(
                                url: brochure.link ?? '',
                              ),
                            ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
