import '../../../domain/usecases/usecases.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamStLouisPresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements StLouisPresenter {
  final LoadStLouis loadStLouis;

  StreamStLouisPresenter({
    required this.loadStLouis,
  });

  @override
  Future<void> loadData() async {}
}
