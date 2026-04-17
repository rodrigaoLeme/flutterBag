import 'package:flutter/material.dart';

import '../../../../ui/modules/documents/documents_page.dart';
import 'documents_presenter_factory.dart';

Widget makeDocumentsPage() =>
    DocumentsPage(presenter: makeDocumentsPresenter());
