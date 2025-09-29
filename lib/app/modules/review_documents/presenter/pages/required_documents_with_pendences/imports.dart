import 'package:flutter_modular/flutter_modular.dart';

import 'page.dart';
import 'store.dart';

const route = 'required_accepted_documents_with_pendences';
final page = ChildRoute('/$route', child: (_, args) => Page(requiredDocumentsWithPendencesDto: args.data));
final store = Bind((i) => Store(i(), i(), i(), i()));
