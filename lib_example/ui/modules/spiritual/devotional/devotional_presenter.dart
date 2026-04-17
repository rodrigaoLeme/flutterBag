import '../../../mixins/navigation_data.dart';
import '../spiritual_view_model.dart';

abstract class DevotionalPresenter {
  Stream<bool> get isSessionExpiredStream;
  Stream<NavigationData?> get navigateToStream;
  Stream<SpiritualViewModel?> get viewModel;

  Future<void> convinienceInit();
  void dispose();
  void filterBy({
    required DevotionalFilter filter,
    required SpiritualViewModel spiritualViewModel,
    required DevotionalDayPeriod type,
  });
  void setCurrentLanguageFilter({
    required DevotionalLanguages filter,
    required DevotionalDayPeriod type,
    required SpiritualViewModel spiritualViewModel,
  });
}
