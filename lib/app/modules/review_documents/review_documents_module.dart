import 'package:flutter_modular/flutter_modular.dart';

import 'presenter/stores/usecases/finish_sending_documents_with_pendences/imports.dart' as finish_sending_documents_with_pendences;
import 'presenter/stores/usecases/get_family_members_with_pendences_by_scholarship/imports.dart'
    as get_family_members_with_pendences_by_scholarship;
import 'presenter/stores/usecases/get_latest_scholarship_review_by_scholarship_id/imports.dart'
    as get_latest_scholarship_review_by_scholarship_id;
import 'presenter/stores/usecases/get_proofs_with_pendences_by_family_params/imports.dart' as get_proofs_with_pendences_by_family_params;
import 'presenter/stores/usecases/send_proof_documents_with_pendences/imports.dart' as send_proof_documents_with_pendences;

import 'presenter/pages/select_group_with_pendences/imports.dart' as select_group;
import 'presenter/pages/select_group_document_with_pendences/imports.dart' as select_group_document;
import 'presenter/pages/required_documents_with_pendences/imports.dart' as required_documents;

class ReviewDocumentsModule extends Module {
  @override
  final List<Bind> binds = [
    //Usecases imports
    ...finish_sending_documents_with_pendences.imports,
    ...get_family_members_with_pendences_by_scholarship.imports,
    ...get_latest_scholarship_review_by_scholarship_id.imports,
    ...get_proofs_with_pendences_by_family_params.imports,
    ...send_proof_documents_with_pendences.imports,

    //Pages stores
    select_group.store,
    select_group_document.store,
    required_documents.store,
  ];

  @override
  final List<ModularRoute> routes = [
    select_group.page,
    select_group_document.page,
    required_documents.page,
  ];
}
