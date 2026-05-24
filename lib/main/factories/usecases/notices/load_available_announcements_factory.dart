import '../../../../domain/usecases/notices/load_available_announcements.dart';
import '../../../../infra/repositories/notices/remote_load_available_announcements_usecase.dart';
import '../../http/http_factories.dart';

LoadAvailableAnnouncementsUsecase makeRemoteLoadAvailableAnnouncements() =>
    RemoteLoadAvailableAnnouncementsUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );
