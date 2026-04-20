import 'package:flutter_modular/flutter_modular.dart';

import 'page.dart';
import 'store.dart';

const route = 'select_group_document_with_pendences';
final page = ChildRoute('/$route', child: (_, args) => Page(groupWithPendencesDto: args.data));
final store = Bind((i) => Store(i(), i(), i(), i()));
