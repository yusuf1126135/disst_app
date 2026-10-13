import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  final String friendName;

  const VideoCallScreen({
    super.key,
    required this.friendName,
  });

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  static const Color purple = Color(0xFF6C3BFF);
  static const Color blue = Color(0xFF2D9CFF);
  static const Color black = Color(0xFF121212);

  bool _microphoneOn = true;
  bool _cameraOn = true;
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
                  Icons.flip_camera_ios_outlined,
                  color: purple,
                ),
                title: const Text('Switch camera'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.bluetooth_audio_outlined,
                  color: blue,
                ),
                title: const Text('Audio device'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_add_alt_1_outlined,
                  color: purple,
                ),
                title: const Text('Add people'),
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
            // Main remote video area.
            Positioned.fill(
              child: Container(
                color: const Color(0xFF202124),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration: const BoxDecoration(
                          color: purple,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        widget.friendName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
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

            // Top bar.
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

            // Self preview.
            Positioned(
              top: 58,
              right: 16,
              child: Container(
                width: 112,
                height: 158,
                decoration: BoxDecoration(
                  color: const Color(0xFF34363A),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white24,
                    width: 1.5,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: _cameraOn
                    ? const Center(
                        child: Icon(
                          Icons.person_rounded,
                          color: Colors.white70,
                          size: 48,
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.videocam_off_outlined,
                          color: Colors.white70,
                          size: 32,
                        ),
                      ),
              ),
            ),

            // Bottom call controls.
            Positioned(
              left: 20,
              right: 20,
              bottom: 22,
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
                    icon: _cameraOn
                        ? Icons.videocam_rounded
                        : Icons.videocam_off_rounded,
                    label: _cameraOn ? 'Camera' : 'Camera off',
                    active: _cameraOn,
                    onTap: () {
                      setState(() {
                        _cameraOn = !_cameraOn;
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
              width: 58,
              height: 58,
              child: Icon(
                icon,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
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