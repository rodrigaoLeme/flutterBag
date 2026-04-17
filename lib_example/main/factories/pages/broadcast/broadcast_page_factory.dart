import 'package:flutter/material.dart';

import '../../../../ui/modules/broadcast/broadcast_page.dart';
import 'broadcast_presenter_factory.dart';

Widget makeBroadcastPage() => BroadcastPage(
      presenter: makeBroadcastPresenter(),
    );
