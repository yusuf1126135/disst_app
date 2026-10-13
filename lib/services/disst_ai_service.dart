class DisstAiService {
  const DisstAiService();

  Future<String> sendMessage(String message) async {
    final text = message.trim();

    if (text.isEmpty) {
      return '';
    }

    // AI backend will be connected here.
    // Keep this service separate from the UI.
    return 'Disst.AI is ready. AI connection will be added here.';
  }
}