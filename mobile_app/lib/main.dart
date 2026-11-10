import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'services/auth_service.dart';
import 'services/wallet_service.dart';
import 'services/live_data_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase is initialized only when public project configuration is
  // supplied at build time. No service-role key belongs in this app.
  if (SupabaseConfig.isSecurelyConfigured) {
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
    );
  }

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
      home: const AuthGate(),
    );
  }
}

/// Validates the OCTO7 server session before showing member screens.
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});
  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late Future<bool> _sessionCheck;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _sessionCheck = AuthService.instance.validateSession();
  }

  void _onLogin() => setState(() => _loggedIn = true);

  @override
  Widget build(BuildContext context) {
    if (!SupabaseConfig.isSecurelyConfigured) {
      final message = SupabaseConfig.isConfigured
          ? 'OCTO7 connection rejected. The Supabase URL must use HTTPS. Rebuild with a valid HTTPS project URL.'
          : 'OCTO7 connection is not configured. Build with the Supabase project URL and public anon key.';
      return Scaffold(
        backgroundColor: Color(0xFF052411),
        body: Center(child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(message,
            textAlign: TextAlign.center, style: const TextStyle(color: Colors.white)),
        )),
      );
    }
    if (_loggedIn) return const MainNavigationWrapper(initialIndex: 3);
    return FutureBuilder<bool>(
      future: _sessionCheck,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(backgroundColor: Color(0xFF052411),
            body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: const Color(0xFF052411),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Unable to verify your OCTO7 session. Check your internet connection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => setState(() {
                        _sessionCheck = AuthService.instance.validateSession();
                      }),
                      child: const Text('RETRY'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (snapshot.data == true) return const MainNavigationWrapper(initialIndex: 3);
        return const WelcomeScreen();
      },
    );
  }
}

/// Public landing screen shown when no valid OCTO7 session exists.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF071426);
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('OCTO7 INDIA', style: TextStyle(color: Colors.white, letterSpacing: 1.2)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF060D1A),
        child: SafeArea(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const DrawerHeader(decoration: BoxDecoration(color: Color(0xFF0F5127)), child: Align(alignment: Alignment.centerLeft, child: Text('OCTO7 INDIA\\nVISITOR MENU', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.5)))),
          Octo7WebsiteHomeScreen._publicMenuItem(context, Icons.home, 'Home', 'Home'),
          Octo7WebsiteHomeScreen._publicMenuItem(context, Icons.info_outline, 'About Us', 'About Us'),
          Octo7WebsiteHomeScreen._publicMenuItem(context, Icons.grid_view, 'Our Products', 'Our Products'),
          Octo7WebsiteHomeScreen._publicMenuItem(context, Icons.business_center_outlined, 'Business Opportunity', 'Business Opportunity'),
          Octo7WebsiteHomeScreen._publicMenuItem(context, Icons.account_balance_outlined, 'Business Plan', 'Business Plan'),
          Octo7WebsiteHomeScreen._publicMenuItem(context, Icons.contact_mail_outlined, 'Contact Us', 'Contact Us'),
        ])),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF123C56), Color(0xFF071426), Color(0xFF052411)],
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 16),
                      const SizedBox(height: 20),
                      const Text('OCTO7',
                        style: TextStyle(color: Colors.white, fontSize: 42,
                          fontWeight: FontWeight.w800, letterSpacing: 4)),
                      const SizedBox(height: 8),
                      const Text('Together For a Better Tomorrow',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Color(0xFFE5D6B8), fontSize: 16,
                          fontStyle: FontStyle.italic, letterSpacing: 0.4)),
                      const SizedBox(height: 42),
                      SizedBox(width: double.infinity, height: 56,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFF4D27A), Color(0xFFB7791F)]),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [BoxShadow(color: Color(0x66D6A84B), blurRadius: 18, offset: Offset(0, 6))],
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(
                              builder: (_) => MemberLoginScreen(onLogin: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(builder: (_) => const MainNavigationWrapper(initialIndex: 3)),
                                  (route) => false,
                                );
                              }),
                            )),
                            icon: const Icon(Icons.person_outline),
                            label: const Text('Member Login', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                              foregroundColor: navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 42),
                      const Text(
                        'Discover a world of opportunities through quality products, entrepreneurship and a growing business network.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFE5D6B8),
                          fontSize: 14,
                          height: 1.5,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Dream • Network • Grow',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFD6A84B),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MemberLoginScreen extends StatefulWidget {
  const MemberLoginScreen({super.key, required this.onLogin});
  final VoidCallback onLogin;
  @override
  State<MemberLoginScreen> createState() => _MemberLoginScreenState();
}

