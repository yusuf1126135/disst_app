import 'package:flutter/material.dart';

class MessageSettingsScreen extends StatefulWidget {
  const MessageSettingsScreen({super.key});

  @override
  State<MessageSettingsScreen> createState() =>
      _MessageSettingsScreenState();
}

class _MessageSettingsScreenState
    extends State<MessageSettingsScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);
  static const Color secondary = Color(0xFF667085);
  static const Color border = Color(0xFFE3E1F5);

  bool _messageNotifications = true;
  bool _activeStatus = true;
  bool _readReceipts = true;
  bool _disappearingMessages = false;

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
        title: const Text(
          'Message Settings',
          style: TextStyle(
            color: black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          16,
          8,
          16,
          30,
        ),
        children: [
          _buildSectionTitle('Notifications'),
          _buildSwitchTile(
            icon: Icons.notifications_none_rounded,
            iconColor: purple,
            title: 'Message notifications',
            value: _messageNotifications,
            onChanged: (value) {
              setState(() {
                _messageNotifications = value;
              });
            },
          ),

          const SizedBox(height: 18),

          _buildSectionTitle('Activity'),
          _buildSwitchTile(
            icon: Icons.circle,
            iconColor: const Color(0xFF22C55E),
            title: 'Active status',
            value: _activeStatus,
            onChanged: (value) {
              setState(() {
                _activeStatus = value;
              });
            },
          ),

          const SizedBox(height: 18),

          _buildSectionTitle('Messages'),
          _buildNavigationTile(
            icon: Icons.mark_email_unread_outlined,
            iconColor: blue,
            title: 'Message requests',
            onTap: () {},
          ),
          _buildNavigationTile(
            icon: Icons.archive_outlined,
            iconColor: purple,
            title: 'Archived chats',
            onTap: () {},
          ),

          const SizedBox(height: 18),

          _buildSectionTitle('Privacy & Safety'),
          _buildSwitchTile(
            icon: Icons.done_all_rounded,
            iconColor: blue,
            title: 'Read receipts',
            value: _readReceipts,
            onChanged: (value) {
              setState(() {
                _readReceipts = value;
              });
            },
          ),
          _buildSwitchTile(
            icon: Icons.timer_outlined,
            iconColor: purple,
            title: 'Disappearing messages',
            value: _disappearingMessages,
            onChanged: (value) {
              setState(() {
                _disappearingMessages = value;
              });
            },
          ),
          _buildNavigationTile(
            icon: Icons.block_outlined,
            iconColor: Colors.red,
            title: 'Blocked accounts',
            onTap: () {},
          ),

          const SizedBox(height: 18),

          _buildSectionTitle('Security'),
          _buildNavigationTile(
            icon: Icons.lock_outline_rounded,
            iconColor: purple,
            title: 'End-to-end encryption',
            onTap: () {},
          ),

          const SizedBox(height: 18),

          _buildSectionTitle('Help'),
          _buildNavigationTile(
            icon: Icons.flag_outlined,
            iconColor: Colors.orange,
            title: 'Report a problem',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 4,
        bottom: 7,
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: secondary,
          fontSize: 13,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 2,
        ),
        secondary: _buildIconContainer(
          icon: icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: black,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        value: value,
        activeThumbColor: purple,
        activeTrackColor: const Color(0xFFDCD2FF),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: border,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 3,
        ),
        leading: _buildIconContainer(
          icon: icon,
          color: iconColor,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: black,
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: secondary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildIconContainer({
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: color,
        size: 21,
      ),
    );
  }
}