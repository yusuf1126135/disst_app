import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

const Color disstPurple = Color(0xFF6C3BFF);
const Color disstBlue = Color(0xFF2D9CFF);
const Color disstBlack = Color(0xFF121212);
const Color disstWhite = Color(0xFFFFFFFF);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _ensureProfile(User user) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    final snapshot = await userRef.get();

    if (!snapshot.exists) {
      final now = Timestamp.now();

      final displayName =
          (user.displayName == null || user.displayName!.trim().isEmpty)
              ? 'Yusuf Umar'
              : user.displayName!.trim();

      await userRef.set({
        'uid': user.uid,
        'username': 'yusufumar',
        'displayName': displayName,
        'bio': '',
        'photoUrl': user.photoURL ?? '',
        'createdAt': now,
        'updatedAt': now,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please log in again.'),
        ),
      );
    }

    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    return FutureBuilder<void>(
      future: _ensureProfile(user),
      builder: (context, setupSnapshot) {
        if (setupSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: disstPurple,
              ),
            ),
          );
        }

        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: userDoc.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Profile'),
                ),
                body: Center(
                  child: Text(
                    'Something went wrong.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: disstPurple,
                  ),
                ),
              );
            }

            final data = snapshot.data!.data() ?? {};

            final displayName =
                (data['displayName'] ?? user.displayName ?? 'Yusuf Umar')
                    .toString();

            final username =
                (data['username'] ?? 'yusufumar').toString();

            final bio = (data['bio'] ?? '').toString();

            final photoUrl =
                (data['photoUrl'] ?? user.photoURL ?? '').toString();

            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              appBar: AppBar(
                elevation: 0,
                backgroundColor:
                    Theme.of(context).scaffoldBackgroundColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: disstBlack,
                  ),
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.more_vert,
                      color: disstBlack,
                    ),
                    onPressed: () {
                      _showProfileMenu(context);
                    },
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Profile photo
                    GestureDetector(
                      onTap: () {
                        if (photoUrl.isNotEmpty) {
                          _showFullImage(
                            context,
                            photoUrl,
                            'Profile Photo',
                          );
                        }
                      },
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: photoUrl.isNotEmpty
                            ? NetworkImage(photoUrl)
                            : null,
                        child: photoUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 55,
                                color: disstWhite,
                              )
                            : null,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Display name
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: disstBlack,
                      ),
                    ),

                    const SizedBox(height: 4),

                    // Username
                    Text(
                      '@$username',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Bio
                    if (bio.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                        ),
                        child: Text(
                          bio,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: disstBlack,
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStat(
                          '0',
                          'Followers',
                        ),
                        const SizedBox(width: 40),
                        _buildStat(
                          '0',
                          'Following',
                        ),
                        const SizedBox(width: 40),
                        _buildStat(
                          '0',
                          'Likes',
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // Profile actions
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: disstPurple,
                                size: 19,
                              ),
                              label: const Text(
                                'Add to Story',
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: disstBlack,
                                side: const BorderSide(
                                  color: Color(0xFFE3E1F5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: disstPurple,
                                size: 19,
                              ),
                              label: const Text(
                                'Edit Profile',
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: disstBlack,
                                side: const BorderSide(
                                  color: Color(0xFFE3E1F5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.dashboard_outlined,
                                color: disstBlue,
                                size: 19,
                              ),
                              label: const Text(
                                'Dashboard',
                                maxLines: 1,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: disstBlack,
                                side: const BorderSide(
                                  color: Color(0xFFE3E1F5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Tabs
                    const Divider(height: 1),

                    Row(
                      children: [
                        Expanded(
                          child: _buildTab(
                            icon: Icons.grid_on,
                            label: 'Posts',
                            selected: true,
                          ),
                        ),
                        Expanded(
                          child: _buildTab(
                            icon: Icons.repeat,
                            label: 'Reposts',
                            selected: false,
                          ),
                        ),
                        Expanded(
                          child: _buildTab(
                            icon: Icons.bookmark_border,
                            label: 'Saved',
                            selected: false,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 1),

                    const SizedBox(height: 60),

                    Icon(
                      Icons.photo_library_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'No posts yet',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStat(String number, String label) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: disstBlack,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTab({
    required IconData icon,
    required String label,
    required bool selected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 22,
            color: selected ? disstPurple : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight:
                  selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? disstPurple : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.settings_outlined,
                  color: disstPurple,
                ),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SettingsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showFullImage(
    BuildContext context,
    String imageUrl,
    String title,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: Text(title),
            ),
            body: Center(
              child: InteractiveViewer(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.lock_outline),
            title: Text('Privacy'),
            subtitle: Text('Manage your privacy settings'),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Language & Translation'),
            subtitle: Text('Choose your language'),
          ),
          ListTile(
            leading: Icon(Icons.notifications_none),
            title: Text('Notifications'),
            subtitle: Text('Manage notifications'),
          ),
          ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Account'),
            subtitle: Text('Manage your account'),
          ),
          ListTile(
            leading: Icon(Icons.security_outlined),
            title: Text('Security'),
            subtitle: Text('Manage account security'),
          ),
          ListTile(
            leading: Icon(Icons.block_outlined),
            title: Text('Blocked Accounts'),
          ),
          ListTile(
            leading: Icon(Icons.help_outline),
            title: Text('Help & Support'),
          ),
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About DisstApp'),
          ),
        ],
      ),
    );
  }
}