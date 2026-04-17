import '../../../../domain/helpers/helpers.dart';
import '../../../domain/entities/dashboard/dashboard.dart';
import '../../../domain/usecases/dashboard/load_schedule.dart';
import '../../http/http.dart';
import '../../models/models.dart';

class RemoteLoadSchedule implements LoadSchedule {
  final String url;
  final HttpClient httpClient;

  RemoteLoadSchedule({
    required this.httpClient,
    required this.url,
  });

  @override
  Future<ScheduleEntity> load() async {
    try {
      final httpResponse =
          await httpClient.request(url: url, method: HttpMethod.get);
      return RemoteScheduleModel.fromJson(httpResponse).toEntity();
    } on HttpError catch (error) {
      throw error == HttpError.forbidden
          ? DomainError.accessDenied
          : DomainError.unexpected;
    }
  }
}
