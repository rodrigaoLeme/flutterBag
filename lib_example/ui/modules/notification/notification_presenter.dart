import '../../../domain/entities/notification/notification_entity.dart';
import '../../../presentation/mixins/loading_manager.dart';
import '../../mixins/mixins.dart';
import 'notification_view_model.dart';

abstract class NotificationPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<LoadingData?> get isLoadingStream;
  Stream<NotificationViewModel?> get viewModel;

  Future<void> loadData();
  Future<List<NotificationResultEntity>?> loadNotificationRead();
  Future<void> saveNotificationRead({
    required NotificationResultViewModel viewModel,
    required NotificationViewModel? notificationViewModel,
  });
  void dispose();
}
