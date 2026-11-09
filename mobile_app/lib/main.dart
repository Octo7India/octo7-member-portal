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
    const Center(child: Text('Binary Tree View', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Products Catalog', style: TextStyle(color: Colors.white))),
    const Center(child: Text('Member Profile', style: TextStyle(color: Colors.white))),
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
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

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
            // Corrected to spell OCTO directly with globe as O
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
