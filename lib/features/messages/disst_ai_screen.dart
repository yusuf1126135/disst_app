import 'package:flutter/material.dart';

class DisstAiScreen extends StatefulWidget {
  const DisstAiScreen({super.key});

  @override
  State<DisstAiScreen> createState() => _DisstAiScreenState();
}

class _DisstAiScreenState extends State<DisstAiScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);
  static const Color secondary = Color(0xFF667085);
  static const Color border = Color(0xFFE3E1F5);

  final TextEditingController _messageController =
      TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    // AI functionality will be connected later.
    _messageController.clear();

    FocusScope.of(context).unfocus();
  }

  void _selectSuggestion(String text) {
    setState(() {
      _messageController.text = text;
      _messageController.selection =
          TextSelection.fromPosition(
        TextPosition(
          offset: _messageController.text.length,
        ),
      );
    });
  }

  void _startNewChat() {
    setState(() {
      _messageController.clear();
    });

    FocusScope.of(context).unfocus();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New chat started'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showDisstAiMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              12,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9E3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),

                const SizedBox(height: 18),

                const Row(
                  children: [
                    Icon(
                      Icons.smart_toy_outlined,
                      color: purple,
                      size: 23,
                    ),
                    SizedBox(width: 9),
                    Text(
                      'Disst.AI Options',
                      style: TextStyle(
                        color: black,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _buildMenuItem(
                  icon: Icons.add_rounded,
                  iconColor: purple,
                  title: 'New chat',
                  onTap: () {
                    Navigator.of(context).pop();
                    _startNewChat();
                  },
                ),

                _buildMenuItem(
                  icon: Icons.history_rounded,
                  iconColor: blue,
                  title: 'Chat history',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon('Chat history');
                  },
                ),

                _buildMenuItem(
                  icon: Icons.settings_outlined,
                  iconColor: purple,
                  title: 'AI Settings',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon('AI Settings');
                  },
                ),

                _buildMenuItem(
                  icon: Icons.language_rounded,
                  iconColor: blue,
                  title: 'Language',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon('Language settings');
                  },
                ),

                _buildMenuItem(
                  icon: Icons.volume_up_outlined,
                  iconColor: purple,
                  title: 'Voice',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon('Voice settings');
                  },
                ),

                _buildMenuItem(
                  icon: Icons.info_outline_rounded,
                  iconColor: blue,
                  title: 'About Disst.AI',
                  onTap: () {
                    Navigator.of(context).pop();
                    _showComingSoon('About Disst.AI');
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 21,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: black,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                color: secondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,

        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
          ),
          tooltip: 'Back',
        ),

        title: const Row(
          children: [
            Icon(
              Icons.smart_toy_outlined,
              color: purple,
              size: 25,
            ),
            SizedBox(width: 8),
            Text(
              'Disst.AI',
              style: TextStyle(
                color: black,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),

        actions: [
          IconButton(
            onPressed: _showDisstAiMenu,
            icon: const Icon(
              Icons.more_vert_rounded,
              color: black,
            ),
            tooltip: 'Disst.AI Options',
          ),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  22,
                  20,
                  20,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: CircleAvatar(
                        radius: 31,
                        backgroundColor: Color(0xFFF0ECFF),
                        child: Icon(
                          Icons.smart_toy_outlined,
                          color: purple,
                          size: 31,
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    const Center(
                      child: Text(
                        'Hi, Yusuf 👋',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: black,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

                    const Center(
                      child: Text(
                        'How can I help you today?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondary,
                          fontSize: 14.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      '💡 What can I help with?',
                      style: TextStyle(
                        color: black,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        Expanded(
                          child: _buildSuggestionCard(
                            icon: Icons.edit_outlined,
                            iconColor: purple,
                            title: 'Write',
                            onTap: () {
                              _selectSuggestion(
                                'Help me write ',
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSuggestionCard(
                            icon: Icons.psychology_outlined,
                            iconColor: blue,
                            title: 'Explain',
                            onTap: () {
                              _selectSuggestion(
                                'Explain ',
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: _buildSuggestionCard(
                            icon: Icons.language_rounded,
                            iconColor: blue,
                            title: 'Translate',
                            onTap: () {
                              _selectSuggestion(
                                'Translate ',
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildSuggestionCard(
                            icon:
                                Icons.lightbulb_outline_rounded,
                            iconColor: purple,
                            title: 'Ideas',
                            onTap: () {
                              _selectSuggestion(
                                'Give me ideas for ',
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            _buildComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 74,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: border,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withValues(
                    alpha: 0.10,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 20,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: black,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        12,
        8,
        12,
        10,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: border,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              decoration: InputDecoration(
                hintText: 'Ask Disst.AI...',
                hintStyle: const TextStyle(
                  color: secondary,
                  fontSize: 13.5,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7FA),
                contentPadding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(23),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 5),

          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.mic_none_rounded,
              color: blue,
            ),
            tooltip: 'Voice input',
          ),

          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(
              Icons.arrow_upward_rounded,
              color: purple,
            ),
            tooltip: 'Send',
          ),
        ],
      ),
    );
  }
}