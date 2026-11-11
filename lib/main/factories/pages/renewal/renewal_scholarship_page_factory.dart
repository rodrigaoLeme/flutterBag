import 'package:flutter/material.dart';

import '../../../../presentation/presenters/renewal/stream_renewal_scholarship_presenter.dart';
import '../../../../ui/modules/home/renewal/renewal_scholarship_page.dart';
import '../../../../ui/modules/home/renewal/renewal_scholarship_presenter.dart';
import '../../usecases/notices/load_available_announcements_factory.dart';

RenewalScholarshipPresenter makeRenewalScholarshipPresenter() =>
    StreamRenewalScholarshipPresenter(
      loadAvailableAnnouncementsUsecase: makeRemoteLoadAvailableAnnouncements(),
    );

Widget makeRenewalScholarshipPage({required int year}) =>
    RenewalScholarshipPage(
      presenter: makeRenewalScholarshipPresenter(),
      year: year,
    );
