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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF071426),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D8B68),
          brightness: Brightness.dark,
          primary: const Color(0xFF18A77C),
          secondary: const Color(0xFFD6A84B),
          surface: const Color(0xFF101F32),
          error: const Color(0xFFE57373),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF09182A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            color: Colors.white, fontSize: 18,
            fontWeight: FontWeight.w700, letterSpacing: 0.3,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF102238),
          elevation: 3,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0x263FAF91)),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF0D1D30),
          labelStyle: const TextStyle(color: Color(0xFFB7C5D6)),
          hintStyle: const TextStyle(color: Color(0xFF718096)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFF33465C)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFF33465C)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFF18A77C), width: 1.6),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF138A68),
            foregroundColor: Colors.white,
            elevation: 1,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
            textStyle: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 0.3),
          ),
        ),
        dividerColor: const Color(0x263FAF91),
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
    // Always show the original public welcome page on app launch.
    // Do not clear or modify any previously saved member session.
    return const WelcomeScreen();
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
                                  MaterialPageRoute(builder: (_) => const MainNavigationWrapper(initialIndex: 0)),
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

/// Personalised welcome page shown after successful member authentication.
class MemberWelcomeScreen extends StatelessWidget {
  const MemberWelcomeScreen({super.key});

  String _formatMemberId(dynamic value) {
    final id = (value ?? '').toString().trim();
    if (id.isEmpty) return 'Unavailable';
    return id.toUpperCase().startsWith('OCTO7') ? id : 'OCTO7 $id';
  }

