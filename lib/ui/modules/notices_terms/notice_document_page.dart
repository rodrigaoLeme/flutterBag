import 'package:flutter/material.dart';

import '../../../main/i18n/app_i18n.dart';
import '../../components/components.dart';
import '../../helpers/themes/app_colors.dart';
import 'notice_document_presenter.dart';

class NoticeDocumentPage extends StatefulWidget {
  final NoticeDocumentPresenter presenter;
  final String announcementId;
  final String title;

  const NoticeDocumentPage({
    super.key,
    required this.presenter,
    required this.announcementId,
    required this.title,
  });

  @override
  State<NoticeDocumentPage> createState() => _NoticeDocumentPageState();
}

class _NoticeDocumentPageState extends State<NoticeDocumentPage> {
  @override
  void initState() {
    super.initState();
    widget.presenter.loadFile(widget.announcementId);
  }

  @override
  void dispose() {
    widget.presenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appStrings = AppI18n.current;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primary,
      ),
      body: StreamBuilder<NoticeDocumentState>(
        stream: widget.presenter.stateStream,
        initialData: NoticeDocumentInitial(),
        builder: (context, snapshot) {
          final state = snapshot.data ?? NoticeDocumentInitial();

          if (state is NoticeDocumentLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is NoticeDocumentError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  EbolsaErrorBanner(message: state.message),
                  const SizedBox(
                    height: 16,
                  ),
                  EbolsaButton(
                    onPressed: () =>
                        widget.presenter.loadFile(widget.announcementId),
                    isOutlined: true,
                    label: appStrings.tryAgain,
                  ),
                ],
              ),
            );
          }

          if (state is NoticeDocumentSuccess) {
            return EBolsaPdfViwer.fromUrl(state.url);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
