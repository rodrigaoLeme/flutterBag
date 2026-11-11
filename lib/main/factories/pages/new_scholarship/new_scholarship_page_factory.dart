import 'package:flutter/material.dart';

import '../../../../domain/entities/announcement_enums.dart';
import '../../../../presentation/presenters/new_scholarship/stream_new_scholarship_presenter.dart';
import '../../../../ui/modules/new_scholarship/new_scholarship_page.dart';
import '../../../../ui/modules/new_scholarship/new_scholarship_presenter.dart';
import '../../usecases/notices/load_available_announcements_factory.dart';
import '../../usecases/notices/load_schools_factory.dart';

NewScholarshipPresenter makeNewScholarshipPresenter({
  ProcessType processType = ProcessType.newEnrollment,
}) =>
    StreamNewScholarshipPresenter(
      loadSchoolsUsecase: makeRemoteLoadSchools(),
      loadAvailableAnnouncementsUsecase: makeRemoteLoadAvailableAnnouncements(),
      processType: processType,
    );

Widget makeNewScholarshipPage({
  required int lockedYear,
  ProcessType processType = ProcessType.newEnrollment,
  String? lockedCity,
  String? lockedSchoolId,
  String? lockedSchoolName,
}) =>
    NewScholarshipPage(
      presenter: makeNewScholarshipPresenter(processType: processType),
      lockedYear: lockedYear,
      lockedCity: lockedCity,
      lockedSchoolId: lockedSchoolId,
      lockedSchoolName: lockedSchoolName,
    );
