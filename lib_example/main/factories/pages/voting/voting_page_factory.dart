import 'package:flutter/material.dart';

import '../../../../ui/modules/modules.dart';
import '../../factories.dart';

Widget makeVotingPage() => VotingPage(
      presenter: makeVotingPresenter(),
    );