  Widget _octo7Brand(double size) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size * 0.88,
          height: size * 0.88,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: size * 0.09),
          ),
          child: Text('🌍', style: TextStyle(fontSize: size * 0.53, height: 1)),
        ),
        const SizedBox(width: 2),
        Text('CTO', style: TextStyle(
          color: Colors.white, fontSize: size, fontWeight: FontWeight.w900,
          letterSpacing: 0.4, height: 1,
        )),
        Text('7', style: TextStyle(
          color: const Color(0xFFD6A84B), fontSize: size,
          fontWeight: FontWeight.w900, height: 1,
        )),
        SizedBox(width: size * 0.16),
        Text('India', style: TextStyle(
          color: Colors.white, fontSize: size * 0.58,
          fontWeight: FontWeight.w700, letterSpacing: 0.5, height: 1,
        )),
      ],
    );
  }

  Widget _memberWelcomeMenuItem(
      BuildContext context, IconData icon, String title, int destination) {
    return ListTile(
      leading: Icon(icon,
          color: destination == 14 ? Colors.orangeAccent : const Color(0xFF10B981)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      onTap: () async {
        Navigator.pop(context);
        if (destination == 14) {
          await AuthService.instance.signOut();
          if (!context.mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            (route) => false,
          );
          return;
        }
        if (destination >= 0 && destination <= 3) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (_) => MainNavigationWrapper(initialIndex: destination)),
            (route) => false,
          );
          return;
        }
        final Widget page;
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
          case 15: page = const MemberMenuInfoScreen(title: 'My Profile'); break;
          default: return;
        }
        if (!context.mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: LiveDataService.instance.fetchMemberProfile(),
      builder: (context, snapshot) {
        final response = snapshot.data ?? <String, dynamic>{};
        final member = response['member'] is Map
            ? Map<String, dynamic>.from(response['member'])
            : <String, dynamic>{};
        final name = (member['full_name'] ?? '').toString().trim();
        final memberId = _formatMemberId(member['member_id']);
        return Scaffold(
          backgroundColor: const Color(0xFF071426),
          appBar: AppBar(
            title: _octo7Brand(20),
          ),
          drawer: Drawer(
            backgroundColor: const Color(0xFF060D1A),
            child: SafeArea(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(color: Color(0xFF0F5127)),
                    child: Center(child: Text('OCTO7 INDIA\\nMEMBER MENU',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 21,
                        fontWeight: FontWeight.bold, height: 1.5))),
                  ),
                  _memberWelcomeMenuItem(context, Icons.home_filled, 'Home', 0),
                  _memberWelcomeMenuItem(context, Icons.dashboard, 'Dashboard', 3),
                  _memberWelcomeMenuItem(context, Icons.person_outline, 'My Profile', 15),
                  _memberWelcomeMenuItem(context, Icons.account_tree, 'My Genealogy', 1),
                  _memberWelcomeMenuItem(context, Icons.person_add_alt, 'New Member Registration', 4),
                  _memberWelcomeMenuItem(context, Icons.grid_view, 'Products', 2),
                  _memberWelcomeMenuItem(context, Icons.shopping_bag_outlined, 'My Orders', 5),
                  _memberWelcomeMenuItem(context, Icons.account_balance_wallet_outlined, 'My Wallet', 6),
                  _memberWelcomeMenuItem(context, Icons.account_balance, 'Bank Details', 7),
                  _memberWelcomeMenuItem(context, Icons.verified_user_outlined, 'KYC Verification', 8),
                  _memberWelcomeMenuItem(context, Icons.payments_outlined, 'Withdrawals', 9),
                  _memberWelcomeMenuItem(context, Icons.confirmation_number_outlined, 'My Coupons', 10),
                  _memberWelcomeMenuItem(context, Icons.lock_outline, 'Change Password', 11),
                  _memberWelcomeMenuItem(context, Icons.support_agent, 'Help Line', 12),
                  _memberWelcomeMenuItem(context, Icons.report_outlined, 'Report', 13),
                  const Divider(color: Colors.white24),
                  _memberWelcomeMenuItem(context, Icons.logout, 'Logout', 14),
                ],
              ),
            ),
          ),
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight,
              colors: [Color(0xFF123C56), Color(0xFF071426), Color(0xFF052411)],
            )),
            child: SafeArea(child: Center(child: SingleChildScrollView(
              padding: const EdgeInsets.all(26),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Image.asset('assets/images/OCTO7_emblem_transparent-2.png',
                    width: 176, height: 176, fit: BoxFit.contain),
                  const SizedBox(height: 18),
                  _octo7Brand(29),
                  const SizedBox(height: 24),
                  if (snapshot.connectionState == ConnectionState.waiting)
                    const CircularProgressIndicator(color: Color(0xFFD6A84B))
                  else if (snapshot.hasError)
                    const Text('Unable to load member details. Open Dashboard from the menu.',
                      textAlign: TextAlign.center, style: TextStyle(color: Colors.orangeAccent))
                  else ...[
                    Text(name.isEmpty ? 'Welcome!' : 'Welcome, $name!',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 25,
                        fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    const Text('Together For a Better Tomorrow',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFE5D6B8), fontSize: 15,
                        fontStyle: FontStyle.italic)),
                    const SizedBox(height: 16),
                    Text('Member ID: $memberId', textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFFD6A84B),
                        fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 18),
                    const Text('Open the menu to access your Dashboard.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ]),
              ),
            ))),
          ),
        );
      },
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

  Widget _menuItem(BuildContext context, IconData icon, String title, int destination) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF10B981)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      onTap: () async {
        Navigator.pop(context);
        if (destination >= 0 && destination <= 3) {
          setState(() => _selectedIndex = destination);
          return;
        }
        if (destination == 14) {
          await AuthService.instance.signOut();
          if (!mounted) return;
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const AuthGate()), (route) => false);
          return;
        }
        final Widget page;
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
          case 15: page = const MemberMenuInfoScreen(title: 'My Profile'); break;
          default: return;
        }
        if (!mounted) return;
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: const Color(0xFF060D1A),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFF0F5127)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('OCTO7 INDIA\\nMEMBER MENU',
                    style: TextStyle(color: Colors.white, fontSize: 22,
                      fontWeight: FontWeight.bold, height: 1.5)),
                ),
              ),
              _menuItem(context, Icons.home_filled, 'Home', 0),
              _menuItem(context, Icons.dashboard, 'Dashboard', 3),
              _menuItem(context, Icons.person_outline, 'My Profile', 15),
              _menuItem(context, Icons.account_tree, 'My Genealogy', 1),
              _menuItem(context, Icons.person_add_alt, 'New Member Registration', 4),
              _menuItem(context, Icons.grid_view, 'Products', 2),
              _menuItem(context, Icons.shopping_bag_outlined, 'My Orders', 5),
              _menuItem(context, Icons.account_balance_wallet_outlined, 'My Wallet', 6),
              _menuItem(context, Icons.account_balance, 'Bank Details', 7),
              _menuItem(context, Icons.verified_user_outlined, 'KYC Verification', 8),
              _menuItem(context, Icons.payments_outlined, 'Withdrawals', 9),
              _menuItem(context, Icons.confirmation_number_outlined, 'My Coupons', 10),
              _menuItem(context, Icons.lock_outline, 'Change Password', 11),
              _menuItem(context, Icons.support_agent, 'Help Line', 12),
              _menuItem(context, Icons.report_outlined, 'Report', 13),
              const Divider(color: Colors.white24),
              _menuItem(context, Icons.logout, 'Logout', 14),
            ],
          ),
        ),
      ),
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
      backgroundColor: const Color(0xFF071426),
      drawer: Drawer(
        backgroundColor: const Color(0xFF060D1A),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
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
              _memberDrawerItem(context, Icons.person_outline, 'My Profile', 15),
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
              const SizedBox(height: 8),
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


class _Octo7PagePalette {
  final Color background;
  final Color appBar;
  final Color accent;
  final Color panel;
  final List<Color> gradient;
  const _Octo7PagePalette(this.background, this.appBar, this.accent, this.panel, this.gradient);
}

_Octo7PagePalette _paletteFor(String title) {
  switch (title) {
    case 'Login':
      return const _Octo7PagePalette(Color(0xFF101D3A), Color(0xFF172B52), Color(0xFFB9C7E8), Color(0xFF1C2E50), [Color(0xFF203D70), Color(0xFF101D3A)]);
    case 'Dashboard':
      return const _Octo7PagePalette(Color(0xFF062D27), Color(0xFF084638), Color(0xFFD6B76A), Color(0xFF0B4035), [Color(0xFF08745A), Color(0xFF063B31)]);
    case 'My Profile':
      return const _Octo7PagePalette(Color(0xFF2B1420), Color(0xFF421D31), Color(0xFFE8C9C5), Color(0xFF3A1C2B), [Color(0xFF6B304A), Color(0xFF351827)]);
    case 'My Genealogy':
      return const _Octo7PagePalette(Color(0xFF062B35), Color(0xFF0A3D4B), Color(0xFF56D6D0), Color(0xFF0B3945), [Color(0xFF087487), Color(0xFF07313D)]);
    case 'New Member Registration':
      return const _Octo7PagePalette(Color(0xFF24183D), Color(0xFF35235A), Color(0xFFD5C5F5), Color(0xFF30204D), [Color(0xFF62449A), Color(0xFF291B43)]);
    case 'Products':
    case 'Our Products':
      return const _Octo7PagePalette(Color(0xFFF3F7F2), Color(0xFF174B35), Color(0xFF2F8056), Color(0xFFFFFFFF), [Color(0xFFE4F1E8), Color(0xFFF7FAF7)]);
    case 'My Orders':
    case 'Cart & Checkout':
      return const _Octo7PagePalette(Color(0xFF17283D), Color(0xFF243D5B), Color(0xFF9CC9F2), Color(0xFF203650), [Color(0xFF315779), Color(0xFF192B42)]);
    case 'My Wallet':
    case 'Withdrawals':
      return const _Octo7PagePalette(Color(0xFF07382E), Color(0xFF0B5141), Color(0xFFE0C58A), Color(0xFF104638), [Color(0xFF11745A), Color(0xFF073B30)]);
    case 'Bank Details':
      return const _Octo7PagePalette(Color(0xFF172337), Color(0xFF26364F), Color(0xFFD3DCE8), Color(0xFF233149), [Color(0xFF405675), Color(0xFF1B293D)]);
    case 'KYC Verification':
      return const _Octo7PagePalette(Color(0xFF202044), Color(0xFF303064), Color(0xFFC4C7F4), Color(0xFF2A2A57), [Color(0xFF4B4B91), Color(0xFF23234A)]);
    case 'My Coupons':
      return const _Octo7PagePalette(Color(0xFF321D38), Color(0xFF4A2A50), Color(0xFFE8B9D5), Color(0xFF402447), [Color(0xFF75466D), Color(0xFF39203E)]);
    case 'Change Password':
      return const _Octo7PagePalette(Color(0xFF171D27), Color(0xFF252F3D), Color(0xFF69B9F5), Color(0xFF222D3B), [Color(0xFF344D68), Color(0xFF192330)]);
    case 'Help Line':
      return const _Octo7PagePalette(Color(0xFF12334A), Color(0xFF1D4C69), Color(0xFFB9E4FA), Color(0xFF1A4059), [Color(0xFF34789A), Color(0xFF17394F)]);
    case 'Report':
    case 'Reports':
      return const _Octo7PagePalette(Color(0xFF292725), Color(0xFF403A34), Color(0xFFD7B38A), Color(0xFF37312C), [Color(0xFF65513F), Color(0xFF302B27)]);
    case 'Rank Advancement':
      return const _Octo7PagePalette(Color(0xFF29251D), Color(0xFF443A29), Color(0xFFE6C58B), Color(0xFF393123), [Color(0xFF76613C), Color(0xFF332B20)]);
    case 'Commission & Payout History':
      return const _Octo7PagePalette(Color(0xFF1D2B3D), Color(0xFF2A405A), Color(0xFFB8D7F4), Color(0xFF263A51), [Color(0xFF456887), Color(0xFF1E3045)]);
    case 'About Us':
      return const _Octo7PagePalette(Color(0xFF20283B), Color(0xFF303D58), Color(0xFFD8C79F), Color(0xFF29354D), [Color(0xFF485A78), Color(0xFF202A3D)]);
    case 'Business Opportunity':
      return const _Octo7PagePalette(Color(0xFF15372F), Color(0xFF205344), Color(0xFFB7DFC9), Color(0xFF1D463B), [Color(0xFF36745C), Color(0xFF173B31)]);
    case 'Business Plan':
      return const _Octo7PagePalette(Color(0xFF302719), Color(0xFF4B3B25), Color(0xFFE5C98C), Color(0xFF3C301F), [Color(0xFF735B35), Color(0xFF352A1D)]);
    case 'Contact Us':
      return const _Octo7PagePalette(Color(0xFF153747), Color(0xFF205267), Color(0xFFB9E6F2), Color(0xFF1D4659), [Color(0xFF34758A), Color(0xFF173B4C)]);
    default:
      return const _Octo7PagePalette(Color(0xFF071426), Color(0xFF09182A), Color(0xFFD6A84B), Color(0xFF102238), [Color(0xFF123C56), Color(0xFF071426)]);
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
    final palette = _paletteFor(title);
    final isLight = title == 'Our Products';
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(backgroundColor: palette.appBar, foregroundColor: isLight ? Colors.white : Colors.white, title: Text(title), iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: palette.panel, borderRadius: BorderRadius.circular(18), border: Border.all(color: palette.accent.withOpacity(0.55))),
        child: Text(descriptions[title] ?? title, style: TextStyle(color: isLight ? const Color(0xFF203329) : Colors.white, fontSize: 16, height: 1.7), textAlign: TextAlign.left),
      ))),
    );
  }
}

