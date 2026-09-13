import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
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
        primaryColor: const Color(0xFFFF2D75),
      ),
      home: const AgeGateScreen(),
    );
  }
}

int userGems = 1670;
String currentUserName = 'User_${Random().nextInt(1000)}';
String currentUserID = 'user_${Random().nextInt(99999)}';
String currentUserGender = 'Male';
bool isSuperAdmin = false;

class AgeGateScreen extends StatefulWidget {
  const AgeGateScreen({super.key});

  @override
  State<AgeGateScreen> createState() => _AgeGateScreenState();
}

class _AgeGateScreenState extends State<AgeGateScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = 'Male';
  bool _is18Plus = false;

  void _proceed() {
    int age = int.tryParse(_ageController.text) ?? 0;
    if (!_is18Plus || age < 18) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('18+ Only!')),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter Name!')),
      );
      return;
    }

    currentUserName = _nameController.text.trim();
    currentUserGender = _selectedGender;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _checkAdminPin(String val) {
    if (val == '7777') {
      isSuperAdmin = true;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin Activated')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.live_tv_rounded, size: 70, color: Color(0xFFFF2D75)),
              const SizedBox(height: 12),
              const Text('FIZZ LIVE', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                onChanged: _checkAdminPin,
                decoration: const InputDecoration(labelText: 'Age (18+)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 14),
              DropdownButton<String>(
                value: _selectedGender,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male (Viewer)')),
                  DropdownMenuItem(value: 'Female', child: Text('Female (Go Live)')),
                ],
                onChanged: (val) => setState(() => _selectedGender = val!),
              ),
              const SizedBox(height: 14),
              CheckboxListTile(
                title: const Text('Confirm 18+'),
                value: _is18Plus,
                onChanged: (val) => setState(() => _is18Plus = val ?? false),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2D75)),
                onPressed: _proceed,
                child: const Text('ENTER APP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  String? activeMiniRoomID;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() => _isBannerLoaded = true),
        onAdFailedToLoad: (ad, err) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _openLive(String roomID, bool isHost) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveRoomScreen(
          roomID: roomID,
          isHost: isHost,
          onMiniPlayerRequested: (rId) => setState(() => activeMiniRoomID = rId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canGoLive = currentUserGender == 'Female' || isSuperAdmin;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live', style: TextStyle(color: Color(0xFFFF2D75))),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('Gems: $userGems', style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      title: const Text('Host 1'),
                      trailing: ElevatedButton(
                        onPressed: () => _openLive('room_101', false),
                        child: const Text('Watch'),
                      ),
                    ),
                    ListTile(
                      title: const Text('Host 2'),
                      trailing: ElevatedButton(
                        onPressed: () => _openLive('room_102', false),
                        child: const Text('Watch'),
                      ),
                    ),
                  ],
                ),
              ),
              if (_isBannerLoaded && _bannerAd != null)
                SizedBox(
                  height: _bannerAd!.size.height.toDouble(),
                  width: _bannerAd!.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
            ],
          ),
          if (activeMiniRoomID != null)
            Positioned(
              bottom: 60,
              right: 16,
              child: Container(
                width: 120,
                height: 160,
                color: Colors.black,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => activeMiniRoomID = null),
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: canGoLive
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFFF2D75),
              onPressed: () => _openLive('room_${currentUserID.substring(0, 4)}', true),
              child: const Icon(Icons.videocam),
            )
          : null,
    );
  }
}

class LiveRoomScreen extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final Function(String) onMiniPlayerRequested;

  const LiveRoomScreen({
    super.key,
    required this.roomID,
    required this.isHost,
    required this.onMiniPlayerRequested,
  });

  @override
  State<LiveRoomScreen> createState() => _LiveRoomState();
}

class _LiveRoomState extends State<LiveRoomScreen> {
  static const int appID = 123456789;
  static const String appSign = 'abcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890';

  bool isBusyMode = false;
  final List<String> chatMessages = ['Welcome!'];
  final TextEditingController _chatController = TextEditingController();

  final List<Map<String, dynamic>> gemsPackages = [
    {'gems': 4050, 'price': 'Rs.100'},
    {'gems': 8100, 'price': 'Rs.200'},
    {'gems': 16380, 'price': 'Rs.400'},
    {'gems': 32940, 'price': 'Rs.800'},
    {'gems': 66600, 'price': 'Rs.1600'},
    {'gems': 167400, 'price': 'Rs.4000'},
  ];

  void _sendGift(String giftName, int cost) {
    if (userGems >= cost) {
      setState(() {
        userGems -= cost;
        chatMessages.add('Sent $giftName!');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sent $giftName! Remaining: $userGems')),
      );
    } else {
      _showGemsRechargeSheet();
    }
  }

  void _showGemsRechargeSheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetCtx) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Recharge Gems', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gemsPackages.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.0,
                ),
                itemBuilder: (context, index) {
                  final item = gemsPackages[index];
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                    onPressed: () {
                      setState(() {
                        userGems += (item['gems'] as int);
                      });
                      Navigator.pop(sheetCtx);
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${item['gems']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        Text('${item['price']}', style: const TextStyle(fontSize: 10)),
                      ],
                    ),
                  );
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
    final liveConfig = widget.isHost
        ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
        : ZegoUIKitPrebuiltLiveStreamingConfig.audience();

    return Scaffold(
      body: Stack(
        children: [
          ZegoUIKitPrebuiltLiveStreaming(
            appID: appID,
            appSign: appSign,
            userID: currentUserID,
            userName: currentUserName,
            liveID: widget.roomID,
            config: liveConfig,
          ),
          if (isBusyMode)
            Container(
              color: Colors.black,
              child: const Center(
                child: Text('BUSY', style: TextStyle(color: Colors.white)),
              ),
            ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Gems: $userGems', style: const TextStyle(color: Colors.white)),
                Row(
                  children: [
                    if (widget.isHost)
                      IconButton(
                        icon: const Icon(Icons.videocam, color: Colors.white),
                        onPressed: () => setState(() => isBusyMode = !isBusyMode),
                      ),
                    IconButton(
                      icon: const Icon(Icons.close_fullscreen, color: Colors.white),
                      onPressed: () {
                        widget.onMiniPlayerRequested(widget.roomID);
                        Navigator.pop(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  width: 200,
                  child: ListView.builder(
                    itemCount: chatMessages.length,
                    itemBuilder: (ctx, i) => Text(chatMessages[i], style: const TextStyle(color: Colors.white)),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _chatController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(hintText: 'Chat...'),
                        onSubmitted: (t) {
                          if (t.trim().isNotEmpty) {
                            setState(() {
                              chatMessages.add('$currentUserName: $t');
                              _chatController.clear();
                            });
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Text('🌹'),
                      onPressed: () => _sendGift('Rose', 50),
                    ),
                    IconButton(
                      icon: const Text('🚀'),
                      onPressed: () => _sendGift('Rocket', 500),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: Colors.amber),
                      onPressed: _showGemsRechargeSheet,
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
