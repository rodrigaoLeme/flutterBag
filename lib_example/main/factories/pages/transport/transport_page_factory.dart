import 'package:flutter/material.dart';

import '../../../../ui/modules/transport/transport_page.dart.dart';
import 'transport_presenter_factory.dart';

Widget makeTransportPage() => TransportPage(
      presenter: makeTransportPresenter(),
    );
