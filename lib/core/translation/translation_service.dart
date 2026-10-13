import 'translation_language.dart';

class TranslationService {
  Future<String> translate({
    required String text,
    required TranslationLanguage targetLanguage,
  }) async {
    if (text.trim().isEmpty) {
      return '';
    }

    // Translation API/backend za a haɗa daga baya.
    // A yanzu muna mayar da original text domin foundation
    // ɗinmu ya kasance a shirye ba tare da API ba.
    return text;
  }
}