class MemberMenuInfoScreen extends StatelessWidget {
  const MemberMenuInfoScreen({super.key, required this.title});
  final String title;

  static const Map<String, IconData> _icons = {
    'My Profile': Icons.person_outline,
    'My Orders': Icons.shopping_bag_outlined,
    'Bank Details': Icons.account_balance_outlined,
    'KYC Verification': Icons.verified_user_outlined,
    'Withdrawals': Icons.payments_outlined,
    'My Coupons': Icons.confirmation_number_outlined,
    'Change Password': Icons.lock_outline,
    'Help Line': Icons.support_agent,
    'Report': Icons.report_outlined,
  };

  static const Map<String, String> _descriptions = {
    'My Profile': 'View and maintain your OCTO7 member identity and contact information.',
    'My Orders': 'Review product orders, order status and purchase history.',
    'Bank Details': 'Manage the bank account details used for eligible member payouts.',
    'KYC Verification': 'Submit and track the documents required for identity verification.',
    'Withdrawals': 'Review payout eligibility and track withdrawal requests.',
    'My Coupons': 'View coupons issued to your Member ID and their redemption status.',
    'Change Password': 'Securely update the password used to access your OCTO7 account.',
    'Help Line': 'Find OCTO7 support contact information and assistance.',
    'Report': 'Raise an issue or send a report to the OCTO7 support team.',
  };