class _MemberLoginScreenState extends State<MemberLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _busy = false;
  bool _hidePassword = true;
  String? _error;

  String get _identifierLabel => 'OCTO7 User ID';

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate() || _busy) return;
    setState(() { _busy = true; _error = null; });
    try {
      await AuthService.instance.signIn(
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
      if (mounted) widget.onLogin();
    } catch (error) {
      if (mounted) setState(() => _error = error.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      body: Center(child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            color: const Color(0xFF060D1A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18),
              side: const BorderSide(color: Color(0xFFD97706))),
            child: Padding(padding: const EdgeInsets.all(24),
              child: Form(key: _formKey, child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('OCTO7 INDIA', style: TextStyle(color: Colors.white, fontSize: 25,
                  fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                const SizedBox(height: 8),
                const Text('MEMBER LOGIN', style: TextStyle(color: Color(0xFFD97706),
                  fontWeight: FontWeight.w600)),
                const SizedBox(height: 22),
                TextFormField(
                  controller: _identifierController,
                  keyboardType: TextInputType.text,
                  autocorrect: false,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: _identifierLabel,
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.badge_outlined, color: Color(0xFF10B981)),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF10B981)))),
                  validator: (value) {
                    final v = value?.trim() ?? '';
                    if (v.isEmpty) return 'Enter your ${_identifierLabel.toLowerCase()}';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController, obscureText: _hidePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF10B981)),
                    suffixIcon: IconButton(onPressed: () => setState(() => _hidePassword = !_hidePassword),
                      icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white54)),
                    enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                    focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF10B981)))),
                  validator: (value) => value == null || value.isEmpty ? 'Enter your password' : null,
                  onFieldSubmitted: (_) => _login(),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 14),
                  Text(_error!, textAlign: TextAlign.center, style: const TextStyle(color: Colors.redAccent)),
                ],
                const SizedBox(height: 24),
                SizedBox(width: double.infinity, height: 48,
                  child: ElevatedButton(
                    onPressed: _busy ? null : _login,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706),
                      foregroundColor: Colors.white),
                    child: _busy ? const SizedBox(width: 22, height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) :
                      const Text('MEMBER LOGIN', style: TextStyle(fontWeight: FontWeight.bold)),
                  )),
                const SizedBox(height: 14),
                const Text('Log in using your OCTO7 User ID and password.',
                  textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 12)),
              ])),
            ),
          ),
        ),
      )),
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 3);
  }

  final List<Widget> _pages = [
    const Octo7WebsiteHomeScreen(),
    const BinaryTreeViewScreen(),
    const ProductCatalogScreen(),
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
      drawer: Drawer(
        backgroundColor: const Color(0xFF060D1A),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF0F5127)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OCTO7 INDIA', style: TextStyle(
                      color: Colors.white, fontSize: 22,
                      fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                    SizedBox(height: 6),
                    Text('Together For a Better Tomorrow.',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              _memberDrawerItem(context, Icons.home_filled, 'Home', 0),
              _memberDrawerItem(context, Icons.dashboard, 'Dashboard', 3),
              _memberDrawerItem(context, Icons.person_outline, 'My Profile', 3),
              _memberDrawerItem(context, Icons.account_tree, 'My Genealogy', 1),
              _memberDrawerItem(context, Icons.person_add_alt, 'New Member Registration', 4),
              _memberDrawerItem(context, Icons.grid_view, 'Products', 2),
              _memberDrawerItem(context, Icons.shopping_bag_outlined, 'My Orders', 5),
              _memberDrawerItem(context, Icons.account_balance_wallet_outlined, 'My Wallet', 6),
              _memberDrawerItem(context, Icons.account_balance, 'Bank Details', 7),
              _memberDrawerItem(context, Icons.verified_user_outlined, 'KYC Verification', 8),
              _memberDrawerItem(context, Icons.payments_outlined, 'Withdrawals', 9),
              _memberDrawerItem(context, Icons.confirmation_number_outlined, 'My Coupons', 10),
              _memberDrawerItem(context, Icons.lock_outline, 'Change Password', 11),
              _memberDrawerItem(context, Icons.support_agent, 'Help Line', 12),
              _memberDrawerItem(context, Icons.report_outlined, 'Report', 13),
              const Spacer(),
              const Divider(color: Colors.white24),
              _memberDrawerItem(context, Icons.logout, 'Logout', 14),
            ],
          ),
        ),
      ),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: AppBar(
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (context) => IconButton(
              tooltip: 'Open menu',
              icon: const Icon(Icons.menu, color: Colors.white, size: 28),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
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

  static Widget _drawerItem(
      BuildContext context, IconData icon, String title, String? destination) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF10B981)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        if (destination == null) return;
        Widget? page;
        switch (destination) {
          case 'Products':
            page = const ProductCatalogScreen();
            break;
          case 'Dashboard':
            page = const MemberDashboardScreen();
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$title page is not available in this app build yet.')),
            );
            return;
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
      },
    );
  }

  static Widget _publicMenuItem(BuildContext context, IconData icon, String title, String page) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFD6A84B)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: () {
        Navigator.pop(context);
        if (page == 'Home') return;
        Navigator.push(context, MaterialPageRoute(builder: (_) => PublicInfoScreen(title: title)));
      },
    );
  }

  static Widget _memberDrawerItem(BuildContext context, IconData icon, String title, int destination) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF10B981)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      onTap: () {
        Navigator.pop(context);
        if (destination == 14) {
          AuthService.instance.signOut().then((_) {
            if (context.mounted) Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthGate()), (route) => false);
          });
          return;
        }
        Widget? page;
        switch (destination) {
          case 4: page = const MemberRegistrationScreen(); break;
          case 5: page = const MemberMenuInfoScreen(title: 'My Orders'); break;
          case 6: page = const TransactionHistoryScreen(); break;
          case 7: page = const MemberMenuInfoScreen(title: 'Bank Details'); break;
          case 8: page = const MemberMenuInfoScreen(title: 'KYC Verification'); break;
          case 9: page = const MemberMenuInfoScreen(title: 'Withdrawals'); break;
          case 10: page = const MemberMenuInfoScreen(title: 'My Coupons'); break;
          case 11: page = const MemberMenuInfoScreen(title: 'Change Password'); break;
          case 12: page = const MemberMenuInfoScreen(title: 'Help Line'); break;
          case 13: page = const MemberMenuInfoScreen(title: 'Report'); break;
          default: break;
        }
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
        } else {
          // Home, dashboard, genealogy and products are available in the bottom navigation.
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$title is available from the bottom navigation or dashboard.')));
        }
      },
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

