import 'dart:async';

import 'package:flutter_modular/flutter_modular.dart';

import '../../../app/core/constants/process_type.dart';
import '../../../app/modules/home/domain/usecases/get_process_periods/entity.dart'
    as process_period;
import '../../../app/modules/home/domain/usecases/get_scholarship_by_period/entity.dart'
    as scholarship;
import '../../../domain/usecases/result_documents/load_result_documents.dart';
import '../../../ui/modules/result_documents/result_documents_presenter.dart';
import '../../mixins/loading_manager.dart';
import '../../mixins/navigation_manager.dart';
import 'result_documents_view_model.dart';

class ResultDocumentsPresentation
    with NavigationManager, LoadingManager
    implements ResultDocumentsPresenter {
  final LoadResultDocuments loadResultDocuments;

  ResultDocumentsPresentation({
    required this.loadResultDocuments,
  });

  final StreamController<ResultDocumentsViewModel?> _resultViewModel =
      StreamController<ResultDocumentsViewModel?>.broadcast();

  @override
  Stream<ResultDocumentsViewModel?> get resultViewModel =>
      _resultViewModel.stream;

  @override
  Future<void> loadResult() async {
    try {
      isLoading = LoadingData(isLoading: true);
      final params = Modular.args.data as ProcessResultRoutesParams;
      final result = await loadResultDocuments.load(params.scholarships.id);
      final process = params.processPeriods;
      final ProcessType tipoProcessoVar = params.tipoProcesso;
      _resultViewModel.add(
        result?.toViewModel(
          registerEnd: process.registerEnd,
          registerStart: process.registerStart,
          schoolRegistrationBusinessDaysLimit:
              process.schoolRegistrationBusinessDaysLimit,
          resultRelease: process.resultRelease,
          tipoProcesso: tipoProcessoVar,
          year: process.year,
        ),
      );
    } catch (e) {
      _resultViewModel.addError(e);
    } finally {
      isLoading = LoadingData(isLoading: false);
    }
  }
}

class ProcessResultRoutesParams {
  final scholarship.Entity scholarships;
  final process_period.Process processPeriods;
  final ProcessType tipoProcesso;

  ProcessResultRoutesParams({
    required this.scholarships,
    required this.processPeriods,
    required this.tipoProcesso,
  });
}
