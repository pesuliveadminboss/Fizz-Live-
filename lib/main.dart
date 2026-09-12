import 'dart:math';
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
                  const Text('Fizz Live contains live streams strictly for adults.\nYou must be 18+ to enter.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const UserRegistrationScreen())),
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

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _nameController = TextEditingController(text: 'Sweet Girl');
  final _ageController = TextEditingController(text: '20');
  String _selectedGender = 'Female';

  void _proceed(bool isFast) {
    int age = int.tryParse(_ageController.text.trim()) ?? 18;
    String name = isFast ? 'User_${Random().nextInt(899) + 100}' : _nameController.text.trim();
    if (name.isEmpty) name = 'User_${Random().nextInt(899) + 100}';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainDashboard(userName: name, gender: _selectedGender, userAge: age, isSuperAdmin: false),
      ),
    );
  }

  void _openAdmin() {
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainDashboard(userName: 'Admin Master', gender: 'Female', userAge: 25, isSuperAdmin: true)),
                );
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('Create Profile', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Name', filled: true, fillColor: Color(0xFF1B1926)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: 'Age (18+)', filled: true, fillColor: Color(0xFF1B1926)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _selectedGender == 'Female' ? const Color(0xFFFF2E93) : const Color(0xFF1B1926)),
                      onPressed: () => setState(() => _selectedGender = 'Female'),
                      child: const Text('Female (Can Stream)'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _selectedGender == 'Male' ? Colors.blueAccent : const Color(0xFF1B1926)),
                      onPressed: () => setState(() => _selectedGender = 'Male'),
                      child: const Text('Male (Viewer Only)'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                  onPressed: () => _proceed(false),
                  child: const Text('Start Watching / Streaming'),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onLongPress: _openAdmin,
                child: const Text('Terms & Super Admin Gateway', style: TextStyle(color: Colors.white38, fontSize: 11)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// GLOBAL CONTROLLER FOR MINI-PLAYER PIP
ValueNotifier<Map<String, dynamic>?> activeMiniPlayer = ValueNotifier<Map<String, dynamic>?>(null);

class MainDashboard extends StatefulWidget {
  final String userName;
  final String gender;
  final int userAge;
  final bool isSuperAdmin;

  const MainDashboard({super.key, required this.userName, required this.gender, required this.userAge, this.isSuperAdmin = false});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _idx = 0;
  final String userID = 'user_${Random().nextInt(9000) + 1000}';

  @override
  Widget build(BuildContext context) {
    final screens = [
      ForYouScreen(userID: userID, userName: widget.userName, gender: widget.gender, isSuperAdmin: widget.isSuperAdmin),
      const Center(child: Text('Followers Feed', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Game Hub', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Messages', style: TextStyle(color: Colors.white))),
      MeProfileScreen(userID: userID, userName: widget.userName, gender: widget.gender, isSuperAdmin: widget.isSuperAdmin),
    ];

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _idx, children: screens),
          // FLOATING MINI-PLAYER (BOTTOM RIGHT MINI WINDOW)
          ValueListenableBuilder<Map<String, dynamic>?>(
            valueListenable: activeMiniPlayer,
            builder: (context, miniData, child) {
              if (miniData == null) return const SizedBox.shrink();
              return Positioned(
                bottom: 65,
                right: 12,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    width: 150,
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFF2E93), width: 2),
                      boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 8)],
                    ),
                    child: Stack(
                      children: [
                        // If Streamer is Busy, show Black Screen with Busy notice
                        if (miniData['isBusy'] == true)
                          Container(
                            color: Colors.black,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.do_not_disturb_on, color: Colors.redAccent, size: 36),
                                const SizedBox(height: 8),
                                Text(miniData['hostTitle'], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                const SizedBox(height: 4),
                                const Text('STREAMER BUSY', style: TextStyle(color: Colors.redAccent, fontSize: 9, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          )
                        else
                        // Audio-Only / Video Mini Stream
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ZegoUIKitPrebuiltLiveStreaming(
                              appID: 1576404113,
                              appSign: 'b76540c4974fa2e1ec73787768beaa2c93839634e3e3b33100be649f82662c11',
                              userID: miniData['userID'],
                              userName: miniData['userName'],
                              liveID: miniData['roomID'],
                              config: ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
                            ),
                          ),

                        // Top Close (X) button for Mini Player
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => activeMiniPlayer.value = null,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: const Icon(Icons.close, color: Colors.white, size: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
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
    );
  }
}

class ForYouScreen extends StatelessWidget {
  final String userID;
  final String userName;
  final String gender;
  final bool isSuperAdmin;

  const ForYouScreen({super.key, required this.userID, required this.userName, required this.gender, required this.isSuperAdmin});

  @override
  Widget build(BuildContext context) {
    final bool canStream = isSuperAdmin || gender.toLowerCase() == 'female';

    final streamers = [
      {'name': 'Rose Live', 'id': 'room_101', 'busy': false},
      {'name': 'Anushka (Busy)', 'id': 'room_102', 'busy': true},
      {'name': 'Sanya Glow', 'id': 'room_103', 'busy': false},
      {'name': 'Kajal Queen', 'id': 'room_104', 'busy': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fizz Live Pro'),
        actions: [
          if (canStream)
            IconButton(
              icon: const Icon(Icons.video_call, color: Color(0xFFFF2E93), size: 30),
              onPressed: () {
                activeMiniPlayer.value = null; // Clear mini player if hosting
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LiveScreen(roomID: 'stream_$userID', isHost: true, userID: userID, userName: userName, hostTitle: '$userName (Host)')),
                );
              },
            ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: streamers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8),
        itemBuilder: (context, i) {
          final s = streamers[i];
          return InkWell(
            onTap: () {
              // If user is already watching something in mini player, clear it before opening full screen
              activeMiniPlayer.value = null;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveScreen(
                    roomID: s['id']! as String,
                    isHost: false,
                    userID: userID,
                    userName: userName,
                    hostTitle: s['name']! as String,
                    isBusy: s['busy']! as bool,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF1E1B2E), borderRadius: BorderRadius.circular(14)),
              child: Stack(
                children: [
                  const Center(child: Icon(Icons.person, size: 60, color: Colors.white24)),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(s['name']! as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        if (s['busy'] == true)
                          const Text('BUSY', style: TextStyle(color: Colors.redAccent, fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
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

class MeProfileScreen extends StatefulWidget {
  final String userID;
  final String userName;
  final String gender;
  final bool isSuperAdmin;

  const MeProfileScreen({super.key, required this.userID, required this.userName, required this.gender, required this.isSuperAdmin});

  @override
  State<MeProfileScreen> createState() => _MeProfileScreenState();
}

class _MeProfileScreenState extends State<MeProfileScreen> {
  int gems = 2500;
  bool isBusyMode = false;

  @override
  Widget build(BuildContext context) {
    final isFemale = widget.gender.toLowerCase() == 'female';

    return Scaffold(
      appBar: AppBar(title: const Text('Me Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: CircleAvatar(backgroundColor: isFemale ? Colors.pink : Colors.blue, child: Icon(isFemale ? Icons.female : Icons.male, color: Colors.white)),
            title: Text(widget.isSuperAdmin ? 'Super Admin Master' : widget.userName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text('Status: ${isFemale || widget.isSuperAdmin ? "Verified Host" : "Viewer"}'),
          ),
          const SizedBox(height: 16),
          // Busy Mode Switch for Host
          SwitchListTile(
            title: const Text('Streamer Busy Mode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Show black screen to viewers when busy', style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: isBusyMode,
            activeColor: Colors.redAccent,
            onChanged: (val) => setState(() => isBusyMode = val),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: const Color(0xFF221E38), borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.isSuperAdmin ? 'Gems: UNLIMITED' : 'Gems: $gems', style: const TextStyle(color: Colors.cyanAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
                  onPressed: () => setState(() => gems += 500),
                  child: const Text('Top Up'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LiveScreen extends StatelessWidget {
  final String roomID;
  final bool isHost;
  final String userID;
  final String userName;
  final String hostTitle;
  final bool isBusy;

  const LiveScreen({
    super.key,
    required this.roomID,
    required this.isHost,
    required this.userID,
    required this.userName,
    this.hostTitle = 'Live Stream',
    this.isBusy = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          ZegoUIKitPrebuiltLiveStreaming(
            appID: 1576404113,
     
