import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import 'components/emergency_info_section.dart';
import 'emergency_presenter.dart';
import 'emergency_view_model.dart';

class EmergencyPage extends StatefulWidget {
  final EmergencyPresenter presenter;

  const EmergencyPage({
    super.key,
    required this.presenter,
  });

  @override
  EmergencyPageState createState() => EmergencyPageState();
}

class EmergencyPageState extends State<EmergencyPage>
    with NavigationManager, LoadingManager {
  @override
  void initState() {
    handleLoading(context, widget.presenter.isLoadingStream);
    handleNavigation(widget.presenter.navigateToStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      widget.presenter.loadData();

      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primaryLight,
          leading: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            behavior: HitTestBehavior.translucent,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.white,
              ),
            ),
          ),
          title: Align(
            alignment: Alignment.topLeft,
            child: GcText(
              text: R.string.emergencyInformationLabel,
              textStyleEnum: GcTextStyleEnum.semibold,
              textSize: GcTextSizeEnum.h3w5,
              color: AppColors.white,
              gcStyles: GcStyles.poppins,
            ),
          ),
        ),
        body: StreamBuilder<EmergencyViewModel?>(
          stream: widget.presenter.viewModel,
          builder: (context, snapshot) {
            final viewModel = snapshot.data;
            if (viewModel == null ||
                viewModel.result == null ||
                viewModel.result!.isEmpty) {
              return EmptyState(
                icon: 'lib/ui/assets/images/icon/truck-medical-regular.svg',
                title: R.string.messageEmpty,
              );
            }
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EmergencyInfoSection(viewModel: viewModel),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
