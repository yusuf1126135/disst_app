import 'package:flutter/material.dart';

const Color disstPurple = Color(0xFF6C3BFF);
const Color disstBlue = Color(0xFF2D9CFF);
const Color disstBlack = Color(0xFF121212);
const Color disstWhite = Color(0xFFFFFFFF);
const Color disstSecondary = Color(0xFF667085);
const Color disstBorder = Color(0xFFE3E1F5);

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  int _selectedType = 0;

  final List<String> _storyTypes = [
    'Photo',
    'Video',
    'Text',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: disstWhite,
      appBar: AppBar(
        backgroundColor: disstWhite,
        foregroundColor: disstBlack,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add to Story',
          style: TextStyle(
            color: disstBlack,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 30),
          children: [
            _buildTypeSelector(),

            const SizedBox(height: 22),

            if (_selectedType == 0)
              _buildPhotoStory()
            else if (_selectedType == 1)
              _buildVideoStory()
            else
              _buildTextStory(),

            const SizedBox(height: 24),

            _buildAudienceSection(),

            const SizedBox(height: 24),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  _showComingSoon();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: disstPurple,
                  foregroundColor: disstWhite,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Share to Story',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: disstBorder,
        ),
      ),
      child: Row(
        children: List.generate(
          _storyTypes.length,
          (index) {
            final selected = _selectedType == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedType = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    vertical: 11,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? disstWhite
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.05,
                              ),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    _storyTypes[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: selected
                          ? disstPurple
                          : disstSecondary,
                      fontSize: 14,
                      fontWeight: selected
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildPhotoStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photo Story',
          style: TextStyle(
            color: disstBlack,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose a photo to share with your story.',
          style: TextStyle(
            color: disstSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        _buildMediaPicker(
          icon: Icons.photo_library_outlined,
          title: 'Add Photo',
          subtitle: 'Choose a photo from your device',
        ),
      ],
    );
  }

  Widget _buildVideoStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Video Story',
          style: TextStyle(
            color: disstBlack,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose a video to share with your story.',
          style: TextStyle(
            color: disstSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        _buildMediaPicker(
          icon: Icons.video_library_outlined,
          title: 'Add Video',
          subtitle: 'Choose a video from your device',
        ),
      ],
    );
  }

  Widget _buildTextStory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text Story',
          style: TextStyle(
            color: disstBlack,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Write something you want to share.',
          style: TextStyle(
            color: disstSecondary,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          maxLines: 7,
          maxLength: 500,
          decoration: InputDecoration(
            hintText: 'What would you like to share?',
            hintStyle: const TextStyle(
              color: disstSecondary,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F7FF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: disstBorder,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: disstBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: disstPurple,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMediaPicker({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return GestureDetector(
      onTap: () {
        _showComingSoon();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 30,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F7FF),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: disstBorder,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    disstPurple,
                    disstBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                color: disstWhite,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                color: disstBlack,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: disstSecondary,
                fontSize: 12.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudienceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: disstWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: disstBorder,
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.visibility_outlined,
            color: disstPurple,
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Story Audience',
                  style: TextStyle(
                    color: disstBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Everyone',
                  style: TextStyle(
                    color: disstSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: disstSecondary,
          ),
        ],
      ),
    );
  }

  void _showComingSoon() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Media selection will be connected next.',
        ),
      ),
    );
  }
}