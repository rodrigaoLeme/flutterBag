import 'package:flutter/material.dart';

import '../../../../ui/modules/result_documents/document_result_page.dart';
import 'result_documents_presenter_factory.dart';

Widget makeResultDocumentsPage() => DocumentsResultPage(
      presenter: makeResultDocumentsPresenter(),
    );
