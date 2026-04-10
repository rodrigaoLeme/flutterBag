import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../presentation/mixins/loading_manager.dart';
import '../../../presentation/presenters/result_documents/result_documents_view_model.dart';
import '../../mixins/mixins.dart';

abstract class ResultDocumentsPresenter {
  ValueNotifier<NavigationData?> get navigateToListener;
  Stream<LoadingData?> get isLoadingStream;
  Stream<ResultDocumentsViewModel?> get resultViewModel;

  Future<void> loadResult();
}
