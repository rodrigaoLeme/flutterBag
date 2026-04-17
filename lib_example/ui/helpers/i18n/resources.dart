import '../../modules/translation/translation_view_model.dart';
import './strings/strings.dart';
import 'strings/es.dart';
import 'strings/fr.dart';
import 'strings/pt.dart';
import 'strings/ru.dart';

class R {
  static Translation string = Us();

  static void load(Languages locale) {
    switch (locale) {
      case Languages.en:
        string = Us();
      case Languages.pt:
        string = Pt();
      case Languages.es:
        string = Es();
      case Languages.ru:
        string = Ru();
      case Languages.fr:
        string = Fr();
    }
  }
}
