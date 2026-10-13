import 'package:flutter/material.dart';

import '../../core/translation/translation_controller.dart';
import '../../core/translation/translation_language.dart';

class LanguageTranslationScreen extends StatefulWidget {
  const LanguageTranslationScreen({super.key});

  @override
  State<LanguageTranslationScreen> createState() =>
      _LanguageTranslationScreenState();
}

class _LanguageTranslationScreenState
    extends State<LanguageTranslationScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);
  static const Color secondary = Color(0xFF667085);
  static const Color border = Color(0xFFE3E1F5);

  final TranslationController _translationController =
      TranslationController();

  @override
  void dispose() {
    _translationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _translationController,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: black,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_rounded),
              tooltip: 'Back',
            ),
            title: const Text(
              'Languages & Translation',
              style: TextStyle(
                color: black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
            children: [
              _sectionTitle('Language'),
              const SizedBox(height: 8),
              _settingTile(
                icon: Icons.language_rounded,
                iconColor: blue,
                title: 'App Language',
                value: 'English',
                onTap: () {
                  _showComingSoon(context, 'App Language');
                },
              ),
              const SizedBox(height: 20),
              _sectionTitle('Translation'),
              const SizedBox(height: 8),
              _settingTile(
                icon: Icons.translate_rounded,
                iconColor: purple,
                title: 'My Translation Language',
                value: _translationController
                    .myTranslationLanguage
                    .name,
                onTap: () {
                  _showTranslationLanguagePicker(context);
                },
              ),
              const SizedBox(height: 8),
              _settingTile(
                icon: Icons.auto_awesome_rounded,
                iconColor: blue,
                title: 'Auto-translate',
                value: _translationController.autoTranslate
                    ? 'On'
                    : 'Off',
                trailing: Switch.adaptive(
                  value: _translationController.autoTranslate,
                  activeTrackColor: purple,
                  onChanged: (enabled) {
                    _translationController.setAutoTranslate(enabled);
                  },
                ),
                onTap: () {
                  _translationController.setAutoTranslate(
                    !_translationController.autoTranslate,
                  );
                },
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: purple,
                      size: 21,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Choose the language you want DisstApp to use when translating posts, comments, messages, and profiles.',
                        style: TextStyle(
                          color: secondary,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: black,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _settingTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: black,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      style: const TextStyle(
                        color: secondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: secondary,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTranslationLanguagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
            children: TranslationLanguage.values.map((language) {
              final selected = _translationController
                      .myTranslationLanguage ==
                  language;

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                leading: Icon(
                  Icons.translate_rounded,
                  color: selected ? purple : secondary,
                ),
                title: Text(
                  language.name,
                  style: TextStyle(
                    color: black,
                    fontWeight:
                        selected ? FontWeight.w800 : FontWeight.w600,
                  ),
                ),
                trailing: selected
                    ? const Icon(
                        Icons.check_rounded,
                        color: purple,
                      )
                    : null,
                onTap: () {
                  _translationController
                      .setTranslationLanguage(language);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title settings will be connected later.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}