import 'package:flutter/material.dart';

import '../../../../presentation/presenters/notices_terms/stream_notices_terms_presenter.dart';
import '../../../../ui/modules/notices_terms/notices_terms_page.dart';
import '../../../../ui/modules/notices_terms/notices_terms_presenter.dart';
import '../../usecases/notices/load_announcements_factory.dart';
import '../../usecases/notices/load_schools_factory.dart';

NoticesTermsPresenter makeNoticesTermsPresenter() =>
    StreamNoticesTermsPresenter(
      loadSchoolsUsecase: makeRemoteLoadSchools(),
      loadAnnouncementsUsecase: makeRemoteLoadAnnouncements(),
    );

Widget makeNoticesTermsPage() => NoticesTermsPage(
      presenter: makeNoticesTermsPresenter(),
    );
