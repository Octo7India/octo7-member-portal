import 'package:flutter/material.dart';

void main() {
  runApp(const Octo7App());
}

class Octo7App extends StatelessWidget {
  const Octo7App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OCTO7 India',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F5127),
      ),
      home: const MainNavigationWrapper(),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Octo7WebsiteHomeScreen(),
    const BinaryTreeViewScreen(), // Integrated Binary Tree View!
    const Center(child: Text('Products Catalog', style: TextStyle(color: Colors.white, fontSize: 18))),
    const MemberDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF060D1A),
        selectedItemColor: const Color(0xFF10B981),
        unselectedItemColor: Colors.grey.shade400,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_tree_rounded), label: 'Tree'),
          BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded), label: 'Products'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Dashboard'),
        ],
      ),
    );
  }
}

// --- HOME SCREEN ---
class Octo7WebsiteHomeScreen extends StatelessWidget {
  const Octo7WebsiteHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F5127),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          backgroundColor: const Color(0xFF060D1A),
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🌎', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 4),
                    Text(
                      'OCTO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      '7',
                      style: TextStyle(
                        color: Color(0xFFD97706),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      ' India',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      _navText('Home'),
                      _navText('About Us'),
                      _navText('Products'),
                      _navText('Opportunity'),
                      _navText('Join Us'),
                      _navText('Contact'),
                      _navText('Member Login'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'WELCOME\nTO',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                height: 1.2,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('🌎', style: TextStyle(fontSize: 36)),
                Text(
                  'OCTO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  '7',
                  style: TextStyle(
                    color: Color(0xFFD97706),
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.blue.shade800, Colors.black87],
                ),
                border: Border.all(color: Colors.grey.shade400, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.public, size: 110, color: Colors.blueAccent),
                  Positioned(
                    right: 15,
                    bottom: 10,
                    child: Text(
                      '7',
                      style: TextStyle(
                        fontSize: 85,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFEAB308),
                        shadows: [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 35),
            const Text(
              'Discover a world of opportunities\nthrough quality products,\nentrepreneurship and a growing\nbusiness network.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.5,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 35),
            const Text(
              'Together For a Better Tomorrow.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  static Widget _navText(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// --- BINARY TREE NETWORK VIEW SCREEN ---
class BinaryTreeViewScreen extends StatelessWidget {
  const BinaryTreeViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Binary Network Tree', style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Volume Summary Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: const Color(0xFF060D1A),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _treeStat('Left Leg Volume', '12,400 BV', Colors.blue),
                Container(height: 25, width: 1, color: Colors.white24),
                _treeStat('Total Team', '38 Members', Colors.amber),
                Container(height: 25, width: 1, color: Colors.white24),
                _treeStat('Right Leg Volume', '15,800 BV', Colors.green),
              ],
            ),
          ),
          
          // Visual Tree Section
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // ROOT NODE (You)
                  _memberNode('You (Rajesh)', 'OCT7-89210', const Color(0xFFD97706), true),
                  _connectorVertical(),
                  
                  // LEVEL 1 CONNECTOR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 140, height: 2, color: Colors.white54),
                    ],
                  ),
                  
                  // LEVEL 1 NODES (Left & Right)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          _connectorVertical(),
                          _memberNode('Aarav S.', 'OCT7-91001', const Color(0xFF10B981), false),
                          _connectorVertical(),
                          Row(
                            children: [
                              Container(width: 70, height: 2, color: Colors.white54),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  _connectorVertical(),
                                  _memberNode('Priya M.', 'OCT7-92011', const Color(0xFF10B981), false),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Column(
                                children: [
                                  _connectorVertical(),
                                  _emptySlotNode(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          _connectorVertical(),
                          _memberNode('Suresh K.', 'OCT7-91002', const Color(0xFF10B981), false),
                          _connectorVertical(),
                          Row(
                            children: [
                              Container(width: 70, height: 2, color: Colors.white54),
                            ],
                          ),
                          Row(
                            children: [
                              Column(
                                children: [
                                  _connectorVertical(),
                                  _memberNode('Neha G.', 'OCT7-93040', const Color(0xFFF59E0B), false),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Column(
                                children: [
                                  _connectorVertical(),
                                  _emptySlotNode(),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _treeStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  static Widget _connectorVertical() {
    return Container(width: 2, height: 20, color: Colors.white54);
  }

  static Widget _memberNode(String name, String id, Color badgeColor, bool isRoot) {
    return Container(
      width: isRoot ? 130 : 100,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF060D1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: badgeColor, width: isRoot ? 2 : 1),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: isRoot ? 18 : 14,
            backgroundColor: badgeColor,
            child: Icon(Icons.person, size: isRoot ? 20 : 16, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(name, style: TextStyle(color: Colors.white, fontSize: isRoot ? 12 : 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
          Text(id, style: const TextStyle(color: Colors.grey, fontSize: 8)),
        ],
      ),
    );
  }

  static Widget _emptySlotNode() {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white30, style: BorderStyle.solid),
      ),
      child: Column(
        children: const [
          Icon(Icons.add_circle_outline, color: Colors.white54, size: 22),
          SizedBox(height: 4),
          Text('Add Member', style: TextStyle(color: Colors.white54, fontSize: 9)),
        ],
      ),
    );
  }
}

// --- MEMBER BACK-OFFICE & DASHBOARD SCREEN ---
class MemberDashboardScreen extends StatelessWidget {
  const MemberDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Member Back-Office', style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Color(0xFFD97706)),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF060D1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.shade700, width: 1),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF10B981),
                    child: Icon(Icons.person, size: 35, color: Colors.white),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Rajesh Kumar', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('ID: OCT7-89210', style: TextStyle(color: Colors.grey, fontSize: 13)),
                      SizedBox(height: 2),
                      Text('Rank: Gold Executive', style: TextStyle(color: Color(0xFFD97706), fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF064E3B), Color(0xFF022C22)]),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available E-Wallet Balance', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const SizedBox(height: 8),
                  const Text('₹ 45,850.00', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
                        onPressed: () {},
                        icon: const Icon(Icons.account_balance, size: 16, color: Colors.white),
                        label: const Text('Withdraw', style: TextStyle(color: Colors.white)),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54)),
                        onPressed: () {},
                        icon: const Icon(Icons.history, size: 16, color: Colors.white),
                        label: const Text('History', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: _metricCard('Left Team BV', '12,400', Icons.trending_up, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _metricCard('Right Team BV', '15,800', Icons.trending_up, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _metricCard('Direct Referrals', '14 Members', Icons.group, Colors.orange)),
                const SizedBox(width: 12),
                Expanded(child: _metricCard('Monthly Rank BV', '3,200 PV', Icons.star, Colors.amber)),
              ],
            ),
            const SizedBox(height: 25),
            const Text('Quick Distributor Actions', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: [
                _actionButton(Icons.person_add, 'Add Member', () {}),
                _actionButton(Icons.share, 'Referral Link', () {}),
                _actionButton(Icons.shopping_bag, 'Multi-Sector Shop', () {}),
                _actionButton(Icons.account_balance_wallet, 'Bank Details', () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _metricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF060D1A),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  static Widget _actionButton(IconData icon, String label, VoidCallback onPressed) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF060D1A),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.white24),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: const Color(0xFF10B981)),
      label: Text(label, style: const TextStyle(fontSize: 13)),
    );
  }
}
