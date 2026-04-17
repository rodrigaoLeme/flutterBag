import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../data/models/notification/remote_notification_model.dart';
import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import 'push_notification_emergency_presenter.dart';

class PushNotificationEmergencyPage extends StatefulWidget {
  final RemoteMessage message;
  final PushNotificationEmergencyPresenter presenter;
  const PushNotificationEmergencyPage({
    super.key,
    required this.message,
    required this.presenter,
  });

  @override
  State<PushNotificationEmergencyPage> createState() =>
      _PushNotificationEmergencyPageState();
}

class _PushNotificationEmergencyPageState
    extends State<PushNotificationEmergencyPage> {
  ValueNotifier<RemoteMessage?> currentMessage = ValueNotifier(null);
  @override
  void initState() {
    widget.presenter.convinienceInit();
    currentMessage.value = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: ValueListenableBuilder(
              valueListenable: currentMessage,
              builder: (context, snapshot, _) {
                return Stack(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Container(
                        color: Colors.black.withOpacity(0.2),
                      ),
                    ),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.95,
                          height: MediaQuery.of(context).size.height * 0.9,
                          padding: const EdgeInsets.only(
                              top: 48.0, left: 16.0, right: 16.0),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SvgPicture.asset(
                                      'lib/ui/assets/images/icon/bell-ring-light.svg',
                                      width: 64,
                                      height: 64,
                                      color: AppColors.white,
                                    ),
                                    const SizedBox(height: 48),
                                    GcText(
                                      text: snapshot?.notification?.title ?? '',
                                      textSize: GcTextSizeEnum.h2,
                                      textStyleEnum: GcTextStyleEnum.semibold,
                                      gcStyles: GcStyles.poppins,
                                      color: AppColors.white,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 24),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: GcText(
                                          text: snapshot?.notification?.body ??
                                              '',
                                          textSize: GcTextSizeEnum.callout,
                                          textStyleEnum:
                                              GcTextStyleEnum.regular,
                                          gcStyles: GcStyles.poppins,
                                          color: AppColors.white,
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 46,
                                height: 46,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.neutralHigh,
                                ),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.neutralLowDark,
                                    size: 26,
                                  ),
                                  onPressed: () async {
                                    try {
                                      final reaNotification =
                                          NotificationResultModel.fromJson(
                                        currentMessage.value?.data ?? {},
                                      ).toEntity();
                                      final result = await widget.presenter
                                          .saveNotificationRead(
                                              notificationRead:
                                                  reaNotification);
                                      if (result != null) {
                                        currentMessage.value =
                                            result.toRemoteNotification();
                                      } else {
                                        Navigator.pop(context);
                                      }
                                    } catch (_) {
                                      Navigator.pop(context);
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 46,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
        );
      },
    );
  }
}