  @override
  Widget build(BuildContext context) {
    final icon = _icons[title] ?? Icons.dashboard_outlined;
    final description = _descriptions[title] ?? 'OCTO7 member services.';
    final palette = _paletteFor(title);
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        backgroundColor: palette.appBar,
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: palette.gradient),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: palette.accent.withOpacity(0.75)),
              ),
              child: Row(children: [
                CircleAvatar(
                  radius: 27,
                  backgroundColor: palette.accent.withOpacity(0.18),
                  child: Icon(icon, color: palette.accent, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('OCTO7 INDIA', style: TextStyle(color: Colors.white70, fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ])),
              ]),
            ),
            const SizedBox(height: 18),
            Text(description, style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.5)),
            const SizedBox(height: 20),
            _sectionCard(
              icon: Icons.dashboard_customize_outlined,
              heading: '$title workspace',
              message: 'This section is now available in the member app. Its detailed fields, records and actions will be added in the next configuration stage.',
            ),
            const SizedBox(height: 12),
            _sectionCard(
              icon: Icons.security_outlined,
              heading: 'Account protection',
              message: 'Member-specific information and any sensitive action will be connected only through authenticated, permission-checked services.',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: palette.panel,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: palette.accent.withOpacity(0.28)),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.info_outline, color: palette.accent, size: 20),
                SizedBox(width: 10),
                Expanded(child: Text('Setup stage: screen and navigation ready. No sample records, bank details, KYC documents or payout requests are being created.', style: TextStyle(color: Colors.white60, fontSize: 12, height: 1.5))),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _sectionCard({required IconData icon, required String heading, required String message}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _paletteFor(heading.contains('workspace') ? heading.replaceFirst(' workspace', '') : 'Dashboard').panel,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(icon, color: _paletteFor(heading.contains('workspace') ? heading.replaceFirst(' workspace', '') : 'Dashboard').accent, size: 20),
          const SizedBox(width: 9),
          Expanded(child: Text(heading, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        ]),
        const SizedBox(height: 9),
        Text(message, style: const TextStyle(color: Colors.white60, fontSize: 13, height: 1.5)),
      ]),
    );
  }
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
      backgroundColor: const Color(0xFF1D2B3D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A405A),
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
      backgroundColor: const Color(0xFF29251D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF443A29),
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
      backgroundColor: const Color(0xFF24183D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF35235A),
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
