import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const FizzApp());
}

class FizzApp extends StatelessWidget {
  const FizzApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF09080F)),
      home: const AgeGate(),
    );
  }
}

class AgeGate extends StatelessWidget {
  const AgeGate({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C13),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: const Color(0xFF1B1926), borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFFFF2E93), width: 1.5)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('18+', style: TextStyle(color: Color(0xFFFF2E93), fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 18),
                const Text('Age Verification Required', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                const Text('Strictly for 18+ adults only.', style: TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                    onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                    child: const Text('I Am 18 or Older - Enter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController(text: 'Sweet Girl');
  String _gender = 'Female';

  void _submit(bool fast) {
    String name = fast ? 'User_${Random().nextInt(899)+100}' : _name.text.trim();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard(name: name, gender: _gender, isAdmin: false)));
  }

  void _admin() {
    final pin = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1D2B),
        title: const Text('Master PIN (7777)', style: TextStyle(color: Colors.white)),
        content: TextField(controller: pin, obscureText: true, style: const TextStyle(color: Colors.white)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
            onPressed: () {
              Navigator.pop(context);
              if (pin.text.trim() == '7777') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Dashboard(name: 'Admin Master', gender: 'Female', isAdmin: true)));
              }
            },
            child: const Text('Enter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Create Profile', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextField(controller: _name, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(labelText: 'Name', filled: true, fillColor: Color(0xFF1B1926))),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _gender == 'Female' ? const Color(0xFFFF2E93) : const Color(0xFF1B1926)), onPressed: () => setState(() => _gender = 'Female'), child: const Text('Female (Host)'))),
                const SizedBox(width: 10),
                Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: _gender == 'Male' ? Colors.blueAccent : const Color(0xFF1B1926)), onPressed: () => setState(() => _gender = 'Male'), child: const Text('Male (Viewer)'))),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity, height: 48, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)), onPressed: () => _submit(false), child: const Text('Continue'))),
            const SizedBox(height: 12),
            TextButton(onPressed: () => _submit(true), child: const Text('Fast Login', style: TextStyle(color: Colors.white70))),
            const SizedBox(height: 16),
            GestureDetector(onLongPress: _admin, child: const Text('Admin Gateway', style: TextStyle(color: Colors.white38, fontSize: 11))),
          ],
        ),
      ),
    );
  }
}

ValueNotifier<Map<String, dynamic>?> miniStream = ValueNotifier<Map<String, dynamic>?>(null);
ValueNotifier<int> globalUserGems = ValueNotifier<int>(2500);

