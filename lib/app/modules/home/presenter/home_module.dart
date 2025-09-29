import 'package:flutter_modular/flutter_modular.dart';

import '../../review_documents/review_documents_module.dart';
import 'home_page.dart';
import 'imports/finish_sending_documents_imports.dart';
import 'imports/get_authorized_especial_users_imports.dart';
import 'imports/get_family_members_by_scholarship_imports.dart';
import 'imports/get_process_periods_imports.dart';
import 'imports/get_processes_years_imports.dart';
import 'imports/get_scholarship_by_period_imports.dart';
import 'imports/set_device_code_imports.dart';
import 'pages/group_document_params.dart';
import 'pages/group_params.dart';
import 'pages/required_accepted_documents/controller.dart'
    as required_accepted_documents;
import 'pages/required_accepted_documents/page.dart'
    as required_accepted_documents;
import 'pages/scholarship_params.dart';
import 'pages/select_group/select_group_controller.dart';
import 'pages/select_group/select_group_page.dart';
import 'pages/select_group_document/controller.dart';
import 'pages/select_group_document/page.dart';
import 'pages/select_group_document/stores/usecases/get_accepted_documents_by_proof/imports.dart'
    as accepted_documents_usecase;
import 'pages/select_group_document/stores/usecases/get_proofs_by_family_params/imports.dart'
    as get_proofs_usecase;
import 'pages/select_group_document/stores/usecases/take_photo/controller.dart'
    as camera;
import 'pages/select_group_document/stores/usecases/take_photo/page.dart'
    as camera;
import 'pages/stores/usecases/get_document_by_file_id/imports.dart'
    as get_document_by_file_id;
import 'pages/stores/usecases/send_proof_documents/imports.dart'
    as send_proof_documents;
import 'pages/view_photo/page.dart' as view_photo;
import 'stores/home_store.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind<HomeStore>((i) => HomeStore(i(), i(), i(), i(), i(), i()),
        onDispose: (store) => store.destroy()),
    ...getProcessesYearsUsecaseBinds,
    ...getProcessPeriodsUsecaseBinds,
    ...getScholarshipByPeriodUsecaseBinds,
    ...getFamilyMembersByScholarshipUsecaseBinds,
    ...get_proofs_usecase.imports,
    ...accepted_documents_usecase.imports,
    ...send_proof_documents.imports,
    ...get_document_by_file_id.imports,
    ...finishSendingDocumentsUsecaseBinds,
    ...setDeviceCodeBinds,
    ...getAuthorizedEspecialUserUsecaseBinds,
    Bind((i) => SelectGroupController(i(), i(), i(), i(), i())),
    Bind<Controller>((i) => Controller(i(), i(), i(), i(), i(), i()),
        onDispose: (store) => store.destroy()),
    Bind((i) => ScholarshipParams()),
    Bind((i) => GroupParams.empty()),
    Bind((i) => GroupDocumentParams.empty()),
    Bind.factory((i) => camera.Controller()),
    Bind<required_accepted_documents.Controller>(
        (i) => required_accepted_documents.Controller(
            i(), i(), i(), i(), i(), i()),
        onDispose: (store) => store.destroy()),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const HomePage()),
    ChildRoute('/select_group', child: (_, args) => const SelectGroupPage()),
    ChildRoute('/select_group_document', child: (_, args) => const Page()),
    ChildRoute('/camera', child: (_, args) => const camera.Page()),
    ChildRoute('/required_accepted_documents',
        child: (_, args) => const required_accepted_documents.Page()),
    ChildRoute('/view_photo',
        child: (_, args) => view_photo.Page(controller: args.data)),
    ModuleRoute('/review_documents_with_pendences',
        module: ReviewDocumentsModule())
  ];
}
