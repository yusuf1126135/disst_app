import 'package:flutter/foundation.dart';

import 'translation_language.dart';

class TranslationController extends ChangeNotifier {
  TranslationLanguage _myTranslationLanguage =
      TranslationLanguage.hausa;

  bool _autoTranslate = false;

  TranslationLanguage get myTranslationLanguage =>
      _myTranslationLanguage;

  bool get autoTranslate => _autoTranslate;

  void setTranslationLanguage(TranslationLanguage language) {
    if (_myTranslationLanguage == language) {
      return;
    }

    _myTranslationLanguage = language;
    notifyListeners();
  }

  void setAutoTranslate(bool enabled) {
    if (_autoTranslate == enabled) {
      return;
    }

    _autoTranslate = enabled;
    notifyListeners();
  }
}