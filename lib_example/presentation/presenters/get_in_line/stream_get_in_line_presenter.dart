import '../../../domain/usecases/get_in_line/load_get_in_line.dart';
import '../../../ui/modules/modules.dart';
import '../../mixins/mixins.dart';

class StreamGetInLinePresenter
    with SessionManager, LoadingManager, NavigationManager, UIErrorManager
    implements GetInLinePresenter {
  final LoadGetInLine loadGetInLine;

  StreamGetInLinePresenter({
    required this.loadGetInLine,
  });

  @override
  Future<void> loadData() async {}
}
