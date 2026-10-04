import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  static const Color brandPurple = Color(0xFF5146D8);
  static const Color darkText = Color(0xFF18204A);
  static const Color secondaryText = Color(0xFF667085);
  static const Color background = Color(0xFFFCF9FF);
  static const Color borderColor = Color(0xFFD9DDEA);

  final TextEditingController _postController =
      TextEditingController();

  String _audience = 'Public';
  bool _allowMessages = false;
  bool _isPublishing = false;

  bool get _canPost =>
      _postController.text.trim().isNotEmpty && !_isPublishing;

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature will be available soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _publishPost() async {
    final text = _postController.text.trim();

    if (text.isEmpty || _isPublishing) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in before creating a post.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      _isPublishing = true;
    });

    try {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc();

      final now = Timestamp.now();

      final visibility = _audience == 'Public'
          ? 'public'
          : _audience == 'Followers'
              ? 'followers'
              : 'private';

      await postRef.set({
        'postId': postRef.id,
        'authorId': user.uid,
        'authorName': user.displayName ?? 'Yusuf Umar',
        'authorPhotoUrl': user.photoURL ?? '',
        'text': text,
        'visibility': visibility,
        'allowMessages': _allowMessages,
        'mediaType': 'none',
        'mediaUrls': <String>[],
        'likeCount': 0,
        'commentCount': 0,
        'shareCount': 0,
        'viewCount': 0,
        'createdAt': now,
        'updatedAt': now,
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post published successfully.'),
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to publish post: ${e.message ?? e.code}',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to publish post: $e'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isPublishing = false;
        });
      }
    }
  }

  void _showAudienceSelector() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Who can see your post?',
                    style: TextStyle(
                      color: darkText,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              _audienceOption(
                icon: Icons.public_rounded,
                title: 'Public',
                subtitle: 'Anyone can see this',
              ),
              _audienceOption(
                icon: Icons.people_outline_rounded,
                title: 'Followers',
                subtitle: 'Only your followers can see this',
              ),
              _audienceOption(
                icon: Icons.lock_outline_rounded,
                title: 'Only me',
                subtitle: 'Only you can see this',
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _audienceOption({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final selected = _audience == title;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 4,
      ),
      leading: CircleAvatar(
        backgroundColor:
            selected ? brandPurple : const Color(0xFFF1F0FF),
        child: Icon(
          icon,
          color: selected ? Colors.white : brandPurple,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: darkText,
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: secondaryText,
        ),
      ),
      trailing: selected
          ? const Icon(
              Icons.check_circle_rounded,
              color: brandPurple,
            )
          : null,
      onTap: () {
        setState(() {
          _audience = title;
        });
        Navigator.pop(context);
      },
    );
  }

  Widget _postOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F0FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: brandPurple,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: darkText,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: secondaryText,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: _isPublishing
              ? null
              : () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: darkText,
          ),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: _canPost ? _publishPost : null,
              style: TextButton.styleFrom(
                backgroundColor: _canPost
                    ? brandPurple
                    : const Color(0xFFE4E2F5),
                foregroundColor:
                    _canPost ? Colors.white : secondaryText,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isPublishing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            12,
            16,
            30,
          ),
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: brandPurple,
                  backgroundImage:
                      FirebaseAuth.instance.currentUser?.photoURL != null &&
                              FirebaseAuth.instance.currentUser!.photoURL!
                                  .isNotEmpty
                          ? NetworkImage(
                              FirebaseAuth
                                  .instance.currentUser!.photoURL!,
                            )
                          : null,
                  child:
                      FirebaseAuth.instance.currentUser?.photoURL == null ||
                              FirebaseAuth.instance.currentUser!.photoURL!
                                  .isEmpty
                          ? const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                            )
                          : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    FirebaseAuth.instance.currentUser?.displayName ??
                        'Yusuf Umar',
                    style: const TextStyle(
                      color: darkText,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed:
                      _isPublishing ? null : _showAudienceSelector,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: darkText,
                    side: const BorderSide(
                      color: borderColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: Icon(
                    _audience == 'Public'
                        ? Icons.public_rounded
                        : _audience == 'Followers'
                            ? Icons.people_outline_rounded
                            : Icons.lock_outline_rounded,
                    size: 18,
                  ),
                  label: Text(_audience),
                ),
              ],
            ),
            const SizedBox(height: 22),
            TextField(
              controller: _postController,
              autofocus: true,
              maxLines: null,
              minLines: 6,
              enabled: !_isPublishing,
              onChanged: (_) {
                setState(() {});
              },
              style: const TextStyle(
                color: darkText,
                fontSize: 17,
                height: 1.45,
              ),
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                hintStyle: TextStyle(
                  color: secondaryText,
                  fontSize: 17,
                ),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 12),
            const Divider(
              color: borderColor,
              height: 1,
            ),
            const SizedBox(height: 10),
            const Text(
              'Add to your post',
              style: TextStyle(
                color: darkText,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            _postOption(
              icon: Icons.photo_library_outlined,
              title: 'Photos/Videos',
              onTap: () => _showComingSoon('Photos/Videos'),
            ),
            _postOption(
              icon: Icons.music_note_rounded,
              title: 'Music',
              onTap: () => _showComingSoon('Music'),
            ),
            _postOption(
              icon: Icons.person_add_alt_1_rounded,
              title: 'Tag people',
              onTap: () => _showComingSoon('Tag people'),
            ),
            _postOption(
              icon: Icons.location_on_outlined,
              title: 'Add location',
              onTap: () => _showComingSoon('Add location'),
            ),
            _postOption(
              icon: Icons.sentiment_satisfied_alt_rounded,
              title: 'Feeling/activity',
              onTap: () => _showComingSoon('Feeling/activity'),
            ),
            const SizedBox(height: 8),
            const Text(
              'More',
              style: TextStyle(
                color: darkText,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'Allow messages',
                style: TextStyle(
                  color: darkText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text(
                'Let people message you from this post',
                style: TextStyle(
                  color: secondaryText,
                  fontSize: 12.5,
                ),
              ),
              secondary: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F0FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: brandPurple,
                ),
              ),
              value: _allowMessages,
              activeThumbColor: brandPurple,
              onChanged: _isPublishing
                  ? null
                  : (value) {
                      setState(() {
                        _allowMessages = value;
                      });
                    },
            ),
            _postOption(
              icon: Icons.event_outlined,
              title: 'Create Event',
              onTap: () => _showComingSoon('Create Event'),
            ),
            _postOption(
              icon: Icons.videocam_outlined,
              title: 'Go Live',
              onTap: () => _showComingSoon('Go Live'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }
}