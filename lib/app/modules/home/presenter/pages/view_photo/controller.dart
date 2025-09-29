import 'dart:io';

import 'package:flutter/foundation.dart';

class Controller {
  final File file;
  final VoidCallback onTapClose;

  const Controller({required this.file, required this.onTapClose});
}
