import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/empty_state.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import '../../helpers/i18n/resources.dart';
import '../../mixins/loading_manager.dart';
import 'components/notification_section.dart';
import 'notification_presenter.dart';
import 'notification_view_model.dart';

class NotificationPage extends StatefulWidget {
  final NotificationPresenter presenter;
  const NotificationPage({
    super.key,
    required this.presenter,
  });

  @override
  NotificationPageState createState() => NotificationPageState();
}

class NotificationPageState extends State<NotificationPage>
    with LoadingManager {
  @override
  void initState() {
    handleLoading(context, widget.presenter.isLoadingStream);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        widget.presenter.loadData();

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: AppColors.primaryLight,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.white,
                ),
              ),
            ),
            title: Align(
              alignment: Alignment.topLeft,
              child: GcText(
                text: R.string.notificationsLabel,
                gcStyles: GcStyles.poppins,
                textSize: GcTextSizeEnum.h3,
                textStyleEnum: GcTextStyleEnum.regular,
                color: AppColors.white,
              ),
            ),
          ),
          body: StreamBuilder<NotificationViewModel?>(
            stream: widget.presenter.viewModel,
            builder: (context, snapshot) {
              final viewModel = snapshot.data;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              final isEmpty = viewModel?.notification?.isEmpty == true;
              return isEmpty
                  ? EmptyState(
                      icon: 'lib/ui/assets/images/icon/bell.svg',
                      title: R.string.messageEmpty,
                    )
                  : NotificationSection(
                      viewModel: viewModel,
                      onTap: (notificationViewModel) {
                        widget.presenter.saveNotificationRead(
                          viewModel: notificationViewModel,
                          notificationViewModel: viewModel,
                        );
                      },
                    );
            },
          ),
        );
      },
    );
  }
}
