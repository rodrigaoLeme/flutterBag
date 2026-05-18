import '../../../../domain/usecases/notices/load_announcement_file.dart';
import '../../../../infra/repositories/notices/remote_load_announcement_file_usecase.dart';
import '../../http/http_factories.dart';

LoadAnnouncementFileUsecase makeRemoteLoadAnnouncementFile() =>
    RemoteLoadAnnouncementFileUsecase(
      httpClient: makeDioAdapter(),
    );
