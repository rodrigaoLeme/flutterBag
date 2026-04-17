import '../../../../data/usecases/dashboard/remote_load_schedule.dart';
import '../../../../domain/usecases/dashboard/load_schedule.dart';
import '../../http/http.dart';

LoadSchedule makeRemoteLoadSchedule() => RemoteLoadSchedule(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('schedule/'),
    );
