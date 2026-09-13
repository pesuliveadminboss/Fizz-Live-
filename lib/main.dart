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

// ---------------- GLOBAL STATE ----------------
int userGems = 1670;
String currentUserName = 'User_${Random().nextInt(1000)}';
String currentUserID = 'user_${Random().nextInt(99999)}';
String currentUserGender = 'Male';
bool isSuperAdmin = false;

// ---------------- 1. AGE GATE SCREEN ----------------
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
        const SnackBar(content: Text('You must be 18+ to enter Fizz Live!')),
      );
      return;
    }
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name!')),
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
        const SnackBar(content: Text('Super Admin Mode Activated! (7777)')),
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
              const Text(
                'FIZZ LIVE',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 2),
              ),
              const SizedBox(height: 4),
              const Text('18+ Adult Live Streaming Community', style: TextStyle(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 30),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Your Name / Nickname',
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                onChanged: _checkAdminPin,
                decoration: InputDecoration(
                  labelText: 'Your Age (18+)',
                  filled: true,
                  fillColor: Colors.white10,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white24),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedGender,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF1E1E2C),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male (Viewer Mode)')),
                      DropdownMenuItem(value: 'Female', child: Text('Female (Can Go Live)')),
                    ],
                    onChanged: (val) {
                      setState(() {
                        _selectedGender = val!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 14),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('I confirm that I am at least 18 years old.', style: TextStyle(fontSize: 13)),
                value: _is18Plus,
                activeColor: const Color(0xFFFF2D75),
                onChanged: (val) {
                  setState(() {
                    _is18Plus = val ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2D75),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _proceed,
                  child: const Text('ENTER FIZZ LIVE', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------- 2. HOME SCREEN ----------------
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;
  String? activeMiniRoomID;

  final List<Map<String, String>> liveRooms = [
    {'id': 'room_101', 'host': 'Priya Live', 'viewers': '1.2k'},
    {'id': 'room_102', 'host': 'Ananya Stream', 'viewers': '850'},
    {'id': 'room_103', 'host': 'Sneha Chat', 'viewers': '2.1k'},
  ];

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
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
          onMiniPlayerRequested: (rId) {
            setState(() {
              activeMiniRoomID = rId;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool canGoLive = currentUserGender == 'Female' || isSuperAdmin;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Fizz Live', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF2D75))),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.diamond_rounded, color: Colors.amber, size: 16),
                const SizedBox(width: 4),
                Text('$userGems', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: liveRooms.length,
                  itemBuilder: (context, index) {
                    final room = liveRooms[index];
                    return Card(
                      color: const Color(0xFF1B1B2F),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFF2D75),
                          child: Text(room['host']![0], style: const TextStyle(color: Colors.white)),
                        ),
                        title: Text(room['host']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${room['viewers']} Viewers', style: const TextStyle(color: Colors.white54)),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2D75)),
                          onPressed: () => _openLive(room['id']!, false),
                          child: const Text('Watch'),
                        ),
                      ),
                    );
                  },
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
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 140,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFFF2D75), width: 2),
                  ),
                  child: Stack(
                    children: [
                      const Center(
                        child: Icon(Icons.live_tv, color: Colors.white54, size: 40),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => activeMiniRoomID = null),
                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.black54,
                            child: Icon(Icons.close, color: Colors.white, size: 14),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 6,
                        left: 8,
                        child: Text(
                          activeMiniRoomID!,
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: canGoLive
          ? FloatingActionButton.extended(
              backgroundColor: const Color(0xFFFF2D75),
              icon: const Icon(Icons.videocam_rounded),
              label: const Text('GO LIVE'),
              onPressed: () => _openLive('room_${currentUserID.substring(0, 4)}', true),
            )
          : null,
    );
  }
}

// ---------------- 3. LIVE STREAM SCREEN ----------------
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
  final List<String> chatMessages = ['Welcome to Fizz Live!'];
  final TextEditingController _chatController = TextEditingController();
  int selectedGemsIndex = 0;

  final List<Map<String, dynamic>> gemsPackages = [
    {'gems': 4050, 'price': 'Rs.100.00', 'tag': 'ONCE'},
    {'gems': 8100, 'price': 'Rs.200.00', 'tag': '17%off'},
    {'gems': 16380, 'price': 'Rs.400.00', 'tag': '17%off'},
    {'gems': 32940, 'price': 'Rs.800.00', 'tag': '17%off'},
    {'gems': 66600, 'price': 'Rs.1600.00', 'tag': '30%off'},
    {'gems': 167400, 'price': 'Rs.4000.00', 'tag': '60%off'},
  ];

  void _sendGift(String giftName, int cost) {
    if (userGems >= cost) {
      setState(() {
        userGems -= cost;
        chatMessages.add('$currentUserName sent $giftName!');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFFF2D75),
          content: Text('$giftName sent! Balance: $userGems Gems'),
          duration: const Duration(seconds: 1),
        ),
      );
    } else {
      _showGemsRechargeSheet();
    }
  }

  void _showGemsRechargeSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(sheetContext),
                    ),
                  ),
                  const Text(
                    'Make video calls with Gems',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text('Call beauties with Gems', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: gemsPackages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemBuilder: (context, index) {
                      final item = gemsPackages[index];
                      final isSelected = selectedGemsIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedGemsIndex = index;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFFF3E0) : const Color(0xFFF9F9F9),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.orangeAccent : Colors.black12,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.diamond_rounded, color: Colors.amber, size: 26),
                              const SizedBox(height: 4),
                              Text(
                                '${item['gems']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.orange[800] : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item['price']}',
                                style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text('My Gems: $userGems', style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2D75),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        final selected = gemsPackages[selectedGemsIndex];
                        setState(() {
                          userGems += (selected['gems'] as int);
                        });
                        Navigator.pop(sheetContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('${selected['gems']} Gems Added!')),
                        );
                      },
                      child: const Text('Continue', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ZegoUIKitPrebuiltLiveStreaming(
            appID: appID,
            appSign: appSign,
            userID: currentUserID,
            userName: currentUserName,
            liveID: widget.roomID,
            config: widget.isHost
             
