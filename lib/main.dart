import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FizzLiveApp());
}

class FizzLiveApp extends StatelessWidget {
  const FizzLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const FizzLiveHome(),
    );
  }
}

class FizzLiveHome extends StatefulWidget {
  const FizzLiveHome({super.key});

  @override
  State<FizzLiveHome> createState() => _FizzLiveHomeState();
}

class _FizzLiveHomeState extends State<FizzLiveHome> {
  final TextEditingController _roomIDController = TextEditingController(text: 'room_123');
  final TextEditingController _userIDController = TextEditingController(text: 'user_${DateTime.now().millisecondsSinceEpoch.remainder(10000)}');
  final TextEditingController _userNameController = TextEditingController(text: 'User');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live - Live Streaming'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Fizz Live',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _roomIDController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Room ID',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _userNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'User Name',
                labelStyle: TextStyle(color: Colors.grey),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple)),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveRoom(
                            roomID: _roomIDController.text.trim(),
                            isHost: true,
                            userID: _userIDController.text.trim(),
                            userName: _userNameController.text.trim(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Start Live (Host)', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LiveRoom(
                            roomID: _roomIDController.text.trim(),
                            isHost: false,
                            userID: _userIDController.text.trim(),
                            userName: _userNameController.text.trim(),
                          ),
                        ),
                      );
                    },
                    child: const Text('Watch Live (Audience)', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
  // TODO: Replace with your actual Zego AppID and AppSign
  static const int yourAppID = 0; // Unga Zego App ID inga podunga
  static const String yourAppSign = 'YOUR_APP_SIGN'; // Unga Zego App Sign inga podunga

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
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
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fizz Live Interaction Triggered')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Interaction',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
