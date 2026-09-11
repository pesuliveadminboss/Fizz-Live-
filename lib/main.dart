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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0B18),
        primaryColor: const Color(0xFFFF2D75),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF2D75),
          secondary: Color(0xFF8A2BE2),
        ),
      ),
      home: const LivmetHomeScreen(),
    );
  }
}

class LivmetHomeScreen extends StatefulWidget {
  const LivmetHomeScreen({super.key});

  @override
  State<LivmetHomeScreen> createState() => _LivmetHomeScreenState();
}

class _LivmetHomeScreenState extends State<LivmetHomeScreen> {
  int _selectedTabIndex = 0;
  late final String _userId;
  late final String _userName;

  final List<Map<String, String>> liveRooms = [
    {"id": "7777", "name": "Priya Live 🔥", "viewers": "1.2k", "tag": "Dancing"},
    {"id": "8888", "name": "Rahul Beats 🎵", "viewers": "850", "tag": "Singing"},
    {"id": "9999", "name": "Sneha Sweet Chat ✨", "viewers": "2.4k", "tag": "Talk"},
    {"id": "1111", "name": "Tamil Gamer 🎮", "viewers": "560", "tag": "Gaming"},
  ];

  @override
  void initState() {
    super.initState();
    final random = Random();
    _userId = "user_${random.nextInt(90000) + 10000}";
    _userName = "Fizz_${random.nextInt(900) + 100}";
  }

  void _joinLive(String roomID, bool isHost) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveStreamingPage(
          liveID: roomID,
          userID: _userId,
          userName: _userName,
          isHost: isHost,
        ),
      ),
    );
  }

  void _showGoLiveSheet() {
    final TextEditingController roomController = TextEditingController(text: "7777");
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161228),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 20),
            const Text("Start Your Live", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 15),
            TextField(
              controller: roomController,
              decoration: InputDecoration(
                labelText: "Live Room ID",
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.stream, color: Color(0xFFFF2D75)),
                filled: true,
                fillColor: const Color(0xFF221C3E),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                if (roomController.text.trim().isNotEmpty) {
                  _joinLive(roomController.text.trim(), true);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF2D75),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 8,
              ),
              child: const Text("GO LIVE NOW 🚀", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFFFF2D75), Color(0xFFFFA07A)],
              ).createShader(bounds),
              child: const Text("Fizz Live", style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white)),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 105,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [Color(0xFFFF2D75), Color(0xFF8A2BE2)]),
                          ),
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: const Color(0xFF221C3E),
                            child: Icon(Icons.person, size: 35, color: Colors.white.withOpacity(0.8)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(index == 0 ? "You" : "Star $index", style: const TextStyle(fontSize: 12, color: Colors.white70)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                children: [
                  Icon(Icons.local_fire_department, color: Color(0xFFFF2D75), size: 22),
                  SizedBox(width: 6),
                  Text("Popular Live", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.78,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final room = liveRooms[index % liveRooms.length];
                  return GestureDetector(
                    onTap: () => _joinLive(room["id"]!, false),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF251D42), Color(0xFF17132B)],
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Icon(Icons.play_circle_fill, size: 54, color: Colors.white.withOpacity(0.15)),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.55),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.remove_red_eye, color: Color(0xFFFF2D75), size: 12),
                                  const SizedBox(width: 4),
                                  Text(room["viewers"]!, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8A2BE2).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(room["tag"]!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(room["name"]!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                                const SizedBox(height: 2),
                                Text("Room ID: ${room["id"]}", style: const TextStyle(color: Colors.white54, fontSize: 11)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                childCount: liveRooms.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 90)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: GestureDetector(
        onTap: _showGoLiveSheet,
        child: Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFFFF2D75), Color(0xFF8A2BE2)],
            ),
            boxShadow: [
              BoxShadow(color: Color(0x66FF2D75), blurRadius: 16, offset: Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.video_call, size: 34, color: Colors.white),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF161228),
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.explore, color: _selectedTabIndex == 0 ? const Color(0xFFFF2D75) : Colors.white38),
                onPressed: () => setState(() => _selectedTabIndex = 0),
              ),
              IconButton(
                icon: Icon(Icons.chat_bubble_outline, color: _selectedTabIndex == 1 ? const Color(0xFFFF2D75) : Colors.white38),
                onPressed: () => setState(() => _selectedTabIndex = 1),
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: Icon(Icons.favorite_border, color: _selectedTabIndex == 2 ? const Color(0xFFFF2D75) : Colors.white38),
                onPressed: () => setState(() => _selectedTabIndex = 2),
              ),
              IconButton(
                icon: Icon(Icons.person_outline, color: _selectedTabIndex == 3 ? const Color(0xFFFF2D75) : Colors.white38),
                onPressed: () => setState(() => _selectedTabIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LiveStreamingPage extends StatefulWidget {
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
  State<LiveStreamingPage> createState() => _LiveStreamingPageState();
}

class _LiveStreamingPageState extends State<LiveStreamingPage> {
  final GoogleTranslator _translator = GoogleTranslator();
  final Map<String, String> _translatedMessages = {};

  Future<String> _translateText(String text) async {
    if (_translatedMessages.containsKey(text)) {
      return _translatedMessages[text]!;
    }
    try {
      // Auto-detects language: if Tamil translates to English, else translates to Tamil
      final translation = await _translator.translate(text, to: text.contains(RegExp(r'[\u0B80-\u0BFF]')) ? 'en' : 'ta');
      _translatedMessages[text] = translation.text;
      return translation.text;
    } catch (_) {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    const int appID = 1265895941;
    const String appSign = "0d5b622565bfc6cbaf590722eb3b661ff27e0eb3666040b6b7e5bfcfe161d44e";

    final config = widget.isHost
        ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
        : ZegoUIKitPrebuiltLiveStreamingConfig.audience();

    if (!widget.isHost) {
      config.bottomMenuBarConfig.audienceButtons = [
        ZegoMenuBarButtonName.coHostControlButton,
        ZegoMenuBarButtonName.chatButton,
        ZegoMenuBarButtonName.switchCameraButton,
      ];
    }

    // Realtime Auto-Translating Chat Bubble
    config.inRoomMessageConfig.itemBuilder = (context, message, extraInfo) {
      return FutureBuilder<String>(
        future: _translateText(message.message),
        builder: (context, snapshot) {
          final translated = snapshot.data;
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.user.name,
                  style: const TextStyle(
                    color: Color(0xFFFF7675),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                if (translated != null && translated != message.message) ...[
                  const SizedBox(height: 3),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.translate, size: 12, color: Color(0xFFA29BFE)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          translated,
                          style: const TextStyle(
                            color: Color(0xFFA29BFE),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      );
    };

    return SafeArea(
      child: ZegoUIKitPrebuiltLiveStreaming(
        appID: appID,
        appSign: appSign,
        userID: widget.userID,
        userName: widget.userName,
        liveID: widget.liveID,
        config: config,
      ),
    );
  }
}
