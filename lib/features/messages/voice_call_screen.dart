import 'package:flutter/material.dart';

class VoiceCallScreen extends StatefulWidget {
  final String friendName;

  const VoiceCallScreen({
    super.key,
    required this.friendName,
  });

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);

  bool _microphoneOn = true;
  bool _speakerOn = true;

  void _endCall() {
    Navigator.of(context).pop();
  }

  void _showCallOptions() {
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
                  Icons.bluetooth_audio_outlined,
                  color: blue,
                ),
                title: const Text(
                  'Audio device',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_add_alt_1_outlined,
                  color: purple,
                ),
                title: const Text(
                  'Add people',
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: const Color(0xFF202124),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 112,
                        height: 112,
                        decoration: const BoxDecoration(
                          color: purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        widget.friendName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Connecting...',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Top controls
            Positioned(
              top: 4,
              left: 4,
              right: 4,
              child: Row(
                children: [
                  IconButton(
                    onPressed: _endCall,
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                    tooltip: 'Back',
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _showCallOptions,
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.white,
                    ),
                    tooltip: 'More',
                  ),
                ],
              ),
            ),

            // Call controls
            Positioned(
              left: 20,
              right: 20,
              bottom: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCallButton(
                    icon: _microphoneOn
                        ? Icons.mic_rounded
                        : Icons.mic_off_rounded,
                    label: _microphoneOn ? 'Mute' : 'Unmute',
                    active: _microphoneOn,
                    onTap: () {
                      setState(() {
                        _microphoneOn = !_microphoneOn;
                      });
                    },
                  ),
                  _buildCallButton(
                    icon: _speakerOn
                        ? Icons.volume_up_rounded
                        : Icons.volume_off_rounded,
                    label: 'Speaker',
                    active: _speakerOn,
                    onTap: () {
                      setState(() {
                        _speakerOn = !_speakerOn;
                      });
                    },
                  ),
                  _buildCallButton(
                    icon: Icons.call_end_rounded,
                    label: 'End',
                    active: false,
                    endCall: true,
                    onTap: _endCall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCallButton({
    required IconData icon,
    required String label,
    required bool active,
    required VoidCallback onTap,
    bool endCall = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: endCall
              ? const Color(0xFFE53935)
              : active
                  ? Colors.white.withValues(alpha: 0.16)
                  : Colors.white.withValues(alpha: 0.10),
          shape: const CircleBorder(),
          child: InkWell(
            onTap: onTap,
            customBorder: const CircleBorder(),
            child: SizedBox(
              width: 62,
              height: 62,
              child: Icon(
                icon,
                color: Colors.white,
                size: 27,
              ),
            ),
          ),
        ),
        const SizedBox(height: 7),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}