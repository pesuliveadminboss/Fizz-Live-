import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:translator/translator.dart';

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
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6C5CE7),
        scaffoldBackgroundColor: const Color(0xFF0F0C20),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _liveIdController = TextEditingController(text: "7777");
  late final String _userId;
  late final String _userName;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _userId = "user_${random.nextInt(90000) + 10000}";
    _userName = "FizzUser_${random.nextInt(900) + 100}";
  }

  void _startLive({required bool isHost}) {
    final liveId = _liveIdController.text.trim();
    if (liveId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Live ID உள்ளிடவும்!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveStreamingPage(
          liveID: liveId,
          userID: _userId,
          userName: _userName,
          isHost: isHost,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1B143A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.videocam, size: 48, color: Colors.white),
                  const SizedBox(height: 10),
                  const Text(
                    'Welcome to Fizz Live',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text('User: $_userName', style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _liveIdController,
              decoration: InputDecoration(
                labelText: 'Live Room ID',
                prefixIcon: const Icon(Icons.tag),
                filled: true,
                fillColor: const Color(0xFF1B143A),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _startLive(isHost: true),
              icon: const Icon(Icons.broadcast_on_home, color: Colors.white),
              label: const Text('Go Live (Host)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF7675),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () => _startLive(isHost: false),
              icon: const Icon(Icons.login, color: Colors.white),
              label: const Text('Watch Live (Audience)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFF6C5CE7)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LiveStreamingPage extends StatelessWidget {
  final String liveID;
  final String userID;
  final String userName;
  final bool isHost;

  const LiveStreamingPage({
    super.key,
    required this.liveID,
    required this.userID,
    required this.userName,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    const int appID = 1265895941;
    const String appSign = "0d5b622565bfc6cbaf590722eb3b661ff27e0eb3666040b6b7e5bfcfe161d44e";

    final config = isHost
        ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
        : ZegoUIKitPrebuiltLiveStreamingConfig.audience();

    // Co-host & Bottom Bar Settings
    if (!isHost) {
      // Audience-க்கு கீழே Request Co-host பட்டன் சேர்க்கப்படுகிறது
      config.bottomMenuBarConfig.audienceButtons = [
        ZegoMenuBarButtonName.coHostControlButton,
        ZegoMenuBarButtonName.chatButton,
        ZegoMenuBarButtonName.switchCameraButton,
      ];
    }

    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: appID,
        appSign: appSign,
        userID: userID,
        userName: userName,
        liveID: liveID,
        config: config,
      ),
    );
  }
}

