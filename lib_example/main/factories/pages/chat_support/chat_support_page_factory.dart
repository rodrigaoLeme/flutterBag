import 'package:flutter/material.dart';

import '../../../../ui/modules/chat_support/chat_support_page.dart';
import 'chat_support_presenter_factory.dart';

Widget makeChatSupportPage() =>
    ChatSupportPage(presenter: makeChatSupportPresenter());
