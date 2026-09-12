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

// 1. AGE GATEWAY (18+ MANDATORY)
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
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF2E93).withOpacity(0.15),
                    ),
                    child: const Text('18+', style: TextStyle(color: Color(0xFFFF2E93), fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 18),
                  const Text('Age Verification Required', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text(
                    'Fizz Live contains live streams strictly intended for adults.\nYou must be 18+ to enter.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF2E93),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const UserRegistrationScreen()),
                        );
                      },
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

// 2. NEW USER SETUP: NAME, AGE & GENDER (MALE/FEMALE)
class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final _nameController = TextEditingController(text: 'Sweet Girl');
  final _ageController = TextEditingController(text: '20');
  String _selectedGender = 'Female'; // Default Female

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainDashboard(
                      userName: 'Super Admin',
                      gender: 'Female',
                      userAge: 25,
                      isSuperAdmin: true,
                    ),
                  ),
                );
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

  void _proceedLogin(bool isFast) {
    int age = int.tryParse(_ageController.text.trim()) ?? 18;
    if (age < 18) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('You must be 18+ to register!')));
      return;
    }

    String finalName = isFast ? 'User_${Random().nextInt(899) + 100}' : _nameController.text.trim();
    if (finalName.isEmpty) finalName = 'User_${Random().nextInt(899) + 100}';

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainDashboard(
          userName: finalName,
          gender: _selectedGender,
          userAge: age,
          isSuperAdmin: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text('Create Your Profile', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text('Select gender carefully. Live streaming is verified.', style: TextStyle(color: Colors.white54, fontSize: 12)),
              ),
              const SizedBox(height: 28),

              // Name Field
              const Text('Display Name', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1B1926),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFFFF2E93)),
                ),
              ),
              const SizedBox(height: 18),

              // Age Field
              const Text('Age (Must be 18+)', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 6),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF1B1926),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  prefixIcon: const Icon(Icons.cake, color: Color(0xFFFF2E93)),
                ),
              ),
              const SizedBox(height: 22),

              // Gender Selection Row
              const Text('Select Gender', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedGender = 'Female'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedGender == 'Female' ? const Color(0xFFFF2E93) : const Color(0xFF1B1926),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _selectedGender == 'Female' ? Colors.white : Colors.white12),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.female, color: Colors.white, size: 28),
                            SizedBox(height: 4),
                            Text('Female (Can Stream)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _selectedGender = 'Male'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: _selectedGender == 'Male' ? Colors.blueAccent : const Color(0xFF1B1926),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: _selectedGender == 'Male' ? Colors.white : Colors.white12),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.male, color: Colors.white, size: 28),
                            SizedBox(height: 4),
                            Text('Male (Viewer Only)', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 34),

              // Submit Profile Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF2E93),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  ),
                  onPressed: () => _proceedLogin(false),
                  child: const Text('Confirm & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 12),

              // Fast Login Bypass
              Center(
                child: TextButton(
                  onPressed: () => _proceedLogin(true),
                  child: const Text('⚡ Fast Login with Default Settings', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 16),

              // Hidden Admin Link
              Center(
                child: GestureDetector(
                  onLongPress: () => _showSecretAdminPrompt(context),
                  child: const Text('Agree to User Agreement and Privacy Policy', style: TextStyle(color: Colors.white38, fontSize: 11)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 3. MAIN APP DASHBOARD
class MainDashboard extends StatefulWidget {
  final String userName;
  final String gender;
  final int userAge;
  final bool isSuperAdmin;

  const MainDashboard({
    super.key,
    required this.userName,
    required this.gender,
    required this.userAge,
    this.isSuperAdmin = false,
  });

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  late String userID;

  @override
  void initState() {
    super.initState();
    userID = 'user_${Random().nextInt(9000) + 1000}';
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      ForYouScreen(
        userID: userID,
        userName: widget.userName,
        gender: widget.gender,
        isSuperAdmin: widget.isSuperAdmin,
      ),
      FollowScreen(userID: userID, userName: widget.userName, isSuperAdmin: widget.isSuperAdmin),
      const Center(child: Text('Game Center Hub', style: TextStyle(color: Colors.white))),
      const Center(child: Text('Messages & Calls', style: TextStyle(color: Colors.white))),
      MeProfileScreen(
        userID: userID,
        userName: widget.userName,
        gender: widget.gender,
        userAge: widget.userAge,
        isSuperAdmin: widget.isSuperAdmin,
      ),
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

// 4. FOR YOU HOME (GO LIVE VISIBLE ONLY FOR FEMALE OR SUPER ADMIN)
class ForYouScreen extends StatelessWidget {
  final String userID;
  final String userName;
  final String gender;
  final bool isSuperAdmin;

  const ForYouScreen({
    super.key,
    required this.userID,
    required this.userName,
    required this.gender,
    required this.isSuperAdmin,
  });

  @override
  Widget build(BuildContext context) {
    // Only Female or Super Admin has host streaming rights!
    final bool canStream = isSuperAdmin || gender.toLowerCase() == 'female';

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

          // Stream button appears ONLY IF FEMALE OR ADMIN
          if (canStream)
            IconButton(
              icon: const Icon(Icons.videocam, color: Color(0xFFFF2E93), size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveStreamScreen(
                      roomID: 'stream_$userID',
                      isHost: true,
                      userID: userID,
                      userName: userName,
                      hostTitle: '$userName (Host)',
                      isSuperAdmin: isSuperAdmin,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: streamers.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          final s = streamers[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveStreamScreen(
                    roomID: s['id']!,
                    isHost: false, // Men & Viewers watch here
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

// 5. FOLLOW LIST
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
            title: const Text('Sexy Queen', style: TextStyle(color: Colors.w
