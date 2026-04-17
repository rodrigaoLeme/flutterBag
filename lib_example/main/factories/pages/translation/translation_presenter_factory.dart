import '../../../../presentation/presenters/translation/stream_translation_presenter.dart';
import '../../../../ui/modules/translation/translation_presenter.dart';
import '../../usecases/translation/load_current_translation_factory.dart';
import '../../usecases/translation/save_current_translation_factory.dart';

TranslationPresenter makeTranslationPresenter() => StreamTranslationPresenter(
      saveCurrentTranslation: makeSaveCurrentTranslation(),
      loadCurrentTranslation: makeLoadCurrentTranslation(),
    );
