import 'renewal_scholarship_view_model.dart';

abstract class RenewalScholarshipPresenter {
  Stream<RenewalScholarshipViewModel> get viewModelStream;

  Future<void> load(int year);

  void dispose();
}
