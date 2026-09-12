import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

class LiveRoom extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final String userID;
  final String userName;

  const LiveRoom({
    super.key,
    required this.roomID,
    this.isHost = false,
    required this.userID,
    required this.userName,
  });

  @override
  State<LiveRoom> createState() => _LiveRoomState();
}

class _LiveRoomState extends State<LiveRoom> {
  // Replace with your actual AppID and AppSign if required here
  static const int yourAppID = 0; // Unga Zego App ID
  static const String yourAppSign = 'YOUR_APP_SIGN'; // Unga Zego App Sign

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Zego Live Streaming UI View
          ZegoUIKitPrebuiltLiveStreaming(
            appID: yourAppID,
            appSign: yourAppSign,
            userID: widget.userID,
            userName: widget.userName,
            liveID: widget.roomID,
            config: widget.isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
          ),

          // 2. Custom Overlay Controls (Top/Bottom UI)
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Action / Interaction Button
                    ElevatedButton(
                      onPressed: () {
                        // Button click action
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Action Triggered')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'Live Interaction',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // Exit Button
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