class PublicInfoScreen extends StatelessWidget {
  const PublicInfoScreen({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final descriptions = <String, String>{
      'About Us': 'Learn about OCTO7 India, our purpose and our commitment to building a product-focused business community.',
      'Our Products': 'Explore OCTO7 product categories, including garments, imitation ornaments, home care, personal care, health and wellness, nutrition, spices, and food and beverages. Product listings are being connected to the live catalogue.',
      'Business Opportunity': 'Understand how to get started with OCTO7, learn about the product range, and connect with the team for guidance. Participation is subject to the company’s official terms and policies.',
      'Business Plan': 'The plan includes binary placement and matching. For the first successful match only, either Left 2,000 BV + Right 1,000 BV or Left 1,000 BV + Right 2,000 BV qualifies one 1,000 BV match; the extra 1,000 BV on the stronger side carries forward. Subsequent matching is 1:1. Matching income is capped at ₹5,000 per day per ID. Other bonus and eligibility details should be confirmed from the official approved plan.',
      'Contact Us': 'For assistance or business enquiries, please contact the OCTO7 India team through the official contact channels provided by the company.',
    };
    return Scaffold(
      backgroundColor: const Color(0xFF071426),
      appBar: AppBar(backgroundColor: const Color(0xFF060D1A), title: Text(title), iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Text(descriptions[title] ?? title, style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.7), textAlign: TextAlign.left))),
    );
  }
}

