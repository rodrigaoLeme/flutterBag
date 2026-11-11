import 'dart:async';

import '../../../domain/entities/announcement_enums.dart';
import '../../../domain/usecases/notices/load_available_announcements.dart';
import '../../../infra/repositories/notices/remote_load_available_announcements_usecase.dart';
import '../../../main/i18n/app_i18n.dart';
import '../../../ui/modules/home/renewal/renewal_scholarship_presenter.dart';
import '../../../ui/modules/home/renewal/renewal_scholarship_view_model.dart';

class StreamRenewalScholarshipPresenter implements RenewalScholarshipPresenter {
  final LoadAvailableAnnouncementsUsecase loadAvailableAnnouncementsUsecase;

  StreamRenewalScholarshipPresenter({
    required this.loadAvailableAnnouncementsUsecase,
  });

  final _controller = StreamController<RenewalScholarshipViewModel>.broadcast();

  @override
  Stream<RenewalScholarshipViewModel> get viewModelStream => _controller.stream;

  @override
  Future<void> load(int year) async {
    _emit(const RenewalScholarshipViewModel(isLoading: true));
    try {
      final announcements = await loadAvailableAnnouncementsUsecase.load(
        LoadAvailableAnnouncementsParams(
          year: year.toString(),
          processType: ProcessType.renewal,
        ),
      );
      _emit(RenewalScholarshipViewModel(announcements: announcements));
    } on LoadAvailableAnnouncementsException catch (e) {
      _emit(RenewalScholarshipViewModel(errorMessage: e.message));
    } catch (_) {
      _emit(RenewalScholarshipViewModel(
        errorMessage: AppI18n.current.errorUnexpected,
      ));
    }
  }

  void _emit(RenewalScholarshipViewModel viewModel) {
    if (!_controller.isClosed) _controller.add(viewModel);
  }

  @override
  void dispose() {
    _controller.close();
  }
}
