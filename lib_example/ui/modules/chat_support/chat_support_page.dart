import 'package:flutter/material.dart';

import '../../../share/utils/app_color.dart';
import '../../components/enum/design_system_enums.dart';
import '../../components/gc_text.dart';
import '../../components/themes/gc_styles.dart';
import './components/components.dart';
import 'chat_support_presenter.dart';

class ChatSupportPage extends StatelessWidget {
  final ChatSupportPresenter presenter;

  const ChatSupportPage({
    super.key,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryLight,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.onSecundaryContainer,
              radius: 24,
              child: Icon(
                Icons.account_circle,
                size: 48.0,
                color: AppColors.white,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GcText(
                  text: 'Alfred',
                  textSize: GcTextSizeEnum.subheadline,
                  textStyleEnum: GcTextStyleEnum.bold,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.white,
                ),
                GcText(
                  text: 'Online',
                  textSize: GcTextSizeEnum.caption1,
                  textStyleEnum: GcTextStyleEnum.bold,
                  gcStyles: GcStyles.poppins,
                  color: AppColors.white,
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  SentMessageBubble(
                    message: 'Olá! Como posso ajudar?',
                    time: '12:00',
                  ),
                  ReceivedMessageBubble(
                    message: 'Estou tendo problemas com meu pedido.',
                    time: '12:01',
                  ),
                  SentMessageBubble(
                    message: 'Vamos resolver isso imediatamente!',
                    time: '12:02',
                  ),
                  ReceivedMessageBubble(
                    message: 'Muito obrigado!',
                    time: '12:03',
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: MessageInputField(),
            ),
          ],
        ),
      ),
    );
  }
}
