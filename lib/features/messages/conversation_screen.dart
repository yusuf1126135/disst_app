import 'package:flutter/material.dart';

import 'video_call_screen.dart';

class ConversationScreen extends StatefulWidget {
  final String friendName;

  const ConversationScreen({
    super.key,
    required this.friendName,
  });

  @override
  State<ConversationScreen> createState() =>
      _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);
  static const Color secondary = Color(0xFF667085);
  static const Color border = Color(0xFFE3E1F5);

  final TextEditingController _messageController =
      TextEditingController();

  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Hello 👋',
      isReceived: true,
    ),
    const _ChatMessage(
      text: 'How are you?',
      isReceived: true,
    ),
  ];

  @override
  void initState() {
    super.initState();

    _messageController.addListener(_onMessageChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged);
    _messageController.dispose();
    super.dispose();
  }

  void _onMessageChanged() {
    setState(() {});
  }

  void _sendMessage() {
    final text = _messageController.text.trim();

    if (text.isEmpty) {
      return;
    }

    setState(() {
      _messages.add(
        _ChatMessage(
          text: text,
          isReceived: false,
        ),
      );
    });

    _messageController.clear();
  }

  void _sendVoiceMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Voice message feature will be connected later.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openVideoCall() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VideoCallScreen(
          friendName: widget.friendName,
        ),
      ),
    );
  }

  bool get _isTyping =>
      _messageController.text.trim().isNotEmpty;

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
        titleSpacing: 0,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 19,
              backgroundColor: purple,
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.friendName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Active now',
                    style: TextStyle(
                      color: Color(0xFF22C55E),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.call_outlined,
              color: black,
            ),
            tooltip: 'Voice call',
          ),
          IconButton(
            onPressed: _openVideoCall,
            icon: const Icon(
              Icons.videocam_outlined,
              color: black,
            ),
            tooltip: 'Video call',
          ),
          IconButton(
            onPressed: () {
              _showChatOptions(context);
            },
            icon: const Icon(
              Icons.more_vert_rounded,
              color: black,
            ),
            tooltip: 'Chat options',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                20,
                16,
                20,
              ),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];

                return _buildMessageBubble(
                  message.text,
                  message.isReceived,
                );
              },
            ),
          ),
          _buildComposer(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    String message,
    bool received,
  ) {
    return Align(
      alignment: received
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: 290,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: received
              ? const Color(0xFFF4F2FF)
              : purple,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(17),
            topRight: const Radius.circular(17),
            bottomLeft: Radius.circular(
              received ? 4 : 17,
            ),
            bottomRight: Radius.circular(
              received ? 17 : 4,
            ),
          ),
          border: received
              ? Border.all(color: border)
              : null,
        ),
        child: Text(
          message,
          style: TextStyle(
            color: received ? black : Colors.white,
            fontSize: 14.5,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          10,
          8,
          10,
          8,
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
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.image_outlined,
                color: purple,
              ),
              tooltip: 'Photo',
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.emoji_emotions_outlined,
                color: blue,
              ),
              tooltip: 'Emoji',
            ),
            Expanded(
              child: TextField(
                controller: _messageController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) {
                  if (_isTyping) {
                    _sendMessage();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: const TextStyle(
                    color: secondary,
                    fontSize: 13.5,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF7F7FA),
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 11,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              transitionBuilder: (
                Widget child,
                Animation<double> animation,
              ) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: IconButton(
                key: ValueKey<bool>(_isTyping),
                onPressed: _isTyping
                    ? _sendMessage
                    : _sendVoiceMessage,
                icon: Icon(
                  _isTyping
                      ? Icons.send_rounded
                      : Icons.mic_rounded,
                  color: purple,
                ),
                tooltip: _isTyping
                    ? 'Send'
                    : 'Voice message',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showChatOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.notifications_off_outlined,
                  color: purple,
                ),
                title: const Text(
                  'Mute notifications',
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.push_pin_outlined,
                  color: purple,
                ),
                title: const Text(
                  'Pin conversation',
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.mark_chat_unread_outlined,
                  color: purple,
                ),
                title: const Text(
                  'Mark as unread',
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.archive_outlined,
                  color: purple,
                ),
                title: const Text(
                  'Archive',
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_outline_rounded,
                  color: purple,
                ),
                title: const Text(
                  'View profile',
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.block_outlined,
                  color: Colors.red,
                ),
                title: const Text(
                  'Block',
                ),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.flag_outlined,
                  color: Colors.red,
                ),
                title: const Text(
                  'Report',
                ),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isReceived;

  const _ChatMessage({
    required this.text,
    required this.isReceived,
  });
}