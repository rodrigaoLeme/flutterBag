import '../../../../domain/usecases/notices/load_announcements.dart';
import '../../../../infra/repositories/notices/remote_load_announcements_usecase.dart';
import '../../http/http_factories.dart';

LoadAnnouncementsUsecase makeRemoteLoadAnnouncements() =>
    RemoteLoadAnnouncementsUsecase(
      httpClient: makeDioAdapter(),
    );
