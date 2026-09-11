import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() {
  runApp(const FizzLiveApp());
}

class FizzLiveApp extends StatelessWidget {
  const FizzLiveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F0F1E),
        primaryColor: const Color(0xFFFF2A6D),
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
  final TextEditingController _roomController = TextEditingController(text: 'room101');
  final TextEditingController _userController = TextEditingController(text: 'User_${DateTime.now().millisecondsSinceEpoch % 1000}');
  bool isStreamer = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live 🌟', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _roomController,
              decoration: InputDecoration(
                labelText: 'Room ID',
                filled: true,
                fillColor: const Color(0xFF1D1E33),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: 'Your Name',
                filled: true,
                fillColor: const Color(0xFF1D1E33),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Watch Stream'),
                Switch(
                  value: isStreamer,
                  activeColor: const Color(0xFFFF2A6D),
                  onChanged: (val) => setState(() => isStreamer = val),
                ),
                const Text('Be a Streamer 🎥'),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2A6D),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveStreamScreen(
                      roomID: _roomController.text.trim(),
                      userID: _userController.text.trim(),
                      isHost: isStreamer,
                    ),
                  ),
                );
              },
              child: Text(
                isStreamer ? 'Go Live' : 'Join Room',
                style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String sender;
  final String original;
  final String translated;
  ChatMessage({required this.sender, required this.original, required this.translated});
}

class LiveStreamScreen extends StatefulWidget {
  final String roomID;
  final String userID;
  final bool isHost;

  const LiveStreamScreen({
    super.key,
    required this.roomID,
    required this.userID,
    required this.isHost,
  });

  @override
  State<LiveStreamScreen> createState() => _LiveStreamScreenState();
}

class _LiveStreamScreenState extends State<LiveStreamScreen> {
  final GoogleTranslator translator = GoogleTranslator();
  final List<ChatMessage> messages = [];
  final TextEditingController _msgController = TextEditingController();
  
  bool autoTranslateEnabled = true;
  String myLanguage = 'ta'; // Tamil
  String peerLanguage = 'en'; // Target receiver language

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;

    String targetText = text;
    if (autoTranslateEnabled) {
      try {
        var translation = await translator.translate(text, to: peerLanguage);
        targetText = translation.text;
      } catch (_) {
        targetText = text;
      }
    }

    setState(() {
      messages.add(ChatMessage(
        sender: widget.userID,
        original: text,
        translated: targetText,
      ));
    });
    _msgController.clear();
  }

  Future<void> _receiveSimulatedMessage(String sender, String incomingText) async {
    String localTamil = incomingText;
    if (autoTranslateEnabled) {
      try {
        var translation = await translator.translate(incomingText, to: myLanguage);
        localTamil = translation.text;
      } catch (_) {
        localTamil = incomingText;
      }
    }

    setState(() {
      messages.add(ChatMessage(
        sender: sender,
        original: incomingText,
        translated: localTamil,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Zego Live Video View
          ZegoUIKitPrebuiltLiveStreaming(
            appID: 1538356877, // Fill your AppID
            appSign: 'a63ea24a2ef7fa86df76e271aeeea04db35cf972d0d04845579fa0374e2d27ad', // Fill your AppSign
            userID: widget.userID,
            userName: widget.userID,
            liveID: widget.roomID,
            config: widget.isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
          ),

          // Top Translation Control Bar
          Positioned(
            top: 40,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.65),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.translate, color: Color(0xFFFF2A6D), size: 20),
                  const SizedBox(width: 8),
                  const Text('Auto-Translate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Switch(
                    value: autoTranslateEnabled,
                    activeColor: const Color(0xFFFF2A6D),
                    onChanged: (val) => setState(() => autoTranslateEnabled = val),
                  ),
                ],
              ),
            ),
          ),

          // Live Chat Overlay
          Positioned(
            bottom: 85,
            left: 15,
            right: 80,
            height: 220,
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[messages.length - 1 - index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${msg.sender}: ',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFFD166)),
                        ),
                        TextSpan(
                          text: autoTranslateEnabled ? msg.translated : msg.original,
                          style: const TextStyle(color: Colors.white),
                        ),
                        if (autoTranslateEnabled && msg.original != msg.translated)
                          TextSpan(
                            text: ' (${msg.original})',
                            style: const TextStyle(color: Colors.white54, fontSize: 11),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Field
          Positioned(
            bottom: 20,
            left: 15,
            right: 15,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: InputDecoration(
                      hintText: autoTranslateEnabled ? 'Type in Tamil/Thanglish (translates live)...' : 'Type message...',
                      filled: true,
                      fillColor: Colors.black.withOpacity(0.65),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: const Color(0xFFFF2A6D),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 18),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
