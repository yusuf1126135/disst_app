import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.initialDisplayName = '',
    this.initialUsername = '',
    this.initialBio = '',
  });

  final String initialDisplayName;
  final String initialUsername;
  final String initialBio;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _displayNameController;
  late final TextEditingController _usernameController;
  late final TextEditingController _bioController;

  bool _saving = false;

  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);
  static const Color secondary = Color(0xFF667085);
  static const Color border = Color(0xFFE3E1F5);

  @override
  void initState() {
    super.initState();

    _displayNameController = TextEditingController(
      text: widget.initialDisplayName,
    );
    _usernameController = TextEditingController(
      text: widget.initialUsername,
    );
    _bioController = TextEditingController(
      text: widget.initialBio,
    );
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      _showMessage('Please sign in again.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final displayName = _displayNameController.text.trim();
      final username = _usernameController.text.trim();
      final bio = _bioController.text.trim();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'displayName': displayName,
        'username': username,
        'bio': bio,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) {
        return;
      }

      _showMessage('Profile updated successfully.');

      Navigator.of(context).pop(true);
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to update profile. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
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
    return Scaffold(
      backgroundColor: disstWhite,
      appBar: AppBar(
        backgroundColor: disstWhite,
        foregroundColor: black,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: _saving
              ? null
              : () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_rounded),
          tooltip: 'Back',
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: black,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: _saving ? null : _saveProfile,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: purple,
                      ),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: purple,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 44,
                      backgroundColor: purple,
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: () {
                        _showMessage(
                          'Profile photo upload will be connected later.',
                        );
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: purple,
                      ),
                      label: const Text(
                        'Change profile photo',
                        style: TextStyle(
                          color: purple,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _fieldLabel('Display Name'),
              const SizedBox(height: 7),
              _textField(
                controller: _displayNameController,
                hintText: 'Your display name',
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Display name is required.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              _fieldLabel('Username'),
              const SizedBox(height: 7),
              _textField(
                controller: _usernameController,
                hintText: 'username',
                prefixText: '@',
                textCapitalization: TextCapitalization.none,
                validator: (value) {
                  final username = value?.trim() ?? '';

                  if (username.isEmpty) {
                    return 'Username is required.';
                  }

                  if (username.length < 3) {
                    return 'Username must be at least 3 characters.';
                  }

                  if (username.contains(' ')) {
                    return 'Username cannot contain spaces.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 18),
              _fieldLabel('Bio'),
              const SizedBox(height: 7),
              _textField(
                controller: _bioController,
                hintText: 'Tell people about yourself',
                maxLines: 4,
                maxLength: 160,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F7FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: border),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: blue,
                      size: 21,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Your profile information will be saved to your DisstApp profile.',
                        style: TextStyle(
                          color: black,
                          fontSize: 13.5,
                          height: 1.45,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: black,
        fontSize: 15,
        fontWeight: FontWeight.w800,
      ),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hintText,
    String? prefixText,
    int maxLines = 1,
    int? maxLength,
    TextCapitalization textCapitalization =
        TextCapitalization.none,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      validator: validator,
      style: const TextStyle(
        color: black,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: secondary,
          fontWeight: FontWeight.w400,
        ),
        prefixText: prefixText,
        prefixStyle: const TextStyle(
          color: black,
          fontWeight: FontWeight.w700,
        ),
        counterStyle: const TextStyle(
          color: secondary,
          fontSize: 11,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 13,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: purple,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Colors.redAccent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}