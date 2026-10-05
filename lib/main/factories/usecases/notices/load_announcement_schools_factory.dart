import '../../../../domain/usecases/notices/load_announcement_schools.dart';
import '../../../../infra/repositories/notices/remote_load_announcement_schools_usecase.dart';
import '../../http/http_factories.dart';

LoadAnnouncementSchoolsUsecase makeRemoteLoadAnnouncementSchools() =>
    RemoteLoadAnnouncementSchoolsUsecase(
      httpClient: makeAuthorizeHttpClientDecorator(),
    );
