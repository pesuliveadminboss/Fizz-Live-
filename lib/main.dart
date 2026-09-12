import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';

void main() async {
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
        scaffoldBackgroundColor: const Color(0xFF09080F),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF09080F),
          elevation: 0,
        ),
      ),
      home: const AgeVerificationGate(),
    );
  }
}

// -------------------------------------------------------------
// 1. FREE 18+ AGE VERIFICATION GATE
// -------------------------------------------------------------
class AgeVerificationGate extends StatefulWidget {
  const AgeVerificationGate({super.key});

  @override
  State<AgeVerificationGate> createState() => _AgeVerificationGateState();
}

class _AgeVerificationGateState extends State<AgeVerificationGate> {
  @override
  void initState() {
    super.initState();
    _checkAgeGate();
  }

  void _checkAgeGate() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isVerified = prefs.getBool('age_verified_18') ?? false;
    if (isVerified) {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FastLoginScreen()),
    );
  }

  void _confirmAge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('age_verified_18', true);
    _goToLogin();
  }

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
                    child: const Text("18+", style: TextStyle(color: Color(0xFFFF2E93), fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 18),
                  const Text("Age Verification Required", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text(
                    "Fizz Live contains live streaming, video chat and entertainment intended strictly for adults.\n\nYou must be 18 years or older to enter.",
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
                      onPressed: _confirmAge,
                      child: const Text("I Am 18 or Older - Enter", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white)),
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

// -------------------------------------------------------------
// 2. FAST LOGIN & SECRET ADMIN SWITCH
// -------------------------------------------------------------
class FastLoginScreen extends StatelessWidget {
  const FastLoginScreen({super.key});

  void _showSecretAdminPrompt(BuildContext context) {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F1D2B),
        title: const Text("Super Admin Verification", style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: "Enter 4-Digit Master PIN",
            labelStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.pinkAccent), borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.purpleAccent), borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel", style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2E93)),
            onPressed: () {
              Navigator.pop(context);
              if (pinController.text.trim() == "7777") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const MainDashboard(isSuperAdmin: true)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Invalid PIN!")),
                );
              }
            },
            child: const Text("Activate Admin Mode"),
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
            Positioned(top: 80, left: 40, child: _bubble(75, Colors.pinkAccent)),
            Positioned(top: 60, right: 50, child: _bubble(65, Colors.purpleAccent)),
            Positioned(top: 180, left: 130, child: _bubble(85, Colors.amber)),
            Positioned(top: 220, right: 30, child: _bubble(75, Colors.cyanAccent)),
            Positioned(top: 320, left: 50, child: _bubble(80, Colors.deepOrange)),
            Positioned(top: 340, right: 120, child: _bubble(60, Colors.greenAccent)),

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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF2E93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const MainDashboard(isSuperAdmin: false)),
                          );
                        },
                        child: const Text("Fast Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text("Already a member? Login", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onLongPress: () => _showSecretAdminPrompt(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.check_circle, color: Color(0xFFFF2E93), size: 14),
                          SizedBox(width: 6),
                          Text("Agree to User Agreement and Privacy Policy", style: TextStyle(color: Colors.white38, fontSize: 11)),
                        ],
                      ),
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

  Widget _bubble(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.8), width: 2),
        color: const Color(0xFF1E1B2E),
      ),
      child: const Icon(Icons.person, color: Colors.white54, size: 36),
    );
  }
}

// -------------------------------------------------------------
// 3. MAIN DASHBOARD (5 BOTTOM TABS + ADMIN MODE)
// -------------------------------------------------------------
class MainDashboard extends StatefulWidget {
  final bool isSuperAdmin;
  const MainDashboard({super.key, this.isSuperAdmin = false});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;
  final String userID = "user_${Random().nextInt(9000) + 1000}";
  final String userName = "User_${Random().nextInt(900) + 100}";

  @override
  Widget build(BuildContext context) {
    final screens = [
      ForYouHomeScreen(userID: userID, userName: userName, isSuperAdmin: widget.isSuperAdmin),
      FollowGirlsScreen(userID: userID, userName: userName, isSuperAdmin: widget.isSuperAdmin),
      const GameDashboardScreen(),
      const MessagesListScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.thumb_up_alt_outlined), label: "For You"),
          BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: "Follow"),
          BottomNavigationBarItem(icon: Icon(Icons.sports_esports_outlined), label: "Game"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Messages"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Me"),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 4. FOR YOU (HOT / LIVE / PARTY / MATCH)
