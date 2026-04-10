import 'package:flutter_modular/flutter_modular.dart';

import '../../../../app/core/endpoints/endpoints_v2_dev.dart';
import '../../../../app/core/services/http_client/base/http_client.dart';
import '../../../../data/usecases/result_documents/remote_load_result_documents.dart';

RemoteLoadResultDocuments makeRemoteLoadResultDocuments() {
  return RemoteLoadResultDocuments(
      httpClient: Modular.get<HttpClient>(),
      endpoints: Modular.get<EndpointsV2Dev>());
}
