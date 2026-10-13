enum TranslationLanguage {
  english,
  hausa,
  arabic,
  french,
}

extension TranslationLanguageExtension on TranslationLanguage {
  String get code {
    switch (this) {
      case TranslationLanguage.english:
        return 'en';
      case TranslationLanguage.hausa:
        return 'ha';
      case TranslationLanguage.arabic:
        return 'ar';
      case TranslationLanguage.french:
        return 'fr';
    }
  }

  String get name {
    switch (this) {
      case TranslationLanguage.english:
        return 'English';
      case TranslationLanguage.hausa:
        return 'Hausa';
      case TranslationLanguage.arabic:
        return 'Arabic';
      case TranslationLanguage.french:
        return 'French';
    }
  }
}