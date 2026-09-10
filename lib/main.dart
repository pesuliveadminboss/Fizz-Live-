import 'package:flutter/material.dart';

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
        scaffoldBackgroundColor: const Color(0xFF0F0C20),
        primaryColor: const Color(0xFFFF2A85),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreenContent(),
    FollowingListContent(),
    AudioPartyContent(),
    DailyRewardsAndVipTree(),
    ProfileAndWalletContent(),
    SuperBossAdminAnalytics(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentIndex],
          Positioned(
            bottom: 90,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.amber.shade700,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 4)],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.ads_click, size: 16, color: Colors.black),
                  SizedBox(width: 4),
                  Text("Sponsored Ad", style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF191433),
        selectedItemColor: const Color(0xFFFF2A85),
        unselectedItemColor: Colors.white54,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Live/Active'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Following'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Party Audio'),
          BottomNavigationBarItem(icon: Icon(Icons.military_tech), label: 'VIP Tree'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Boss Panel'),
        ],
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Fizz Live", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFFF2A85))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.purple.shade900, borderRadius: BorderRadius.circular(15)),
                child: const Row(
                  children: [
                    Icon(Icons.diamond, color: Colors.cyanAccent, size: 16),
                    SizedBox(width: 4),
                    Text("8,100 Gems", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text("Live Streamers (Worldwide)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pinkAccent),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(radius: 30, backgroundColor: Colors.pink, child: Icon(Icons.person, color: Colors.white)),
                      const SizedBox(height: 6),
                      Text("Streamer ${index + 1}", style: const TextStyle(fontSize: 12)),
                      const Text("1800 gems/m", style: TextStyle(fontSize: 10, color: Colors.cyanAccent)),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          const Text("Active Online Users", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(radius: 35, backgroundColor: Colors.deepPurple, child: Icon(Icons.person, size: 40)),
                    const SizedBox(height: 8),
                    Text("User ${index + 101}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF2A85)),
                      onPressed: () {},
                      icon: const Icon(Icons.videocam, size: 16),
                      label: const Text("Call 1800g"),
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

class FollowingListContent extends StatelessWidget {
  const FollowingListContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        separatorBuilder: (_, __) => const Divider(color: Colors.white24),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const CircleAvatar(backgroundColor: Colors.pinkAccent, child: Icon(Icons.person)),
            title: Text("Followed Host ${index + 1}"),
            subtitle: Text(index == 0 ? "Status: Busy (Waiting...)" : "Status: Free to Call",
                style: TextStyle(color: index == 0 ? Colors.orangeAccent : Colors.greenAccent)),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: index == 0 ? Colors.grey : Colors.pink),
              onPressed: index == 0 ? null : () {},
              child: const Text("Connect"),
            ),
          );
        },
      ),
    );
  }
}

class AudioPartyContent extends StatelessWidget {
  const AudioPartyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Audio Party Room (No Payment)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: List.generate(5, (index) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.indigo.shade700,
                      child: const Icon(Icons.mic, size: 30, color: Colors.white),
                    ),
                    const SizedBox(height: 6),
                    Text("Seat ${index + 1}", style: const TextStyle(fontSize: 12)),
                  ],
                );
              }),
            ),
            const Spacer(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(45),
              ),
              onPressed: () {},
              icon: const Icon(Icons.mic_none),
              label: const Text("Join Seat (Free for all)"),
            )
          ],
        ),
      ),
    );
  }
}

class DailyRewardsAndVipTree extends StatelessWidget {
  const DailyRewardsAndVipTree({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("7-Day Login Calendar", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _rewardBadge("D1: 40g"),
                _rewardBadge("D2: Free Call"),
                _rewardBadge("D3: 60g"),
                _rewardBadge("D4: 80g"),
                _rewardBadge("D5: 100g"),
                _rewardBadge("D6: 120g"),
                _rewardBadge("D7: Free Call+150g"),
              ],
            ),
          ),
          const SizedBox(height: 25),
          const Text("VIP Battle Tree Rewards", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Card(
            color: const Color(0xFF231A47),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("₹199 Plan (28 Days)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                  const Text("Instant: 4,100 Gems + 5 Free 30s Cards"),
                  const Divider(color: Colors.white24),
                  const Text("₹299 Plan (30 Days)", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                  const Text("Instant: 8,200 Gems + 10 Free 30s Cards"),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber.shade700),
                    onPressed: () {},
                    child: const Text("Purchase VIP Plan", style: TextStyle(color: Colors.black)),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget _rewardBadge(String title) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(8)),
      child: Text(title, style: const TextStyle(fontSize: 11)),
    );
  }
}

class ProfileAndWalletContent extends StatelessWidget {
  const ProfileAndWalletContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(radius: 40, backgroundColor: Colors.pink, child: Icon(Icons.person, size: 50)),
          ),
          const SizedBox(height: 10),
          const Center(child: Text("Fizz User", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const SizedBox(height: 20),
          ListTile(
            tileColor: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: const Icon(Icons.account_balance_wallet, color: Colors.cyanAccent),
            title: const Text("Recharge Gems Grid"),
            subtitle: const Text("Base rate: ₹100 = 8,100 Gems"),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const SizedBox(height: 10),
          ListTile(
            tileColor: Colors.white10,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: const Icon(Icons.support_agent, color: Colors.greenAccent),
            title: const Text("Chat With Us (Support)"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class SuperBossAdminAnalytics extends StatelessWidget {
  const SuperBossAdminAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Super Boss Control & Analytics", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          const SizedBox(height: 15),
          _cardRow("Row 6: App Total Statistics", "Active Users: 1,420\nTop Revenue Source: 1-on-1 Video Calls\nTotal Streams Running: 18"),
          const SizedBox(height: 10),
          _cardRow("Row 7: Top 3 Leaderboard", "1. Streamer Maya - ₹24,000 Generated\n2. Streamer Priya - ₹18,500 Generated\n3. Streamer Ananya - ₹12,000 Generated"),
          const SizedBox(height: 10),
          _cardRow("Row 8: Admin Virtual Salary Vault", "Today Net Income: ₹8,450\nAccumulated Vault: ₹65,200\nWithdrawal Charge: Flat ₹3 (IMPS)"),
          const SizedBox(height: 15),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            onPressed: () {},
            icon: const Icon(Icons.visibility_off),
            label: const Text("Enter Anonymous Ghost Mode (Free)"),
          ),
        ],
      ),
    );
  }

  static Widget _cardRow(String title, String content) {
    return Card(
      color: const Color(0xFF1E163B),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent)),
            const SizedBox(height: 6),
            Text(content, style: const TextStyle(fontSize: 13, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
