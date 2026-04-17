import 'package:flutter/material.dart';

import '../../../../ui/modules/event_details/event_details_page.dart';
import 'event_details_presenter_factory.dart';

Widget makeEventDetailsPage() => EventDetailsPage(
      presenter: makeEventDetailsPresenter(),
    );
