import 'package:flutter/material.dart';

import '../../../presentation/presenters/result_documents/result_documents_view_model.dart';
import 'components/card_result_section.dart';
import 'result_documents_presenter.dart';

class DocumentsResultPage extends StatefulWidget {
  final ResultDocumentsPresenter presenter;

  const DocumentsResultPage({
    super.key,
    required this.presenter,
  });

  @override
  State<DocumentsResultPage> createState() => _DocumentsResultPageState();
}

class _DocumentsResultPageState extends State<DocumentsResultPage> {
  @override
  void initState() {
    widget.presenter.loadResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF003366),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
        color: Colors.white,
        child: const Text(
          'Em caso de dúvida, entre em contato com a unidade escolar.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xff758EB3),
          ),
        ),
      ),
      body: StreamBuilder<ResultDocumentsViewModel?>(
          stream: widget.presenter.resultViewModel,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.sticky_note_2,
                      color: Color(0xFFF2A600),
                      size: 24,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Resultado',
                      style: TextStyle(
                        color: Color(0xFFF2A600),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CardResultSection(
                  viewModel: snapshot.data,
                ),
              ],
            );
          }),
    );
  }
}
