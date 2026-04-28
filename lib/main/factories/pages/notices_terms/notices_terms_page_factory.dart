import 'package:flutter/material.dart';

import '../../../../presentation/presenters/notices_terms/stream_notices_terms_presenter.dart';
import '../../../../ui/modules/notices_terms/notices_terms_page.dart';
import '../../../../ui/modules/notices_terms/notices_terms_presenter.dart';

NoticesTermsPresenter makeNoticesTermsPresenter() =>
    StreamNoticesTermsPresenter();

Widget makeNoticesTermsPage() => NoticesTermsPage(
      presenter: makeNoticesTermsPresenter(),
    );
