import 'endpoints.dart';

class EndpointsV1 extends Endpoints {
  @override
  final base = 'https://api-ebolsa-dev.educadventista.org';
  final loginWithId = '/api/v1/usermanager/login';
  final refreshToken = '/api/v1/usermanager/refreshtoken';
  final baseUri = 'https://ebolsa-apl.educadventista.org/';

  const EndpointsV1();
}
