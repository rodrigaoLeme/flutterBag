import 'package:flutter/material.dart';

import '../../../../presentation/presenters/new_scholarship/stream_new_scholarship_presenter.dart';
import '../../../../ui/modules/new_scholarship/new_scholarship_page.dart';
import '../../../../ui/modules/new_scholarship/new_scholarship_presenter.dart';
import '../../usecases/notices/load_available_announcements_factory.dart';
import '../../usecases/notices/load_schools_factory.dart';

NewScholarshipPresenter makeNewScholarshipPresenter() =>
    StreamNewScholarshipPresenter(
      loadSchoolsUsecase: makeRemoteLoadSchools(),
      loadAvailableAnnouncementsUsecase: makeRemoteLoadAvailableAnnouncements(),
    );

Widget makeNewScholarshipPage({required int lockedYear}) => NewScholarshipPage(
      presenter: makeNewScholarshipPresenter(),
      lockedYear: lockedYear,
    );
