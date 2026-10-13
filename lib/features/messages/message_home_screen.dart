import 'package:flutter/material.dart';

import 'calls_screen.dart';
import 'conversation_screen.dart';
import 'disst_ai_screen.dart';
import 'message_search_screen.dart';
import 'message_settings_screen.dart';

enum MessageStatus {
  active,
  unread,
  offline,
}

class MessageHomeScreen extends StatelessWidget {
  const MessageHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const chats = [
      _ChatItem(
        name: 'Friend 1',
        lastMessage: 'Active now',
        status: MessageStatus.active,
      ),
      _ChatItem(
        name: 'Friend 2',
        lastMessage: '5 min ago',
        status: MessageStatus.active,
      ),
      _ChatItem(
        name: 'Friend 3',
        lastMessage: 'New message',
        status: MessageStatus.unread,
      ),
      _ChatItem(
        name: 'Friend 4',
        lastMessage: 'Yesterday',
        status: MessageStatus.offline,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF121212),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Color(0xFF121212),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Message settings',
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF121212),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MessageSettingsScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Calls',
            icon: const Icon(
              Icons.videocam_outlined,
              color: Color(0xFF121212),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const CallsScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Disst.AI',
            icon: const _DisstAiIcon(),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const DisstAiScreen(),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Search messages',
            icon: const Icon(
              Icons.search,
              color: Color(0xFF121212),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const MessageSearchScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: chats.length,
        separatorBuilder: (_, _) => const Divider(
          height: 1,
          indent: 84,
        ),
        itemBuilder: (context, index) {
          final chat = chats[index];

          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Stack(
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Color(0xFFE8E8EE),
                  child: Icon(
                    Icons.person,
                    color: Color(0xFF777777),
                    size: 30,
                  ),
                ),
                if (chat.status == MessageStatus.active)
                  Positioned(
                    right: 0,
                    bottom: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                if (chat.status == MessageStatus.unread)
                  Positioned(
                    right: 0,
                    bottom: 1,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2D9CFF),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            title: Text(
              chat.name,
              style: TextStyle(
                color: const Color(0xFF121212),
                fontWeight: chat.status == MessageStatus.unread
                    ? FontWeight.bold
                    : FontWeight.w600,
              ),
            ),
            subtitle: Text(
              chat.lastMessage,
              style: TextStyle(
                color: chat.status == MessageStatus.unread
                    ? const Color(0xFF2D9CFF)
                    : const Color(0xFF777777),
                fontWeight: chat.status == MessageStatus.unread
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ConversationScreen(
                    friendName: chat.name,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ChatItem {
  final String name;
  final String lastMessage;
  final MessageStatus status;

  const _ChatItem({
    required this.name,
    required this.lastMessage,
    required this.status,
  });
}

class _DisstAiIcon extends StatelessWidget {
  const _DisstAiIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF6C3BFF),
            Color(0xFF2D9CFF),
          ],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 7,
            child: Container(
              width: 9,
              height: 3,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Positioned(
            top: 2,
            right: 2,
            child: Icon(
              Icons.auto_awesome,
              size: 9,
              color: Color(0xFF2D9CFF),
            ),
          ),
        ],
      ),
    );
  }
}