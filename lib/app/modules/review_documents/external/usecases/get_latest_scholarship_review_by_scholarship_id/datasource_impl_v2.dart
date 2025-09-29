import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/entity.dart';
import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/exceptions.dart';
import '../../../domain/usecases/get_latest_scholarship_review_by_scholarship_id/params.dart';
import '../../../infra/usecases/get_latest_scholarship_review_by_scholarship_id/datasource.dart';
import 'mapper.dart';

class DatasourceImplV2 implements Datasource {
  final HttpClient _client;
  final Mapper _mapper;
  final EndpointsV2Dev _endpoints;

  const DatasourceImplV2(this._client, this._mapper, this._endpoints);

  @override
  Future<Entity> call(Params params) async {
    late Entity entity;
    try {
      final result = await _client.get(_endpoints.latestScholarshipReview(
          scholarshipId: params.scholarshipId));
      result.fold(
        (exception) {
          if (exception.message.contains('500')) {
            throw ServerException();
          }
          throw exception;
        },
        (response) {
          entity = _mapper.fromJsonToEntity(response.data);
        },
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }
}
