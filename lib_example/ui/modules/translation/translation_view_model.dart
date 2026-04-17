class TranslationViewModel {
  final Languages? currentLanguage;
  final bool isTranslateEnable;

  TranslationViewModel({
    required this.currentLanguage,
    required this.isTranslateEnable,
  });

  List<Languages> get languages {
    return Languages.values;
  }
}

enum Languages {
  en('en'),
  pt('pt'),
  es('es'),
  fr('fr'),
  ru('ru');

  const Languages(this.type);
  final String type;

  String get locale {
    switch (this) {
      case Languages.pt:
        return 'pt_BR';
      case Languages.en:
        return 'en';
      case Languages.es:
        return 'es';
      case Languages.fr:
        return 'fr';
      case Languages.ru:
        return 'ru';
    }
  }

  String get contryName {
    switch (this) {
      case en:
        return 'English';
      case pt:
        return 'Português';
      case es:
        return 'Español';
      case fr:
        return 'French';
      case ru:
        return 'Russo';
    }
  }

  String get flag {
    switch (this) {
      case en:
        return 'lib/ui/assets/images/countries/en.png';
      case pt:
        return 'lib/ui/assets/images/countries/br.png';
      case es:
        return 'lib/ui/assets/images/countries/es.png';
      case fr:
        return 'lib/ui/assets/images/countries/fr.png';
      case ru:
        return 'lib/ui/assets/images/countries/ru.png';
    }
  }
}
