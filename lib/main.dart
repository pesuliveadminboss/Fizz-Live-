import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() => runApp(const FizzLiveApp());

class FizzLiveApp extends StatelessWidget {
  const FizzLiveApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fizz Live Pro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF09080F),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF09080F), elevation: 0),
      ),
      home: const AgeVerificationGate(),
    );
  }
}

class AgeVerificationGate extends StatelessWidget {
  const AgeVerificationGate({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0C13),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF1B1926),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFFF2E93), width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFFFF2E93).withOpacity(0.15)),
                    child: const Text('18+', style: TextStyle(color: Color(0xFFFF2E93), fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 18),
                  const Text('Age Verification Required', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text('Fizz Live contains live video streams strictly intended for adults.\nYou must be 18+ to enter.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FastLoginScreen())),
                      child: const Text('I Am 18 or Older - Enter', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FastLoginScreen extends StatelessWidget {
  const FastLoginScreen({super.key});

  void _showSecretAdminPrompt(BuildContext context) {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1D2B),
        title: const Text('Super Admin Verification', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(labelText: 'Enter Master PIN (7777)', labelStyle: TextStyle(color: Colors.grey)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
            onPressed: () {
              Navigator.pop(context);
              if (pinController.text.trim() == '7777') {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainDashboard(isSuperAdmin: true)));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid Master PIN!')));
              }
            },
            child: const Text('Activate Admin'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainDashboard(isSuperAdmin: false))),
                        child: const Text('Fast Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onLongPress: () => _showSecretAdminPrompt(context),
                      child: const Text('Agree to User Agreement and Privacy Policy', style: TextStyle(color: Colors.white38, fontSize: 11)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainDashboard extends StatefulWidget {
  final bool isSuperAdmin;
  const MainDashboard({super.key, this.isSuperAdmin = false});
  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  final String userID = 'user_${Random().nextInt(9000) + 1000}';
  final String userName = 'User_${Random().nextInt(900) + 100}';

  @override
  Widget build(BuildContext context) {
    final screens = [
      ForYouScreen(userID: userID, userName: userName, isSuperAdmin: widget.isSuperAdmin),
      FollowScreen(userID: userID, userName: userName, isSuperAdmin: widget.isSuperAdmin),
      const Center(child: Text('Game Center Hub', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Messages & Direct Calls', style: TextStyle(color: Colors.white))),
      MeProfileScreen(userID: userID, userName: userName, isSuperAdmin: widget.isSuperAdmin),
    ];
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: const Color(0xFF0F0E17),
        selectedItemColor: const Color(0xFFFF2E93),
        unselectedItemColor: Colors.white38,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up_alt_outlined), label: 'For You'),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Follow'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: 'Game'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Me'),
        ],
      ),
    );
  }
}

class ForYouScreen extends StatelessWidget {
  final String userID;
  final String userName;
  final bool isSuperAdmin;
  const ForYouScreen({super.key, required this.userID, required this.userName, required this.isSuperAdmin});

  @override
  Widget build(BuildContext context) {
    final streamers = [
      {'name': 'وردة (Rose)', 'id': 'room_101', 'tag': 'Hot'},
      {'name': 'ROPA Live', 'id': 'room_102', 'tag': 'Live'},
      {'name': 'Anushka Roy', 'id': 'room_103', 'tag': 'Top 1'},
      {'name': 'Nilu Star', 'id': 'room_104', 'tag': 'New'},
      {'name': 'Sanya Glow', 'id': 'room_105', 'tag': 'Model'},
      {'name': 'Kajal Queen', 'id': 'room_106', 'tag': 'Chat'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live Pro', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        actions: [
          if (isSuperAdmin)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
              child: const Text('SUPER ADMIN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: streamers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.75),
        itemBuilder: (context, index) {
          final s = streamers[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveStreamView(
                    roomID: s['id']!,
                    isHost: false,
                    userID: userID,
                    userName: userName,
                    hostTitle: s['name']!,
                    isSuperAdmin: isSuperAdmin,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF1E1B2E), borderRadius: BorderRadius.circular(16)),
              child: Stack(
                children: [
                  Center(child: Icon(Icons.person, size: 70, color: Colors.white.withOpacity(0.15))),
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFFFF2E93), borderRadius: BorderRadius.circular(6)),
                      child: Text(s['tag']!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Text(s['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class FollowScreen extends StatelessWidget {
  final String userID;
  final String userName;
  final bool isSuperAdmin;
  const FollowScreen({super.key, required this.userID, required this.userName, required this.isSuperAdmin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Following')),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.pink, child: Icon(Icons.person, color: Colors.white)),
            title: const Text('Sexy Queen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Streaming Now', style: TextStyle(color: Colors.white54)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveStreamView(roomID: 'room_201', isHost: false, userID: userID, userName: userName, hostTitle: 'Sexy Queen', isSuperAdmin: isSuperAdmin),
                  ),
                );
              },
              child: const Text('Watch'),
            ),
          ),
        ],
      ),
    );
  }
}

class MeProfileScreen extends StatefulWidget {
  final String userID;
  final String userName;
  final bool isSuperAdmin;
  const MeProfileScreen({super.key, required this.userID, required this.userName, required this.isSuperAdmin});
  @override
  State<MeProfileScreen> createState() => _MeProfileScreenState();
}

class _MeProfileScreenState extends State<MeProfileScreen> {
  int userGems = 2500;

  void _showRechargeSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F1D2B),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Top Up Gems Wallet', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              _packRow('100 Gems', '₹99', () => _addGems(100)),
              _packRow('600 Gems (+50 Free)', '₹499', () => _addGems(650)),
              _packRow('2,500 Gems (+300 Free)', '₹1,999', () => _addGems(2800)),
            ],
          ),
        );
      },
    );
  }

  void _addGems(int count) {
    Navigator.pop(context);
    setState(() => userGems += count);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $count Gems to Wallet!')));
  }

  Widget _packRow(String label, String price, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: const Color(0xFF282538), borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.diamond, color: Colors.cyanAccent),
        title: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        trailing: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)), onPressed: onTap, child: Text(price)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Me Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              CircleAvatar(radius: 28, backgroundColor: Colors.purpleAccent, child: Text(widget.isSuperAdmin ? 'A' : 'U', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold))),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.isSuperAdmin ? 'Super Admin Master' : widget.userName, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('ID: ${widget.userID}', style: const TextStyle(color: Colors.white38, fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: _showRechargeSheet,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: const Color(0xFF221E38), borderRadius: BorderRadius.circular(14)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Gems Wallet', style: TextStyle(color: Colors.white54, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(widget.isSuperAdmin ? 'UNLIMITED' : '$userGems Gems', style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 18)),
                    ],
                  ),
                  const Icon(Icons.add_circle, color: Color(0xFFFF2E93), size: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LiveStreamView extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final String userID;
  final String userName;
  final String hostTitle;
  final bool isSuperAdmin;

  const LiveStreamView({
    super.key,
    required this.roomID,
    required this.isHost,
    required this.userID,
    required this.userName,
    this.hostTitle = 'Live Stream',
    this.isSuperAdmin = false,
  });

  @override
  State<LiveStreamView> createState() => _LiveStreamViewState();
}

class _LiveStreamViewState extends State<LiveStreamView> {
  String? _giftSplash;

  void _showGiftTray() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1B1926).withOpacity(0.95),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Send In-Stream Gift', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _giftItem('🌹 Rose', () => _sendGift('🌹 ROSE BLAST!')),
                  _giftItem('🚀 Rocket', () => _sendGift('🚀 MEGA ROCKET FIRED!')),
                  _giftItem('🏎️ Sports Car', () => _sendGift('🏎️ SPORTS CAR ARRIVED!')),
                  _giftItem('👑 Crown', () => _sendGift('👑 ROYAL CROWN PRESENTED!')),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendGift(String text) {
    Navigator.pop(context);
    setState(() => _giftSplash = text);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _giftSplash = null);
    });
  }

  Widget _giftItem(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF2B273D), borderRadius: BorderRadius.circular(12)),
            child: Text(label.split(' ')[0], style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(height: 4),
          Text(label.split(' ')[1], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      ),
    );
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
            userID: widget.userID,
            userName: widget.isSuperAdmin ? 'System Inspector' : widget.userName,
            liveID: widget.roomID,
            config: widget.isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                : ZegoUIKitP
