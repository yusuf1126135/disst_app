import 'package:flutter/material.dart';

import '../../services/call_eligibility_service.dart';
import 'voice_call_screen.dart';
import 'video_call_screen.dart';

class CallsScreen extends StatefulWidget {
  const CallsScreen({super.key});

  @override
  State<CallsScreen> createState() => _CallsScreenState();
}

class _CallsScreenState extends State<CallsScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);
  static const Color secondary = Color(0xFF667085);

  final TextEditingController _searchController =
      TextEditingController();

  final CallEligibilityService _callEligibilityService =
      const CallEligibilityService();

  final List<_CallContact> _recentCalls = [
    const _CallContact(
      name: 'Friend 1',
      time: 'Today',
      type: CallType.video,
    ),
    const _CallContact(
      name: 'Friend 2',
      time: 'Yesterday',
      type: CallType.voice,
    ),
  ];

  final List<_CallContact> _contacts = [
    const _CallContact(
      name: 'Friend 3',
      time: '',
      type: CallType.video,
    ),
    const _CallContact(
      name: 'Friend 4',
      time: '',
      type: CallType.voice,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CallContact> get _filteredRecentCalls {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _recentCalls;
    }

    return _recentCalls
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(query),
        )
        .toList();
  }

  List<_CallContact> get _filteredContacts {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      return _contacts;
    }

    return _contacts
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(query),
        )
        .toList();
  }

  Future<void> _openContact(_CallContact contact) async {
    final result = await _callEligibilityService.check(
      friendName: contact.name,
    );

    if (!mounted) {
      return;
    }

    if (!result.hasPhoneNumber) {
      _showMessage(
        'No phone number available. You need this person\'s phone number to start a call.',
      );
      return;
    }

    if (!result.isOnDisstApp) {
      _showNotOnDisstApp(contact.name);
      return;
    }

    if (!result.callsAllowed) {
      _showMessage(
        'Calls are not available for this person right now.',
      );
      return;
    }

    _showCallChoice(contact);
  }

  void _showCallChoice(_CallContact contact) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              4,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: purple,
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        contact.name,
                        style: const TextStyle(
                          color: black,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose how you want to call',
                    style: TextStyle(
                      color: secondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFF0EBFF),
                    child: Icon(
                      Icons.call_outlined,
                      color: purple,
                    ),
                  ),
                  title: const Text(
                    'Voice Call',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Call with voice only',
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VoiceCallScreen(
                          friendName: contact.name,
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFEAF5FF),
                    child: Icon(
                      Icons.videocam_outlined,
                      color: blue,
                    ),
                  ),
                  title: const Text(
                    'Video Call',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: const Text(
                    'Call with voice and video',
                  ),
                  onTap: () {
                    Navigator.pop(sheetContext);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => VideoCallScreen(
                          friendName: contact.name,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showNotOnDisstApp(String name) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              8,
              20,
              24,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Color(0xFFF2F2F7),
                  child: Icon(
                    Icons.person_outline_rounded,
                    color: secondary,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  style: const TextStyle(
                    color: black,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Not on DisstApp',
                  style: TextStyle(
                    color: secondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(sheetContext);
                      _showMessage(
                        'Invite feature will be connected later.',
                      );
                    },
                    icon: const Icon(
                      Icons.person_add_alt_1_rounded,
                    ),
                    label: const Text('Invite'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final recentCalls = _filteredRecentCalls;
    final contacts = _filteredContacts;

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
          'Calls',
          style: TextStyle(
            color: black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              4,
              16,
              8,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) {
                setState(() {});
              },
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: const TextStyle(
                  color: secondary,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: secondary,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F7FA),
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                24,
              ),
              children: [
                if (recentCalls.isNotEmpty) ...[
                  const _SectionTitle(
                    title: 'Recent calls',
                  ),
                  const SizedBox(height: 4),
                  ...recentCalls.map(
                    (contact) => _buildContactTile(contact),
                  ),
                ],
                if (contacts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const _SectionTitle(
                    title: 'Contacts',
                  ),
                  const SizedBox(height: 4),
                  ...contacts.map(
                    (contact) => _buildContactTile(contact),
                  ),
                ],
                if (recentCalls.isEmpty &&
                    contacts.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 70),
                    child: Center(
                      child: Text(
                        'No contacts found',
                        style: TextStyle(
                          color: secondary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(_CallContact contact) {
    return InkWell(
      onTap: () => _openContact(contact),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 4,
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 23,
              backgroundColor: purple,
              child: Icon(
                Icons.person_rounded,
                color: Colors.white,
                size: 25,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    contact.name,
                    style: const TextStyle(
                      color: black,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (contact.time.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      contact.time,
                      style: const TextStyle(
                        color: secondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              contact.type == CallType.video
                  ? Icons.videocam_outlined
                  : Icons.call_outlined,
              color: contact.type == CallType.video
                  ? blue
                  : purple,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 6,
        bottom: 4,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF121212),
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _CallContact {
  final String name;
  final String time;
  final CallType type;

  const _CallContact({
    required this.name,
    required this.time,
    required this.type,
  });
}

enum CallType {
  voice,
  video,
}