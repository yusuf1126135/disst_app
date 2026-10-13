import 'package:flutter/material.dart';

import 'conversation_screen.dart';

class MessageSearchScreen extends StatefulWidget {
  const MessageSearchScreen({super.key});

  @override
  State<MessageSearchScreen> createState() =>
      _MessageSearchScreenState();
}

class _MessageSearchScreenState
    extends State<MessageSearchScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color black = Color(0xFF121212);
  static const Color secondary = Color(0xFF667085);
  static const Color border = Color(0xFFE3E1F5);

  final TextEditingController _searchController =
      TextEditingController();

  final List<_ChatSearchItem> _chats = const [
    _ChatSearchItem(
      name: 'Friend 1',
      lastMessage: 'Active now',
      time: 'Now',
      active: true,
    ),
    _ChatSearchItem(
      name: 'Friend 2',
      lastMessage: '5 min ago',
      time: '5m',
      active: true,
    ),
    _ChatSearchItem(
      name: 'Friend 3',
      lastMessage: 'New message',
      time: '10m',
      active: false,
    ),
    _ChatSearchItem(
      name: 'Friend 4',
      lastMessage: 'Yesterday',
      time: 'Yesterday',
      active: false,
    ),
  ];

  String _query = '';

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ChatSearchItem> get _filteredChats {
    if (_query.isEmpty) {
      return _chats;
    }

    return _chats.where((chat) {
      return chat.name.toLowerCase().contains(_query) ||
          chat.lastMessage.toLowerCase().contains(_query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final chats = _filteredChats;

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
        title: const Text(
          'Search Messages',
          style: TextStyle(
            color: black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildSearchField(),
          Expanded(
            child: chats.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      16,
                      8,
                      16,
                      24,
                    ),
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];

                      return _buildChatTile(
                        context,
                        chat,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        10,
      ),
      child: TextField(
        controller: _searchController,
        autofocus: true,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search chats...',
          hintStyle: const TextStyle(
            color: secondary,
            fontSize: 14,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: purple,
          ),
          suffixIcon: _query.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    color: secondary,
                  ),
                  tooltip: 'Clear search',
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF7F7FA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 13,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: purple,
              width: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChatTile(
    BuildContext context,
    _ChatSearchItem chat,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: border,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 5,
        ),
        leading: Stack(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: purple,
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
            if (chat.active)
              Positioned(
                right: 0,
                bottom: 1,
                child: Container(
                  width: 13,
                  height: 13,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
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
          style: const TextStyle(
            color: black,
            fontSize: 15.5,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          chat.lastMessage,
          style: const TextStyle(
            color: secondary,
            fontSize: 13.5,
          ),
        ),
        trailing: Text(
          chat.time,
          style: const TextStyle(
            color: secondary,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
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
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: purple.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: purple,
                size: 31,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'No chats found',
              style: TextStyle(
                color: black,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Try searching with another name.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondary,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatSearchItem {
  final String name;
  final String lastMessage;
  final String time;
  final bool active;

  const _ChatSearchItem({
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.active,
  });
}