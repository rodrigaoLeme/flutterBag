import 'package:flutter/material.dart';

import '../../../../ui/modules/social_media/social_media_page.dart';
import 'social_media_presenter_factory.dart';

Widget makeSocialMediaPage() => SocialMediaPage(
      presenter: makeSocialMediaPresenter(),
    );