class Dashboard extends StatefulWidget {
  final String name;
  final String gender;
  final bool isAdmin;
  const Dashboard({super.key, required this.name, required this.gender, required this.isAdmin});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _idx = 0;
  late final String uid = 'user_${Random().nextInt(9000)+1000}';
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeTab(uid: uid, name: widget.name, gender: widget.gender, isAdmin: widget.isAdmin),
      const Center(child: Text('Follow', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Game', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Chat', style: TextStyle(color: Colors.white))),
      ProfileTab(uid: uid, name: widget.name, gender: widget.gender, isAdmin: widget.isAdmin),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _idx, children: pages),
          ValueListenableBuilder<Map<String, dynamic>?>(
            valueListenable: miniStream,
            builder: (context, data, child) {
              if (data == null) return const SizedBox.shrink();
              return Positioned(
                bottom: _isAdLoaded ? 115 : 65, right: 12,
                child: Container(
                  width: 140, height: 200,
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFF2E93), width: 2)),
                  child: Stack(
                    children: [
                      data['busy'] == true
                          ? const Center(child: Text('BUSY', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: ZegoUIKitPrebuiltLiveStreaming(
                                appID: 1576404113,
                                appSign: 'b76540c4974fa2e1ec73787768beaa2c93839634e3e3b33100be649f82662c11',
                                userID: uid,
                                userName: widget.name,
                                liveID: data['room'],
                                config: ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
                              ),
                            ),
                      Positioned(
                        top: 4, right: 4,
                        child: GestureDetector(
                          onTap: () => miniStream.value = null,
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isAdLoaded && _bannerAd != null)
            SizedBox(
              height: _bannerAd!.size.height.toDouble(),
              width: _bannerAd!.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          BottomNavigationBar(
            currentIndex: _idx,
            onTap: (i) => setState(() => _idx = i),
            backgroundColor: const Color(0xFF0F0E17),
            selectedItemColor: const Color(0xFFFF2E93),
            unselectedItemColor: Colors.white38,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.videocam), label: 'Live'),
              BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Follow'),
              BottomNavigationBarItem(icon: Icon(Icons.casino), label: 'Game'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  final String uid;
  final String name;
  final String gender;
  final bool isAdmin;
  const HomeTab({super.key, required this.uid, required this.name, required this.gender, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    bool canGoLive = isAdmin || gender.toLowerCase() == 'female';
    final rooms = [
      {'name': 'Rose Live', 'id': 'room_101', 'busy': false},
      {'name': 'Anushka (Busy)', 'id': 'room_102', 'busy': true},
      {'name': 'Sanya Glow', 'id': 'room_103', 'busy': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live Pro (Monetized)'),
        actions: [
          if (canGoLive)
            IconButton(
              icon: const Icon(Icons.video_call, color: Color(0xFFFF2E93)),
              onPressed: () {
                miniStream.value = null;
                Navigator.push(context, MaterialPageRoute(builder: (context) => LiveRoom(room: 'stream_$uid', isHost: true, uid: uid, name: name, title: '$name (Host)', isAdmin: isAdmin)));
              },
            ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: rooms.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8),
        itemBuilder: (context, i) {
          final r = rooms[i];
          return InkWell(
            onTap: () {
              miniStream.value = null;
              Navigator.push(context, MaterialPageRoute(builder: (context) => LiveRoom(room: r['id']! as String, isHost: false, uid: uid, name: name, title: r['name']! as String, isBusy: r['busy']! as bool, isAdmin: isAdmin)));
            },
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF1E1B2E), borderRadius: BorderRadius.circular(14)),
              child: Stack(
                children: [
                  const Center(child: Icon(Icons.person, size: 50, color: Colors.white24)),
                  Positioned(bottom: 10, left: 10, child: Text(r['name']! as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileTab extends StatelessWidget {
  final String uid;
  final String name;
  final String gender;
  final bool isAdmin;
  const ProfileTab({super.key, required this.uid, required this.name, required this.gender, required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Me Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.person, color: Colors.white)),
              title: Text(isAdmin ? 'Admin Master' : name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('Gender: $gender'),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<int>(
              valueListenable: globalUserGems,
              builder: (context, gems, child) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: const Color(0xFF221E38), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(isAdmin ? 'Gems: UNLIMITED' : 'Gems: $gems', style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                        onPressed: () => globalUserGems.value += 500,
                        child: const Text('Top Up'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LiveRoom extends StatefulWidget {
  final String room;
  final bool isHost;
  final String uid;
  final String name;
  final String title;
  final bool isBusy;
  final bool isAdmin;

  const LiveRoom({super.key, required this.room, required this.isHost, required this.uid, required this.name, this.title = 'Live', this.isBusy = false, required this.isAdmin});

  @override
  State<LiveRoom> createState() => _LiveRoomState();
}

class _LiveRoomState extends State<LiveRoom> {
  String? giftSplash;
  final List<String> messages = ['Welcome!', 'Hello! 👋'];
  final TextEditingController chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!widget.isHost) {
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) => ad.show(),
          onAdFailedToLoad: (err) {},
        ),
      );
    }
  }

  void sendGift(String giftName, int cost) {
    if (!widget.isAdmin && globalUserGems.value < cost) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insufficient Gems!')));
      return;
    }
    if (!widget.isAdmin) globalUserGems.value -= cost;
    Navigator.pop(context);
    setState(() => giftSplash = giftName);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => giftSplash = null);
    });
  }

  void openGiftTray() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1D2B),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(onPressed: () => sendGift('🌹 Rose Blast!', 100), child: const Text('🌹 Rose (100)')),
            ElevatedButton(onPressed: () => sendGift('🚀 Mega Rocket!', 500), child: const Text('🚀 Rocket (500)')),
          ],
        ),
      ),
    );
  }

  void sendMessage() {
    if (chatController.text.trim().isNotEmpty) {
      setState(() {
        messages.add('${widget.name}: ${chatController.text.trim()}');
        chatController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ZegoUIKitPrebuiltLiveStreaming(
            appID: 1576404113,
            appSign: 'b76540c4974fa2e1ec73787768beaa2c93839634e3e3b33100be649f82662c11',
            userID: widget.uid,
            userName: widget.name,
            liveID: widget.room,
            config: widget.isHost ? ZegoUIKitPrebuiltLiveStreamingConfig.host() : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(15)),
                    child: Text(widget.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      if (!widget.isHost) miniStream.value = {'room': widget.room, 'busy': widget.isBusy};
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 70, left: 12, right: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 100, padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                  child: ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, i) => Text(messages[i], style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: chatController,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        decoration: InputDecoration(
                          hintText: 'Say something...',
                          filled: true, fillColor: Colors.black54,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borde
