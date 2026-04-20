import '../../../../../core/endpoints/endpoints_v2_dev.dart';
import '../../../../../core/services/http_client/base/http_client.dart';
import '../../../domain/usecases/get_family_members_by_scholarship/entity.dart';
import '../../../domain/usecases/get_family_members_by_scholarship/exceptions.dart';
import '../../../domain/usecases/get_family_members_by_scholarship/params.dart';
import '../../../infra/usecases/get_family_members_by_scholarship/datasource.dart';
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
      final result = await _client
          .get(_endpoints.familyMembers(scholarshipId: params.scholarshipId));
      result.fold(
        (exception) {
          //TODO(adbysantos) Tratar as exceções de GetFamilyMembersByScholarship
          if (exception.message.contains('500')) {
            throw ServerException();
          }
          throw exception;
        },
        (response) {
          entity = _mapper.fromListToEntity(response.data);
        },
      );
      return entity;
    } catch (e) {
      rethrow;
    }
  }
}
