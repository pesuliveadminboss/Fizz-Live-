import 'dart:math';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
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
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF6C5CE7),
        scaffoldBackgroundColor: const Color(0xFF0F0C20),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6C5CE7),
          secondary: Color(0xFFFF7675),
        ),
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
  final TextEditingController _liveIdController = TextEditingController(text: "1234");
  late final String _userId;
  late final String _userName;

  @override
  void initState() {
    super.initState();
    // Generate Random User Identity
    final random = Random();
    _userId = "user_${random.nextInt(90000) + 10000}";
    _userName = "FizzUser_${random.nextInt(900) + 100}";
  }

  void _startLive({required bool isHost}) {
    final liveId = _liveIdController.text.trim();
    if (liveId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('தயவுசெய்து Live ID உள்ளிடவும்!')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveStreamingScreen(
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
        title: const Row(
          children: [
            Icon(Icons.stream, color: Color(0xFFFF7675)),
            SizedBox(width: 8),
            Text(
              'Fizz Live',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1B143A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C5CE7).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(Icons.videocam, size: 50, color: Colors.white),
                    const SizedBox(height: 10),
                    const Text(
                      'Welcome to Fizz Live!',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your ID: $_userName',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _liveIdController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Live Room ID',
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.tag, color: Color(0xFF6C5CE7)),
                  filled: true,
                  fillColor: const Color(0xFF1B143A),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => _startLive(isHost: true),
                icon: const Icon(Icons.broadcast_on_home, color: Colors.white),
                label: const Text(
                  'Go Live (Host)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7675),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 5,
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => _startLive(isHost: false),
                icon: const Icon(Icons.login, color: Colors.white),
                label: const Text(
                  'Watch Live (Audience)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF6C5CE7), width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveStreamingScreen extends StatefulWidget {
  final String liveID;
  final String userID;
  final String userName;
  final bool isHost;

  const LiveStreamingScreen({
    super.key,
    required this.liveID,
    required this.userID,
    required this.userName,
    required this.isHost,
  });

  @override
  State<LiveStreamingScreen> createState() => _LiveStreamingScreenState();
}

class _LiveStreamingScreenState extends State<LiveStreamingScreen> {
  final GoogleTranslator _translator = GoogleTranslator();
  bool _autoTranslate = true;
  String _targetLanguage = 'ta'; // Default to Tamil ('ta')

  // Sample credentials for demo - users can replace with their actual Zego Dashboard AppID & AppSign
  final int _appID = 1234567890; 
  final String _appSign = "abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890";

  final List<Map<String, String>> _messages = [];
  final TextEditingController _chatController = TextEditingController();

  void _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    _chatController.clear();
    setState(() {
      _messages.add({
        'sender': widget.userName,
        'original': text,
        'translated': 'மொழிபெயர்க்கப்படுகிறது...',
      });
    });

    final index = _messages.length - 1;

    if (_autoTranslate) {
      try {
        final translation = await _translator.translate(text, to: _targetLanguage);
        setState(() {
          _messages[index]['translated'] = translation.text;
        });
      } catch (e) {
        setState(() {
          _messages[index]['translated'] = text;
        });
      }
    } else {
      setState(() {
        _messages[index]['translated'] = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Zego Live Streaming Engine View
          SafeArea(
            child: ZegoUIKitPrebuiltLiveStreaming(
              appID: _appID,
              appSign: _appSign,
              userID: widget.userID,
              userName: widget.userName,
              liveID: widget.liveID,
              config: widget.isHost
                  ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                  : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
            ),
          ),

          // Two-Way Translation & Custom Chat Overlay
          Positioned(
            bottom: 80,
            left: 12,
            right: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Translation Control Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.translate, size: 16, color: Color(0xFFFF7675)),
                      const SizedBox(width: 6),
                      const Text('Auto Translate:', style: TextStyle(fontSize: 12)),
                      Switch(
                        value: _autoTranslate,
                        activeColor: const Color(0xFFFF7675),
                        onChanged: (val) {
                          setState(() {
                            _autoTranslate = val;
                          });
                        },
                      ),
                      DropdownButton<String>(
                        value: _targetLanguage,
                        dropdownColor: const Color(0xFF1B143A),
                        underline: const SizedBox(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        items: const [
                          DropdownMenuItem(value: 'ta', child: Text('தமிழ் (Tamil)')),
                          DropdownMenuItem(value: 'en', child: Text('English')),
                          DropdownMenuItem(value: 'hi', child: Text('हिंदी (Hindi)')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _targetLanguage = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                // Real-time Translated Chat Box
                Container(
                  height: 150,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: _messages.length,
                    reverse: true,
                    itemBuilder: (context, index) {
                      final item = _messages[_messages.length - 1 - index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${item['sender']}: ",
                                style: const TextStyle(
                                  color: Color(0xFFA29BFE),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              TextSpan(
                                text: "${item['translated']} ",
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                              if (item['original'] != item['translated'])
                                TextSpan(
                                  text: "(${item['original']})",
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Chat Input Field
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: TextField(
                          controller: _chatController,
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Type message to translate & send...',
                            hintStyle: TextStyle(color: Colors.white54, fontSize: 12),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: const Color(0xFF6C5CE7),
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.send, size: 18, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
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