class MemberMenuInfoScreen extends StatelessWidget {
  const MemberMenuInfoScreen({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF071426),
    appBar: AppBar(backgroundColor: const Color(0xFF060D1A), title: Text(title), iconTheme: const IconThemeData(color: Colors.white)),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('$title is listed in the member menu, but its secure backend workflow is not connected yet. No account data or transactions have been changed.', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.6)))),
  );
}

// --- BINARY TREE NETWORK VIEW SCREEN ---
class BinaryTreeViewScreen extends StatefulWidget {
  const BinaryTreeViewScreen({super.key});

  @override
  State<BinaryTreeViewScreen> createState() => _BinaryTreeViewScreenState();
}

class _BinaryTreeViewScreenState extends State<BinaryTreeViewScreen> {
  late Future<Map<String, dynamic>> _genealogyFuture;
  String? _rootMemberId;
  final List<String> _backStack = [];

  @override
  void initState() {
    super.initState();
    _genealogyFuture = LiveDataService.instance.fetchGenealogy();
  }

  Future<void> _openMember(String memberId) async {
    if (memberId.isEmpty || memberId == _rootMemberId) return;
    setState(() {
      if (_rootMemberId != null) _backStack.add(_rootMemberId!);
      _rootMemberId = memberId;
      _genealogyFuture = LiveDataService.instance.fetchGenealogy(rootMemberId: memberId);
    });
  }

  void _goBack() {
    if (_backStack.isEmpty) return;
    final previous = _backStack.removeLast();
    setState(() {
      _rootMemberId = previous;
      _genealogyFuture = LiveDataService.instance.fetchGenealogy(rootMemberId: previous);
    });
  }

  Widget _nodeCard(Map<String, dynamic> node, {bool root = false}) {
    final memberId = (node['member_id'] ?? '').toString();
    final name = (node['full_name'] ?? node['name'] ?? '').toString();
    final status = (node['status'] ?? 'Unavailable').toString();
    return InkWell(
      onTap: memberId.isEmpty ? null : () => _openMember(memberId),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        constraints: const BoxConstraints(minWidth: 130, maxWidth: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF060D1A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: root ? const Color(0xFFD97706) : Colors.white24),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('OCTO7', style: TextStyle(color: Color(0xFFD97706), fontSize: 10, fontWeight: FontWeight.bold)),
          Text(memberId.isEmpty ? 'ID unavailable' : memberId,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          if (name.isNotEmpty) Text(name, textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 11)),
          Text(status.toUpperCase(), style: const TextStyle(color: Color(0xFF10B981), fontSize: 10)),
          if (memberId.isNotEmpty) const Text('Tap to view downline',
            style: TextStyle(color: Colors.white38, fontSize: 9)),
        ]),
      ),
    );
  }

  Widget _tree(Map<String, dynamic> node, {bool root = false}) {
    final left = node['left'];
    final right = node['right'];
    return Column(mainAxisSize: MainAxisSize.min, children: [
      _nodeCard(node, root: root),
      const SizedBox(height: 16),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Column(children: [
          const Text('LEFT', style: TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 6),
          if (left is Map) _nodeCard(Map<String, dynamic>.from(left))
          else const Text('Position available', textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 10)),
        ])),
        const SizedBox(width: 12),
        Expanded(child: Column(children: [
          const Text('RIGHT', style: TextStyle(color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 6),
          if (right is Map) _nodeCard(Map<String, dynamic>.from(right))
          else const Text('Position available', textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white38, fontSize: 10)),
        ])),
      ]),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Binary Network Tree', style: TextStyle(color: Colors.white, fontSize: 18)),
        leading: _backStack.isEmpty ? null : IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: _goBack),
        actions: [IconButton(
          icon: const Icon(Icons.refresh, color: Colors.white),
          onPressed: () => setState(() {
            _genealogyFuture = LiveDataService.instance.fetchGenealogy(rootMemberId: _rootMemberId);
          }))],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _genealogyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Unable to load live genealogy: ${snapshot.error}',
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.orangeAccent)),
                TextButton(onPressed: () => setState(() {
                  _genealogyFuture = LiveDataService.instance.fetchGenealogy(rootMemberId: _rootMemberId);
                }), child: const Text('Retry')),
              ]),
            ));
          }
          final data = snapshot.data ?? {};
          final nodes = data['nodes'];
          if (nodes is! List || nodes.isEmpty) {
            return const Center(child: Text('No genealogy positions were returned for this account.',
              textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)));
          }
          final rootNode = LiveDataService.buildGenealogyTree(nodes);
          if (rootNode == null) {
            return const Center(child: Text('The genealogy root position is missing.',
              style: TextStyle(color: Colors.white70)));
          }
          final rootId = (data['root'] is Map ? data['root']['member_id'] : rootNode['member_id'])?.toString();
          if (_rootMemberId == null && rootId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _rootMemberId == null) setState(() => _rootMemberId = rootId);
            });
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Center(child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _tree(rootNode, root: true),
            )),
          );
        },
      ),
    );
  }
}

