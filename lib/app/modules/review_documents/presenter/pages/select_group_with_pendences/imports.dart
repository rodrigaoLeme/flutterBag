import 'package:flutter_modular/flutter_modular.dart';

import 'page.dart';
import 'store.dart';

final page = ChildRoute('/', child: (_, args) => Page(scholarshipWithPendencesParams: args.data));
final store = Bind((i) => Store(i(), i(), i(), i()));
