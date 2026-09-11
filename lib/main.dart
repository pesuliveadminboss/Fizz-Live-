import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0F0E17),
        primaryColor: const Color(0xFFFF2A6D),
      ),
      home: const HomeScreen(),
    );
  }
}

// --- Wallet & Coin Controller ---
class WalletController {
  static const String _coinKey = "user_fizz_coins";

  static Future<int> getCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_coinKey) ?? 100;
  }

  static Future<int> addCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = await getCoins();
    int updated = current + amount;
    await prefs.setInt(_coinKey, updated);
    return updated;
  }

  static Future<bool> deductCoins(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    int current = await getCoins();
    if (current >= amount) {
      await prefs.setInt(_coinKey, current - amount);
      return true;
    }
    return false;
  }
}

// --- Gift Item Model ---
class GiftItem {
  final String name;
  final String icon;
  final int cost;
  GiftItem({required this.name, required this.icon, required this.cost});
}

final List<GiftItem> appGifts = [
  GiftItem(name: "Rose", icon: "🌹", cost: 10),
  GiftItem(name: "Heart", icon: "💖", cost: 50),
  GiftItem(name: "Diamond", icon: "💎", cost: 100),
  GiftItem(name: "Sports Car", icon: "🏎️", cost: 500),
  GiftItem(name: "Rocket", icon: "🚀", cost: 1000),
  GiftItem(name: "Crown", icon: "👑", cost: 2000),
];

// --- Home Screen ---
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _roomController = TextEditingController(text: "1111");
  final TextEditingController _userController = TextEditingController(text: "User_${DateTime.now().millisecond}");
  int _coins = 100;

  @override
  void initState() {
    super.initState();
    _refreshBalance();
  }

  void _refreshBalance() async {
    int balance = await WalletController.getCoins();
    setState(() {
      _coins = balance;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF161622),
        title: const Text("Fizz Live 🔥", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          InkWell(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WalletScreen()),
              );
              _refreshBalance();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF222232),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.amber.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  const Text("🪙 ", style: TextStyle(fontSize: 16)),
                  Text(
                    "$_coins",
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.add_circle, color: Color(0xFFFF2A6D), size: 18),
                ],
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _userController,
              decoration: InputDecoration(
                labelText: "Your Nickname",
                filled: true,
                fillColor: const Color(0xFF161622),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _roomController,
              decoration: InputDecoration(
                labelText: "Room ID to Join / Host",
                filled: true,
                fillColor: const Color(0xFF161622),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.video_call),
                    label: const Text("Go Live (Host)"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF2A6D),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LivePage(
                            roomID: _roomController.text.trim(),
                            userName: _userController.text.trim(),
                            isHost: true,
                          ),
                        ),
                      ).then((_) => _refreshBalance());
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.visibility),
                    label: const Text("Watch Live"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF05D9E8),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LivePage(
                            roomID: _roomController.text.trim(),
                            userName: _userController.text.trim(),
                            isHost: false,
                          ),
                        ),
                      ).then((_) => _refreshBalance());
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// --- Live Streaming Page with Gift Drawer ---
class LivePage extends StatelessWidget {
  final String roomID;
  final String userName;
  final bool isHost;

  const LivePage({
    super.key,
    required this.roomID,
    required this.userName,
    required this.isHost,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          ZegoUIKitPrebuiltLiveStreaming(
            appID: 1478144211,
            appSign: "b9c3f9152b11e2f738b556b63d6f1df12e0fa5ae7ba4dbe059f81d89b141eaef",
            userID: userName,
            userName: userName,
            liveID: roomID,
            config: isHost
                ? ZegoUIKitPrebuiltLiveStreamingConfig.host()
                : ZegoUIKitPrebuiltLiveStreamingConfig.audience(),
          ),
          if (!isHost)
            Positioned(
              bottom: 60,
              right: 20,
              child: FloatingActionButton(
                backgroundColor: const Color(0xFFFF2A6D),
                onPressed: () => _openGifts(context),
                child: const Text("🎁", style: TextStyle(fontSize: 26)),
              ),
            ),
        ],
      ),
    );
  }

  void _openGifts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161622),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return FutureBuilder<int>(
              future: WalletController.getCoins(),
              builder: (context, snapshot) {
                int coins = snapshot.data ?? 0;
                return Container(
                  padding: const EdgeInsets.all(16),
                  height: 360,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("🪙 Balance: $coins Coins",
                              style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16)),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
                            },
                            child: const Text("+ Recharge", style: TextStyle(color: Color(0xFFFF2A6D))),
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white24),
                      Expanded(
                        child: GridView.builder(
                          itemCount: appGifts.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemBuilder: (c, idx) {
                            final g = appGifts[idx];
                            return InkWell(
                              onTap: () async {
                                bool ok = await WalletController.deductCoins(g.cost);
                                if (ok) {
                                  Navigator.pop(ctx);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Sent ${g.name} ${g.icon} to Streamer! 🎉")),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Not enough coins! Please recharge.")),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF222232),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(g.icon, style: const TextStyle(fontSize: 32)),
                                    const SizedBox(height: 4),
                                    Text(g.name, style: const TextStyle(color: Colors.white, fontSize: 12)),
                                    Text("🪙 ${g.cost}", style: const TextStyle(color: Colors.amber, fontSize: 11)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// --- Wallet Recharge Screen ---
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _balance = 0;

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    int b = await WalletController.getCoins();
    setState(() => _balance = b);
  }

  @override
  Widget build(BuildContext context) {
    final packs = [
      {"coins": 100, "price": "₹49"},
      {"coins": 500, "price": "₹199"},
      {"coins": 1200, "price": "₹449"},
      {"coins": 3000, "price": "₹999"},
      {"coins": 7500, "price": "₹2199"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Coin Wallet"),
        backgroundColor: const Color(0xFF161622),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFF2A6D), Color(0xFF9114FF)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Current Balance", style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 6),
                  Text("🪙 $_balance Coins",
                      style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: packs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) {
                  final p = packs[i];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B1B28),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("🪙 ${p['coins']} Coins",
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2A6D)),
                          onPressed: () async {
                            await WalletController.addCoins(p['coins'] as int);
                            _fetch();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Recharged ${p['coins']} Coins! 🎉")),
                            );
                          },
                          child: Text(p['price'] as String, style: const TextStyle(color: Colors.white)),
                        )
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