class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = LiveDataService.instance.fetchProducts();
  }

  void _refresh() => setState(() {
    _productsFuture = LiveDataService.instance.fetchProducts();
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('OCTO7 Products', style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [IconButton(icon: const Icon(Icons.refresh, color: Colors.white), onPressed: _refresh)],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text('Unable to load OCTO7 products: ${snapshot.error}',
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.orangeAccent)),
                TextButton(onPressed: _refresh, child: const Text('Retry')),
              ]),
            ));
          }
          final products = snapshot.data ?? [];
          if (products.isEmpty) {
            return const Center(child: Text('No active products are currently available.',
              style: TextStyle(color: Colors.white70)));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final name = (product['name'] ?? 'Product').toString();
              final sku = (product['sku'] ?? '-').toString();
              final price = product['price'] ?? '-';
              final bv = product['bv'] ?? 0;
              return Card(
                color: const Color(0xFF060D1A),
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  title: Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text('SKU: $sku  •  BV: $bv',
                    style: const TextStyle(color: Colors.white60)),
                  trailing: Text('₹ $price', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CartCheckoutScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  const CartCheckoutScreen({super.key, required this.cartItems});

  @override
  State<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.cartItems.fold(0, (sum, item) => sum + (item['price'] as int));
    int totalPv = widget.cartItems.fold(0, (sum, item) => sum + (item['pv'] as int));

    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Cart & Checkout', style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: widget.cartItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.shopping_cart_outlined, size: 70, color: Colors.white30),
                  SizedBox(height: 15),
                  Text('Your cart is empty', style: TextStyle(color: Colors.white, fontSize: 16)),
                  SizedBox(height: 5),
                  Text('Add items from the multi-sector catalog', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: widget.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF060D1A),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Row(
                          children: [
                            Icon(item['icon'] as IconData, size: 36, color: item['color'] as Color),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text('₹ ${item['price']}  |  ${item['pv']} PV', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () {
                                setState(() {
                                  widget.cartItems.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF060D1A),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Amount:', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          Text('₹ $totalPrice', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Point Volume (PV):', style: TextStyle(color: Colors.grey, fontSize: 14)),
                          Text('$totalPv PV', style: const TextStyle(color: Color(0xFF10B981), fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                backgroundColor: const Color(0xFF060D1A),
                                title: const Text('Order Successful!', style: TextStyle(color: Colors.white)),
                                content: Text('Your order totaling ₹ $totalPrice has been placed. $totalPv PV has been credited to your account!', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      setState(() {
                                        widget.cartItems.clear();
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text('OK', style: TextStyle(color: Color(0xFF10B981))),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Text('Proceed to Checkout', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

// --- COMMISSION & PAYOUT HISTORY SCREEN ---
class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Commission & Payout History', style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No transaction history is available to display.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ),
      ),
    );
  }
}


class RankTrackerScreen extends StatelessWidget {
  const RankTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Rank Advancement', style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Rank information will appear here when available from your OCTO7 account.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ),
      ),
    );
  }
}


class MemberRegistrationScreen extends StatelessWidget {
  const MemberRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Register New Member', style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Member registration details will be loaded from the OCTO7 system. No sample sponsor or package details are shown.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ),
      ),
    );
  }
}


class MemberDashboardScreen extends StatefulWidget {
  const MemberDashboardScreen({super.key});

  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  late Future<Map<String, dynamic>> _dashboardFuture;
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = WalletService.instance.fetchDashboard();
    _profileFuture = LiveDataService.instance.fetchMemberProfile();
  }

  Future<void> _refreshDashboard() async {
    final next = WalletService.instance.fetchDashboard();
    final profile = LiveDataService.instance.fetchMemberProfile();
    setState(() {
      _dashboardFuture = next;
      _profileFuture = profile;
    });
    await Future.wait([next, profile]);
  }

  void _showWithdrawalModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF060D1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('E-Wallet Payout Request', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white54),
                      onPressed: () => Navigator.pop(ctx),
                    )
                  ],
                ),
                const Divider(color: Colors.white24),
                const SizedBox(height: 10),
                FutureBuilder<Map<String, dynamic>>(
                  future: _dashboardFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Available Balance: loading…', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 14));
                    }
                    if (snapshot.hasError) {
                      return const Text('Available Balance: unavailable', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 14));
                    }
                    final wallet = snapshot.data?['wallet'];
                    final raw = wallet is Map ? wallet['available_balance'] : null;
                    final amount = raw is num ? raw.toDouble() : double.tryParse('$raw') ?? 0;
                    return Text('Available Balance: ₹ ${amount.toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 14));
                  },
                ),
                const SizedBox(height: 15),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Withdrawal Amount (₹)',
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    hintText: 'Enter amount (e.g. 5000)',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF052411),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 15),
                const Text('Banking Details', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: 'Federal Bank'),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Bank Name',
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF052411),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Account Number',
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    hintText: 'Enter Federal Bank account number',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF052411),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'IFSC Code',
                    labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                    hintText: 'FDRL000XXXX',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                    filled: true,
                    fillColor: const Color(0xFF052411),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Payout request submitted successfully!')),
                      );
                    },
                    child: const Text('Submit Payout Request', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Member Back-Office', style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              try {
                await AuthService.instance.signOut();
              } finally {
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => AuthGate()),
                  (route) => false,
                );
              }
            },
          ),
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
              child: FutureBuilder<Map<String, dynamic>>(
                future: _profileFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Row(children: [
                      CircleAvatar(radius: 30, backgroundColor: Color(0xFF10B981), child: Icon(Icons.person, size: 35, color: Colors.white)),
                      SizedBox(width: 15),
                      Text('Loading member profile…', style: TextStyle(color: Colors.white70)),
                    ]);
                  }
                  if (snapshot.hasError) {
                    return Row(children: [
                      const CircleAvatar(radius: 30, backgroundColor: Color(0xFF10B981), child: Icon(Icons.person, size: 35, color: Colors.white)),
                      const SizedBox(width: 15),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Member profile unavailable', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold)),
                        TextButton(onPressed: _refreshDashboard, child: const Text('Retry')),
                      ])),
                    ]);
                  }
                  final data = snapshot.data ?? {};
                  final member = data['member'] is Map ? Map<String, dynamic>.from(data['member']) : <String, dynamic>{};
                  final rawId = (member['member_id'] ?? '').toString().trim();
                  final displayId = rawId.isEmpty ? 'Unavailable' : (rawId.toUpperCase().startsWith('OCTO7') ? rawId : 'OCTO7 $rawId');
                  final name = (member['full_name'] ?? '').toString().trim();
                  final status = (member['status'] ?? 'Unavailable').toString();
                  final positionType = (member['position_type'] ?? '').toString().replaceAll('_', ' ');
                  return Row(children: [
                    const CircleAvatar(radius: 30, backgroundColor: Color(0xFF10B981), child: Icon(Icons.person, size: 35, color: Colors.white)),
                    const SizedBox(width: 15),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(name.isEmpty ? 'Member name unavailable' : name, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('ID: $displayId', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text('Status: $status${positionType.isEmpty ? '' : ' • $positionType'}', style: const TextStyle(color: Color(0xFFD97706), fontSize: 12, fontWeight: FontWeight.w600)),
                    ])),
                  ]);
                },
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
                  FutureBuilder<Map<String, dynamic>>(
                    future: _dashboardFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 36,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF10B981)),
                            ),
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Wallet unavailable', style: TextStyle(color: Colors.orangeAccent, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(snapshot.error.toString(), style: const TextStyle(color: Colors.white60, fontSize: 11)),
                            TextButton(
                              onPressed: _refreshDashboard,
                              child: const Text('Retry', style: TextStyle(color: Color(0xFF10B981))),
                            ),
                          ],
                        );
                      }
                      final wallet = snapshot.data?['wallet'];
                      final raw = wallet is Map ? wallet['available_balance'] : null;
                      final amount = raw is num ? raw.toDouble() : double.tryParse('$raw') ?? 0;
                      return Text('₹ ${amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold));
                    },
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
                        onPressed: () => _showWithdrawalModal(context),
                        icon: const Icon(Icons.account_balance, size: 16, color: Colors.white),
                        label: const Text('Withdraw', style: TextStyle(color: Colors.white)),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.white54)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                          );
                        },
                        icon: const Icon(Icons.history, size: 16, color: Colors.white),
                        label: const Text('History', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Map<String, dynamic>>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                final binary = snapshot.data?['binary'] is Map
                    ? Map<String, dynamic>.from(snapshot.data!['binary'])
                    : <String, dynamic>{};
                String bv(dynamic value) {
                  final number = value is num ? value : num.tryParse('$value');
                  return number == null ? '—' : number.toStringAsFixed(0);
                }
                return Row(children: [
                  Expanded(child: _metricCard('Left Available BV', snapshot.hasError ? 'Unavailable' : bv(binary['left_available_bv']), Icons.trending_up, Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _metricCard('Right Available BV', snapshot.hasError ? 'Unavailable' : bv(binary['right_available_bv']), Icons.trending_up, Colors.green)),
                ]);
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                final binary = snapshot.data?['binary'] is Map
                    ? Map<String, dynamic>.from(snapshot.data!['binary'])
                    : <String, dynamic>{};
                final count = binary['downline_count'];
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF060D1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFD97706).withOpacity(0.5)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Genealogy Overview', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text(snapshot.hasError ? 'Downline information unavailable' : 'Total downline members: ${count ?? 'Loading…'}', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    const Text('Rank qualification will appear when rank data is available.', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ]),
                );
              },
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
                _actionButton(Icons.person_add, 'Add Member', (context) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MemberRegistrationScreen()));
                }),
                _actionButton(Icons.stars, 'Rank Tracker', (context) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RankTrackerScreen()));
                }),
                _actionButton(Icons.history_edu, 'Earnings Log', (context) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()));
                }),
                _actionButton(Icons.account_balance_wallet, 'Bank Details', (context) => _showWithdrawalModal(context)),
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

  static Widget _actionButton(IconData icon, String label, Function(BuildContext) onPressed) {
    return Builder(
      builder: (context) => ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF060D1A),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.white24),
          ),
        ),
        onPressed: () => onPressed(context),
        icon: Icon(icon, size: 18, color: const Color(0xFF10B981)),
        label: Text(label, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}