// -------------------------------------------------------------
class ForYouHomeScreen extends StatefulWidget {
  final String userID;
  final String userName;
  final bool isSuperAdmin;

  const ForYouHomeScreen({super.key, required this.userID, required this.userName, required this.isSuperAdmin});

  @override
  State<ForYouHomeScreen> createState() => _ForYouHomeScreenState();
}

class _ForYouHomeScreenState extends State<ForYouHomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          indicatorColor: const Color(0xFFFF2E93),
          tabs: const [
            Tab(text: "Hot"),
            Tab(text: "Live"),
            Tab(text: "Party"),
            Tab(text: "Match"),
          ],
        ),
        actions: [
          if (widget.isSuperAdmin)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(10)),
              child: const Text("SUPER ADMIN", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHotGrid(),
          _buildHotGrid(),
          PartyRoomScreen(userID: widget.userID, userName: widget.userName, isSuperAdmin: widget.isSuperAdmin),
          MatchScreen(userID: widget.userID, userName: widget.userName, isSuperAdmin: widget.isSuperAdmin),
        ],
      ),
    );
  }

  Widget _buildHotGrid() {
    final list = [
      {"name": "وردة", "id": "1001", "status": "Online", "tag": "Exotic"},
      {"name": "ROPA", "id": "1002", "status": "Online", "tag": ""},
      {"name": "Anushka", "id": "1003", "status": "Live", "tag": "Your Follow"},
      {"name": "nilu roy", "id": "1004", "status": "Live", "tag": ""},
      {"name": "Extra Gems", "id": "1005", "status": "Online", "tag": "Special"},
      {"name": "Sanya Glow", "id": "1006", "status": "Online", "tag": "Exotic"},
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveStreamView(
                  roomID: item["id"]!,
                  isHost: false,
                  userID: widget.userID,
                  userName: widget.userName,
                  hostTitle: item["name"]!,
                  isSuperAdmin: widget.isSuperAdmin,
                ),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Stack(
              children: [
                Center(child: Icon(Icons.person, size: 70, color: Colors.white.withOpacity(0.12))),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: item["status"] == "Live" ? const Color(0xFF7928CA) : Colors.green[700],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(item["status"]!, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item["name"]!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Color(0xFFFF2E93), shape: BoxShape.circle),
                        child: const Icon(Icons.videocam, color: Colors.white, size: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// -------------------------------------------------------------
// 5. FOLLOW SCREEN
// -------------------------------------------------------------
class FollowGirlsScreen extends StatelessWidget {
  final String userID;
  final String userName;
  final bool isSuperAdmin;

  const FollowGirlsScreen({super.key, required this.userID, required this.userName, required this.isSuperAdmin});

  @override
  Widget build(BuildContext context) {
    final girls = [
      {"name": "Sexy White Girl", "status": "Live", "id": "2001"},
      {"name": "Nisha Roy", "status": "Live", "id": "2002"},
      {"name": "Sexy Queen", "status": "Live", "id": "2003"},
      {"name": "Roshni", "status": "Busy", "id": "2004"},
      {"name": "Cherry Blossom", "status": "Active", "id": "2005"},
      {"name": "Tanisha", "status": "Active", "id": "2006"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Text("Follow Girls", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(width: 16),
            Text("Follow Room", style: TextStyle(color: Colors.white54, fontSize: 14)),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: girls.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) {
          final g = girls[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveStreamView(
                    roomID: g["id"]!,
                    isHost: false,
                    userID: userID,
                    userName: userName,
                    hostTitle: g["name"]!,
                    isSuperAdmin: isSuperAdmin,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(color: const Color(0xFF1E1B2E), borderRadius: BorderRadius.circular(10)),
              child: Center(
                child: Text(g["name"]!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}

// -------------------------------------------------------------
// 6. GAME DASHBOARD
// -------------------------------------------------------------
class GameDashboardScreen extends StatelessWidget {
  const GameDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Game Center")),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
     
