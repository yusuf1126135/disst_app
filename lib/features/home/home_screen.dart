import 'package:flutter/material.dart';
import 'create_post_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // ============================================================
  // DISSTAPP BRAND COLORS
  // ============================================================

  static const Color brandPurple = Color(0xFF5146D8);
  static const Color darkText = Color(0xFF18204A);
  static const Color secondaryText = Color(0xFF667085);
  static const Color background = Color(0xFFFCF9FF);
  static const Color borderColor = Color(0xFFD9DDEA);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // TOP HEADER
      // ========================================================

      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu_rounded,
            color: darkText,
          ),
          tooltip: 'Menu',
        ),
        titleSpacing: 0,
        title: const Text(
          'DisstApp',
          style: TextStyle(
            color: darkText,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.storefront_outlined,
              color: brandPurple,
            ),
            tooltip: 'Marketplace',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
              color: darkText,
            ),
            tooltip: 'Search',
          ),
        ],
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SafeArea(
        child: Column(
          children: [
            // --------------------------------------------------
            // QUICK ICONS
            // --------------------------------------------------

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 6,
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  _quickIcon(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    active: true,
                  ),
                  _quickIcon(
                    icon: Icons.people_outline_rounded,
                    label: 'Friends',
                  ),
                  _quickIcon(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Messages',
                  ),
                  _quickIcon(
                    icon: Icons.play_circle_outline_rounded,
                    label: 'Shorts',
                  ),
                  _quickIcon(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // --------------------------------------------------
            // FEED
            // --------------------------------------------------

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  100,
                ),
                children: [
                  // --------------------------------------------
                  // CREATE POST
                  // --------------------------------------------

                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const CreatePostScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(18),
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 23,
                            backgroundColor: brandPurple,
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              "What's on your mind?",
                              style: TextStyle(
                                color: secondaryText,
                                fontSize: 15.5,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const CreatePostScreen(),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.image_outlined,
                              color: brandPurple,
                            ),
                            tooltip: 'Add photo',
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // --------------------------------------------
                  // HOME FEED TITLE
                  // --------------------------------------------

                  const Text(
                    'HOME FEED',
                    style: TextStyle(
                      color: darkText,
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // --------------------------------------------
                  // SAMPLE POST
                  // --------------------------------------------

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                      border: Border.all(
                        color: borderColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 21,
                              backgroundColor: brandPurple,
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 21,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                'DisstApp User',
                                style: TextStyle(
                                  color: darkText,
                                  fontWeight:
                                      FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.more_horiz_rounded,
                                color: secondaryText,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Welcome to DisstApp!',
                          style: TextStyle(
                            color: darkText,
                            fontSize: 16,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(
                          color: borderColor,
                          height: 1,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                          children: [
                            _postAction(
                              icon: Icons
                                  .favorite_border_rounded,
                              label: 'Like',
                            ),
                            _postAction(
                              icon: Icons
                                  .comment_outlined,
                              label: 'Comment',
                            ),
                            _postAction(
                              icon: Icons.share_outlined,
                              label: 'Share',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ========================================================
      // BOTTOM NAVIGATION
      // ========================================================

      bottomNavigationBar: SafeArea(
        child: Container(
          height: 68,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(
                color: borderColor,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: [
              _bottomItem(
                icon: Icons.groups_outlined,
                label: 'Groups',
                onPressed: () {},
              ),

              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: brandPurple,
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) =>
                            const CreatePostScreen(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 27,
                  ),
                  tooltip: 'Create',
                ),
              ),

              _bottomItem(
                icon: Icons.person_outline_rounded,
                label: 'Profile',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                          const ProfileScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // QUICK ICON
  // ============================================================

  static Widget _quickIcon({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: active ? brandPurple : secondaryText,
          size: 25,
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: active ? brandPurple : secondaryText,
            fontSize: 10,
            fontWeight:
                active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // POST ACTION
  // ============================================================

  static Widget _postAction({
    required IconData icon,
    required String label,
  }) {
    return TextButton.icon(
      onPressed: () {},
      style: TextButton.styleFrom(
        foregroundColor: secondaryText,
      ),
      icon: Icon(
        icon,
        size: 20,
      ),
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
        ),
      ),
    );
  }

  // ============================================================
  // BOTTOM ITEM
  // ============================================================

  static Widget _bottomItem({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: secondaryText,
      ),
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 23,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}