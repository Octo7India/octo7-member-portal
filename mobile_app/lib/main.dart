import 'dart:math';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';
import 'services/auth_service.dart';
import 'services/wallet_service.dart';
import 'services/live_data_service.dart';
import 'services/navigation_service.dart';
import 'screens/public_website_screen.dart';
import 'screens/member_registration_screen.dart';
import 'screens/member_profile_edit_screen.dart';

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
      navigatorKey: NavigationService().navigatorKey,
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
    // Public pages do not require authentication or a Supabase session.
    // Login continues into the existing authenticated member welcome flow.
    return PublicWebsiteScreen(
      onMemberLogin: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => MemberLoginScreen(
            onLogin: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const MemberWelcomeScreen()),
                (route) => false,
              );
            },
          ),
        ));
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
          const DrawerHeader(decoration: BoxDecoration(color: Color(0xFF0F5127)), child: Align(alignment: Alignment.centerLeft, child: Text('OCTO7 INDIA\nVISITOR MENU', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.5)))),
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
                                  MaterialPageRoute(builder: (_) => const MemberWelcomeScreen()),
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


/// Shared corporate member drawer used throughout the authenticated app.
class Octo7AppDrawer extends StatelessWidget {
  const Octo7AppDrawer({super.key, required this.onDestinationSelected});
  final ValueChanged<int> onDestinationSelected;

  Widget _sectionHeader(String title) => Padding(
    padding: const EdgeInsets.only(left: 16, top: 12, bottom: 5),
    child: Text(title, style: const TextStyle(color: Color(0xFF94A3B8),
      fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
  );

  Widget _drawerItem(BuildContext context, IconData icon, String title, int destination) {
    return ListTile(
      dense: true,
      horizontalTitleGap: 12,
      leading: Icon(icon, color: const Color(0xFF10B981), size: 22),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
      onTap: () {
        Navigator.pop(context);
        onDestinationSelected(destination);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF060D1A),
      child: SafeArea(child: ListView(padding: EdgeInsets.zero, children: [
        FutureBuilder<Map<String, dynamic>>(
          future: LiveDataService.instance.fetchMemberProfile(),
          builder: (context, snapshot) {
            final response = snapshot.data ?? <String, dynamic>{};
            final member = response['member'] is Map
                ? Map<String, dynamic>.from(response['member']) : <String, dynamic>{};
            final rawId = (member['member_id'] ?? '').toString().trim();
            final memberId = rawId.isEmpty ? 'Member ID unavailable'
                : (rawId.toUpperCase().startsWith('OCTO7') ? 'ID: $rawId' : 'ID: OCTO7 $rawId');
            final name = (member['full_name'] ?? '').toString().trim();
            final photoPath = (member['profile_photo_path'] ?? '').toString().trim();
            final photoUrl = photoPath.isNotEmpty
                ? Supabase.instance.client.storage.from('member-profile-photos').getPublicUrl(photoPath)
                : (member['profile_photo_url'] ?? member['avatar_url'] ?? '').toString().trim();
            return UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: const BoxDecoration(color: Color(0xFF0B192C)),
              accountName: Text(name.isEmpty ? 'OCTO7 Member' : name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              accountEmail: Text(memberId, style: const TextStyle(
                color: Color(0xFF10B981), fontWeight: FontWeight.w600)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color(0xFF10B981),
                backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                child: photoUrl.isEmpty
                    ? const Icon(Icons.person, color: Colors.white, size: 36)
                    : null,
              ),
            );
          },
        ),
        _sectionHeader('OVERVIEW'),
        _drawerItem(context, Icons.home_rounded, 'Home', 0),
        _drawerItem(context, Icons.dashboard_rounded, 'Dashboard', 3),
        const Divider(color: Colors.white12, height: 20),
        _sectionHeader('MY ACCOUNT'),
        _drawerItem(context, Icons.person_outline, 'My Profile', 15),
        _drawerItem(context, Icons.account_balance_outlined, 'Bank Details', 7),
        _drawerItem(context, Icons.verified_user_outlined, 'KYC Verification', 8),
        _drawerItem(context, Icons.lock_outline, 'Change Password', 11),
        const Divider(color: Colors.white12, height: 20),
        _sectionHeader('NETWORK'),
        _drawerItem(context, Icons.account_tree_outlined, 'My Genealogy', 1),
        _drawerItem(context, Icons.person_add_alt_1_outlined, 'New Member Registration', 4),
        const Divider(color: Colors.white12, height: 20),
        _sectionHeader('SHOPPING'),
        _drawerItem(context, Icons.grid_view_rounded, 'Products', 2),
        _drawerItem(context, Icons.shopping_bag_outlined, 'My Orders', 5),
        _drawerItem(context, Icons.confirmation_number_outlined, 'My Coupons', 10),
        const Divider(color: Colors.white12, height: 20),
        _sectionHeader('FINANCIALS'),
        _drawerItem(context, Icons.account_balance_wallet_outlined, 'My Wallet', 6),
        _drawerItem(context, Icons.payments_outlined, 'Withdrawals', 9),
        const Divider(color: Colors.white12, height: 20),
        _drawerItem(context, Icons.support_agent, 'Help Line', 12),
        _drawerItem(context, Icons.report_outlined, 'Report', 13),
        const Divider(color: Colors.white12, height: 20),
        _drawerItem(context, Icons.logout, 'Logout', 14),
        const SizedBox(height: 16),
      ])),
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
            MaterialPageRoute(builder: (_) => const AuthGate()),
            (route) => false,
          );
          return;
        }
        if (destination < 0 || destination > 15) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MainNavigationWrapper(
              initialIndex: destination <= 3 ? destination : 3,
              initialDestination: destination > 3 ? destination : null,
              returnToWelcomeMenuOnBack: true,
            ),
          ),
        );
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
            title: const Text('OCTO7 India'),
            leading: Builder(builder: (context) => IconButton(
              tooltip: 'Open member menu',
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )),
          ),
          drawer: Octo7AppDrawer(
            onDestinationSelected: (destination) async {
              if (destination == 14) {
                await AuthService.instance.signOut();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const AuthGate()), (route) => false);
                return;
              }
              if (destination < 0 || destination > 15) return;
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => MainNavigationWrapper(
                  initialIndex: destination <= 3 ? destination : 3,
                  initialDestination: destination > 3 ? destination : null,
                  returnToWelcomeMenuOnBack: true,
                )));
            },
          ),
          body: Container(
            width: double.infinity,
            color: const Color(0xFF071426),
            child: SafeArea(child: Center(child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFD8D0C3),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 24, offset: Offset(0, 10))],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(22, 34, 22, 28),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                          colors: [Color(0xFF173E2C), Color(0xFF17472F), Color(0xFF092B20)]),
                      ),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const Text('OCTO7', style: TextStyle(color: Color(0xFFF3EEE3), fontSize: 48,
                          fontWeight: FontWeight.w800, letterSpacing: 3, shadows: [Shadow(color: Colors.black54, blurRadius: 5, offset: Offset(0, 3))])),
                        const SizedBox(height: 12),
                        Image.asset('assets/images/OCTO7_emblem_transparent-2.png',
                          width: 230, height: 230, fit: BoxFit.contain),
                        const SizedBox(height: 8),
                        const Text('Together for a better tomorrow', textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFFD6A15F), fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: .5)),
                        const SizedBox(height: 26),
                        const Text('Welcome', style: TextStyle(color: Color(0xFFE9C39C), fontSize: 32)),
                        const SizedBox(height: 8),
                        if (snapshot.connectionState == ConnectionState.waiting)
                          const CircularProgressIndicator(color: Color(0xFFD6A84B))
                        else if (snapshot.hasError)
                          const Text('Unable to load member details. Open Dashboard from the menu.',
                            textAlign: TextAlign.center, style: TextStyle(color: Colors.orangeAccent))
                        else ...[
                          Text(name.isEmpty ? 'OCTO7 Member' : name, textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Member ID: $memberId', textAlign: TextAlign.center,
                            style: const TextStyle(color: Color(0xFFF0D7B7), fontSize: 15, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 22),
                          const Text('Plant the Seed of Effort, Harvest a Lifetime of Success.',
                            textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFE7C59E), fontSize: 18, height: 1.45)),
                          const SizedBox(height: 34),
                          const Text('Discover a world of opportunities through quality products, entrepreneurship and growing business network.',
                            textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFEADCC9), fontSize: 15, height: 1.5)),
                        ],
                      ]),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 10),
                      child: Column(children: [
                        Text('OCTO7 India', style: TextStyle(color: Color(0xFF153C28), fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('Dream. Network. Grow.', style: TextStyle(color: Color(0xFF153C28), fontSize: 13)),
                      ]),
                    ),
                  ]),
                ),
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
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _busy = false;
  bool _hidePassword = true;
  bool _hideUserId = true;
  String? _error;

  Future<void> _login() async {
    final id = _identifierController.text.trim().replaceFirst(
      RegExp(r'^OCTO7\s*', caseSensitive: false), '',
    );
    if (id.isEmpty || !RegExp(r'^[0-9]+$').hasMatch(id)) {
      setState(() => _error = 'Enter your OCTO7 User ID number.');
      return;
    }
    if (_passwordController.text.isEmpty) {
      setState(() => _error = 'Enter your password.');
      return;
    }
    if (_busy) return;
    setState(() { _busy = true; _error = null; });
    try {
      await AuthService.instance.signIn(
        identifier: id, password: _passwordController.text,
      );
      if (mounted) widget.onLogin();
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString().replaceFirst('Exception: ', ''));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData leading,
    Widget? trailing,
    String? prefixText,
  }) => InputDecoration(
    hintText: hint,
    prefixText: prefixText,
    prefixStyle: const TextStyle(color: Color(0xFF17233D), fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: .3),
    hintStyle: const TextStyle(color: Color(0xFF737373), fontSize: 14),
    prefixIcon: Icon(leading, color: const Color(0xFF495057), size: 19),
    suffixIcon: trailing,
    suffixIconConstraints: const BoxConstraints(minWidth: 48, minHeight: 48),
    filled: true,
    fillColor: const Color(0xFFF6F6F6),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    constraints: const BoxConstraints(minHeight: 54),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFDDD6C8)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFDDD6C8)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFB8892D), width: 1.5),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/octo7_login_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 28),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight - 52),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 22),
                        child: SizedBox(
                          width: 136,
                          height: 136,
                          child: Image.asset(
                            'assets/images/OCTO7_emblem_transparent-2.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                        decoration: BoxDecoration(
                          color: const Color(0xEBFFFDF8),
                          border: Border.all(color: const Color(0xFFE2D5B5)),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x1F000000),
                              blurRadius: 26,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'OCTO7 India',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w800,
                                color: Color(0xFF1E242B), letterSpacing: .2,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'MEMBER LOGIN',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w700,
                                color: Color(0xFFB8892D), letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Log in with your OCTO7 User ID and your existing password.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13, height: 1.4,
                                color: Color(0xFF4A4A4A),
                              ),
                            ),
                            const SizedBox(height: 24),
                            TextField(
                              controller: _identifierController,
                              keyboardType: TextInputType.number,
                              obscureText: _hideUserId,
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Color(0xFF17233D), fontSize: 15,
                              ),
                              decoration: _fieldDecoration(
                                hint: 'Enter number only',
                                leading: Icons.badge_outlined,
                                prefixText: 'OCTO7 ',
                                trailing: IconButton(
                                  tooltip: _hideUserId ? 'Show User ID' : 'Hide User ID',
                                  onPressed: () => setState(() => _hideUserId = !_hideUserId),
                                  icon: Icon(
                                    _hideUserId ? Icons.visibility : Icons.visibility_off,
                                    color: const Color(0xFF3D4856), size: 20,
                                  ),
                                ),
                              ),
                              onChanged: (_) {
                                if (_error != null) setState(() => _error = null);
                              },
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: _passwordController,
                              obscureText: _hidePassword,
                              textInputAction: TextInputAction.done,
                              maxLines: 1,
                              style: const TextStyle(
                                color: Color(0xFF17233D), fontSize: 15,
                              ),
                              decoration: _fieldDecoration(
                                hint: 'Password',
                                leading: Icons.lock_outline,
                                trailing: IconButton(
                                  tooltip: _hidePassword
                                      ? 'Show password' : 'Hide password',
                                  onPressed: () => setState(
                                    () => _hidePassword = !_hidePassword,
                                  ),
                                  icon: Icon(
                                    _hidePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: const Color(0xFF3D4856),
                                    size: 20,
                                  ),
                                ),
                              ),
                              onSubmitted: (_) => _login(),
                              onChanged: (_) {
                                if (_error != null) setState(() => _error = null);
                              },
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 10),
                              Text(
                                _error!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Color(0xFFC62828), fontSize: 12,
                                ),
                              ),
                            ],
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 48,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFE6BE5A), Color(0xFFF5D77F),
                                      Color(0xFF073B8C), Color(0xFF0A58CA),
                                      Color(0xFF062F70),
                                    ],
                                    stops: [0, .18, .22, .55, 1],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: const Color(0xFFC99B3B), width: 1.5,
                                  ),
                                ),
                                child: ElevatedButton(
                                  onPressed: _busy ? null : _login,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    disabledBackgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _busy
                                      ? const SizedBox(
                                          width: 20, height: 20,
                                          child: CircularProgressIndicator(
                                            color: Colors.white, strokeWidth: 2,
                                          ),
                                        )
                                      : const Text(
                                          'MEMBER LOGIN',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: .8,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const MemberPasswordRecoveryScreen(),
                                ),
                              ),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Color(0xFF222222), fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        ),
      ),
    );
  }
}

class MemberPasswordRecoveryScreen extends StatefulWidget {
  const MemberPasswordRecoveryScreen({super.key});
  @override
  State<MemberPasswordRecoveryScreen> createState()=>_MemberPasswordRecoveryScreenState();
}
class _MemberPasswordRecoveryScreenState extends State<MemberPasswordRecoveryScreen>{
  final _id=TextEditingController(),_code=TextEditingController(),_password=TextEditingController(),_confirm=TextEditingController();
  String _method='email';String? _recoveryId,_message;bool _sent=false,_verified=false,_busy=false,_hideNewPassword=true,_hideConfirmPassword=true;
  @override
  void dispose(){_id.dispose();_code.dispose();_password.dispose();_confirm.dispose();super.dispose();}
  Future<void> _send()async{
    if(_id.text.trim().isEmpty){setState(()=>_message='Enter your OCTO7 User ID.');return;}
    setState(()=>_busy=true);
    try{final r=await AuthService.instance.startPasswordRecovery(memberId:_id.text.trim(),method:_method);
      setState(()=>_recoveryId=r['recovery_id']?.toString());setState(()=>_sent=true);setState(()=>_message='A code has been sent to your registered contact.');}
    catch(e){setState(()=>_message=e.toString().replaceFirst('Exception: ',''));}
    finally{if(mounted)setState(()=>_busy=false);}
  }
  Future<void> _verify()async{
    if(_recoveryId==null)return;setState(()=>_busy=true);
    try{await AuthService.instance.verifyPasswordRecoverySms(recoveryId:_recoveryId!,code:_code.text.trim());
      setState(()=>_verified=true);setState(()=>_message='Mobile verified. Create your new password.');}
    catch(e){setState(()=>_message=e.toString().replaceFirst('Exception: ',''));}
    finally{if(mounted)setState(()=>_busy=false);}
  }
  Future<void> _update()async{
    if(_recoveryId==null)return;
    if(_password.text.length<8||_password.text.length>72){setState(()=>_message='Password must be 8 to 72 characters.');return;}
    if(_password.text!=_confirm.text){setState(()=>_message='Passwords do not match.');return;}
    if(_method=='phone'&&!_verified){setState(()=>_message='Verify your SMS code first.');return;}
    setState(()=>_busy=true);
    try{await AuthService.instance.completePasswordRecovery(recoveryId:_recoveryId!,method:_method,code:_method=='email'?_code.text.trim():'',password:_password.text);
      setState(()=>_message='Password updated. You can now log in.');setState(()=>_sent=false);setState(()=>_recoveryId=null);}
    catch(e){setState(()=>_message=e.toString().replaceFirst('Exception: ',''));}
    finally{if(mounted)setState(()=>_busy=false);}
  }
  @override
  Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Forgot Password?')),
    body:Center(child:SingleChildScrollView(padding:const EdgeInsets.all(24),child:ConstrainedBox(
      constraints:const BoxConstraints(maxWidth:420),child:Column(crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        TextField(controller:_id,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'OCTO7 User ID')),
        const SizedBox(height:14),DropdownButtonFormField<String>(value:_method,decoration:const InputDecoration(labelText:'Verify using'),
          items:const [DropdownMenuItem(value:'email',child:Text('Email OTP')),DropdownMenuItem(value:'phone',child:Text('Mobile SMS OTP'))],
          onChanged:_sent?null:(v)=>setState(()=>_method=v??'email')),
        const SizedBox(height:14),
        if(!_sent)ElevatedButton(onPressed:_busy?null:_send,child:Text(_busy?'PLEASE WAIT':'SEND OTP')),
        if(_sent)...[
          TextField(controller:_code,keyboardType:TextInputType.number,maxLength:6,decoration:const InputDecoration(labelText:'6-digit OTP')),
          if(_method=='phone'&&!_verified)ElevatedButton(onPressed:_busy?null:_verify,child:const Text('VERIFY SMS OTP')),
          if(_method=='email'||_verified)...[
            TextField(controller:_password,obscureText:_hideNewPassword,decoration:InputDecoration(labelText:'New Password',
              suffixIcon:IconButton(tooltip:_hideNewPassword?'Show password':'Hide password',
                onPressed:()=>setState(()=>_hideNewPassword=!_hideNewPassword),
                icon:Icon(_hideNewPassword?Icons.visibility:Icons.visibility_off)))),
            TextField(controller:_confirm,obscureText:_hideConfirmPassword,decoration:InputDecoration(labelText:'Confirm New Password',
              suffixIcon:IconButton(tooltip:_hideConfirmPassword?'Show password':'Hide password',
                onPressed:()=>setState(()=>_hideConfirmPassword=!_hideConfirmPassword),
                icon:Icon(_hideConfirmPassword?Icons.visibility:Icons.visibility_off)))),
            ElevatedButton(onPressed:_busy?null:_update,child:Text(_busy?'PLEASE WAIT':'UPDATE PASSWORD')),
          ],
        ],
        if(_message!=null)Padding(padding:const EdgeInsets.only(top:16),child:Text(_message!,textAlign:TextAlign.center)),
      ])))));
}
class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({
    super.key,
    this.initialIndex = 0,
    this.returnToWelcomeMenuOnBack = false,
    this.initialDestination,
  });
  final int initialIndex;
  final bool returnToWelcomeMenuOnBack;
  final int? initialDestination;

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  late int _selectedIndex;
  final List<int> _tabHistory = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _welcomeMenuRestoredByBack = false;
  bool _closingDrawerForSelection = false;

  void _selectTab(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _tabHistory.add(_selectedIndex);
      _selectedIndex = index;
    });
  }

  void _handleGenealogyBack() {
    if (_tabHistory.isNotEmpty) {
      setState(() => _selectedIndex = _tabHistory.removeLast());
      return;
    }
    // If this wrapper was opened as a page from another screen, pop back to
    // that exact route. Never force the member to the Dashboard tab.
    final navigator = Navigator.of(context);
    if (navigator.canPop()) navigator.pop();
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, 3);
    if (widget.initialDestination != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final page = _pageForDestination(widget.initialDestination!);
        if (page != null) {
          NavigationService().navigateTo(page);
        }
      });
    }
  }

  Widget? _pageForDestination(int destination) {
    switch (destination) {
      case 4: return const MemberRegistrationScreen();
      case 5: return const MemberMenuInfoScreen(title: 'My Orders');
      case 6: return const TransactionHistoryScreen();
      case 7: return const MemberMenuInfoScreen(title: 'Bank Details');
      case 8: return const MemberMenuInfoScreen(title: 'KYC Verification');
      case 9: return const MemberMenuInfoScreen(title: 'Withdrawals');
      case 10: return const MemberMenuInfoScreen(title: 'My Coupons');
      case 11: return const MemberMenuInfoScreen(title: 'Change Password');
      case 12: return const MemberMenuInfoScreen(title: 'Help Line');
      case 13: return const MemberMenuInfoScreen(title: 'Report');
      case 15: return const MemberProfileScreen();
      default: return null;
    }
  }

  /// Primary destinations switch the wrapper's tab. Secondary destinations
  /// are pushed onto the app-wide root navigator so Android Back pops them.
  Future<void> _handleDestinationSelected(int destination) async {
    if (destination >= 0 && destination <= 3) {
      _selectTab(destination);
      return;
    }

    if (destination == 14) {
      await AuthService.instance.signOut();
      if (!mounted) return;
      NavigationService().clearAndNavigateTo(const AuthGate());
      return;
    }

    final page = _pageForDestination(destination);
    if (page != null && mounted) {
      NavigationService().navigateTo(page);
    }
  }

  final GlobalKey<_BinaryTreeViewScreenState> _genealogyKey =
      GlobalKey<_BinaryTreeViewScreenState>();

  late final List<Widget> _pages = [
    const Octo7WebsiteHomeScreen(),
    BinaryTreeViewScreen(key: _genealogyKey, onBack: _handleGenealogyBack),
    const ProductCatalogScreen(),
    const MemberDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedIndex == 1 &&
            (_genealogyKey.currentState?.handleSystemBack() ?? false)) {
          return false;
        }
        if (_tabHistory.isNotEmpty) {
          setState(() => _selectedIndex = _tabHistory.removeLast());
          return false;
        }
        if (_selectedIndex == 1) {
          // Genealogy was opened as the initial page of this wrapper: pop to
          // the route that opened it instead of redirecting to Dashboard/menu.
          final navigator = Navigator.of(context);
          if (navigator.canPop()) {
            navigator.pop();
            return false;
          }
          return true;
        }
        if (widget.returnToWelcomeMenuOnBack &&
            !_welcomeMenuRestoredByBack) {
          _welcomeMenuRestoredByBack = true;
          _scaffoldKey.currentState?.openDrawer();
          return false;
        }
        if (_welcomeMenuRestoredByBack) {
          NavigationService().goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        onDrawerChanged: (isOpened) {
          if (!isOpened &&
              _welcomeMenuRestoredByBack &&
              !_closingDrawerForSelection &&
              mounted) {
            _welcomeMenuRestoredByBack = false;
            NavigationService().goBack();
          }
        },
        drawer: Octo7AppDrawer(
          onDestinationSelected: (destination) async {
            // The drawer route has been popped; keep the wrapper mounted
            // while the close transition finishes before routing globally.
            _closingDrawerForSelection = true;
            await Future<void>.delayed(const Duration(milliseconds: 250));
            if (!mounted) return;
            _closingDrawerForSelection = false;
            await _handleDestinationSelected(destination);
          },
        ),
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _selectTab,
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
      drawer: Octo7AppDrawer(
        onDestinationSelected: (destination) async {
          if (destination == 14) {
            await AuthService.instance.signOut();
            if (!context.mounted) return;
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const AuthGate()), (route) => false);
            return;
          }
          if (destination < 0 || destination > 15) return;
          Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => MainNavigationWrapper(
              initialIndex: destination <= 3 ? destination : 3,
              initialDestination: destination > 3 ? destination : null,
              returnToWelcomeMenuOnBack: true,
            )));
        },
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

class MemberProfileScreen extends StatefulWidget {
  const MemberProfileScreen({super.key});

  @override
  State<MemberProfileScreen> createState() => _MemberProfileScreenState();
}

class _MemberProfileScreenState extends State<MemberProfileScreen> {
  late Future<Map<String, dynamic>> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = LiveDataService.instance.fetchMemberProfile();
  }

  Future<void> _refresh() async {
    final next = LiveDataService.instance.fetchMemberProfile();
    setState(() => _profileFuture = next);
    await next;
  }

  bool _uploadingPhoto = false;
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickAndUploadPhoto() async {
    if (_uploadingPhoto) return;
    setState(() => _uploadingPhoto = true);
    Directory? temporaryDirectory;
    try {
      // Select first, then crop inside Flutter (no second native activity).
      final picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
        maxWidth: 1800,
        maxHeight: 1800,
      );
      if (picked == null || !mounted) return;

      final originalFile = File(picked.path);
      final originalBytes = await originalFile.readAsBytes();
      if (originalBytes.isEmpty || originalBytes.length > 10 * 1024 * 1024) {
        throw const FormatException('Please choose a valid image smaller than 10 MB.');
      }

      final croppedBytes = await Navigator.of(context).push<Uint8List>(
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) => ProfilePhotoCropScreen(imageBytes: originalBytes),
        ),
      );
      if (croppedBytes == null || !mounted) return;
      if (croppedBytes.isEmpty || croppedBytes.length > 5 * 1024 * 1024) {
        throw const FormatException('The cropped photo must be smaller than 5 MB.');
      }

      temporaryDirectory = await Directory.systemTemp.createTemp('octo7_profile_');
      final file = File('${temporaryDirectory.path}/profile_photo.jpg');
      await file.writeAsBytes(croppedBytes, flush: true);

      final signed = await AuthService.instance.invokeMemberAction(
        'profile_photo_upload_url',
        {'content_type': 'image/jpeg'},
      );
      final path = signed['path']?.toString() ?? '';
      final token = signed['token']?.toString() ?? '';
      if (path.isEmpty || token.isEmpty) {
        throw const FormatException('The server did not provide a secure photo upload URL.');
      }

      await Supabase.instance.client.storage
          .from('member-profile-photos')
          .uploadToSignedUrl(
            path,
            token,
            file,
            const FileOptions(contentType: 'image/jpeg', upsert: false),
          );

      await AuthService.instance.invokeMemberAction(
        'profile_photo_save',
        {'path': path},
      );
      await _refresh();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile photo cropped and updated successfully.')),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo upload failed: $error')),
      );
    } finally {
      if (temporaryDirectory != null) {
        try { await temporaryDirectory.delete(recursive: true); } catch (_) {}
      }
      if (mounted) setState(() => _uploadingPhoto = false);
    }
  }

  String _value(Map<String, dynamic> member, String key) {
    final value = member[key];
    if (value == null || value.toString().trim().isEmpty) return 'Not provided';
    return value.toString().trim();
  }

  String _memberId(dynamic value) {
    final id = (value ?? '').toString().trim();
    if (id.isEmpty) return 'OCTO7 ID unavailable';
    return id.toUpperCase().startsWith('OCTO7') ? id : 'OCTO7 $id';
  }

  Widget _detail(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF10243A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(children: [
        Icon(icon, color: const Color(0xFF10B981), size: 21),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        ])),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071321),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        title: const Text('My Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () async {
              final response = await _profileFuture;
              final member = response['member'] is Map
                  ? Map<String, dynamic>.from(response['member'])
                  : <String, dynamic>{};
              if (!context.mounted) return;
              final saved = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => MemberProfileEditScreen(member: member),
                ),
              );
              if (saved == true && mounted) await _refresh();
            },
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit profile details',
          ),
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh), tooltip: 'Refresh profile'),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF10B981)));
          }
          if (snapshot.hasError) {
            return Center(child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Icon(Icons.person_off_outlined, color: Colors.orangeAccent, size: 42),
                const SizedBox(height: 12),
                const Text('Unable to load your profile', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(snapshot.error.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.white60, fontSize: 12)),
                const SizedBox(height: 12),
                ElevatedButton.icon(onPressed: _refresh, icon: const Icon(Icons.refresh), label: const Text('Retry')),
              ]),
            ));
          }

          final response = snapshot.data ?? <String, dynamic>{};
          final member = response['member'] is Map
              ? Map<String, dynamic>.from(response['member'])
              : <String, dynamic>{};
          final status = _value(member, 'status');
          final active = status.toLowerCase() == 'active';
          final name = _value(member, 'full_name');
          final photoPath = (member['profile_photo_path'] ?? '').toString().trim();
          final rawPhoto = photoPath.isNotEmpty
              ? Supabase.instance.client.storage.from('member-profile-photos').getPublicUrl(photoPath)
              : (member['profile_photo_url'] ?? member['avatar_url'] ?? '').toString().trim();

          return RefreshIndicator(
            onRefresh: _refresh,
            color: const Color(0xFF10B981),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF123C35), Color(0xFF10243A)]),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF10B981).withOpacity(0.35)),
                  ),
                  child: Row(children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 39,
                          backgroundColor: const Color(0xFF10B981).withOpacity(0.18),
                          backgroundImage: rawPhoto.isEmpty ? null : NetworkImage(rawPhoto),
                          child: rawPhoto.isEmpty ? const Icon(Icons.person, color: Colors.white, size: 42) : null,
                        ),
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Material(
                            color: const Color(0xFF10B981),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _uploadingPhoto ? null : _pickAndUploadPhoto,
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: _uploadingPhoto
                                    ? const SizedBox(width: 15, height: 15, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                    : const Icon(Icons.camera_alt, size: 15, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(_memberId(member['member_id']), style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: (active ? const Color(0xFF10B981) : Colors.orange).withOpacity(0.16),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: active ? const Color(0xFF10B981) : Colors.orangeAccent),
                        ),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.circle, size: 8, color: active ? const Color(0xFF10B981) : Colors.orangeAccent),
                          const SizedBox(width: 6),
                          Text(status.toUpperCase(), style: TextStyle(color: active ? const Color(0xFF6EE7B7) : Colors.orangeAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                        ]),
                      ),
                    ])),
                  ]),
                ),
                const SizedBox(height: 22),
                const Text('PERSONAL INFORMATION', style: TextStyle(color: Color(0xFF6EE7B7), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.3)),
                const SizedBox(height: 12),
                _detail('Full name', name, Icons.person_outline),
                _detail('Email address', _value(member, 'email'), Icons.email_outlined),
                _detail('Mobile number', _value(member, 'phone'), Icons.phone_android),
                _detail('Sponsor ID', _memberId(member['sponsor_id']), Icons.people_outline),
                _detail('Placement parent ID', _memberId(member['placement_parent_id']), Icons.account_tree_outlined),
                _detail('Placement side', _value(member, 'placement_side').toUpperCase(), Icons.compare_arrows),
                _detail('Member since', _value(member, 'created_at'), Icons.calendar_today_outlined),
                const SizedBox(height: 6),
                const Text('Profile information is read from your authenticated OCTO7 account.', style: TextStyle(color: Colors.white38, fontSize: 11)),
              ],
            ),
          );
        },
      ),
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

// --- FOUR-GENERATION STEPPED BINARY GENEALOGY ---
class BinaryTreeViewScreen extends StatefulWidget {
  const BinaryTreeViewScreen({super.key, this.onBack});
  final VoidCallback? onBack;
  @override
  State<BinaryTreeViewScreen> createState() => _BinaryTreeViewScreenState();
}

class _BinaryTreeViewScreenState extends State<BinaryTreeViewScreen> {
  late Future<Map<String, dynamic>> _genealogyFuture;
  String? _rootMemberId;
  final List<String> _backStack = [];
  final TransformationController _transformController = TransformationController();

  static const double _canvasWidth = 420;
  static const double _canvasHeight = 760;
  static const List<double> _widths = [112, 92, 72, 44];
  static const List<double> _heights = [58, 50, 42, 36];
  static const List<double> _tops = [28, 128, 218, 300];
  static const double _minZoom = 0.65;
  static const double _maxZoom = 2.6;

  @override
  void initState() {
    super.initState();
    _genealogyFuture = LiveDataService.instance.fetchGenealogy();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _resetCameraToAnchor();
    });
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _resetCameraToAnchor() {
    if (!mounted) return;
    final screenWidth = MediaQuery.of(context).size.width;
    final offsetX = ((screenWidth - _canvasWidth) / 2).clamp(-200.0, 200.0);
    _transformController.value = Matrix4.identity()..translate(offsetX, 0.0);
  }

  void _zoom(double factor) {
    final current = _transformController.value.getMaxScaleOnAxis();
    final next = (current * factor).clamp(_minZoom, _maxZoom).toDouble();
    final screenWidth = MediaQuery.of(context).size.width;
    final offsetX = ((screenWidth - _canvasWidth * next) / 2).clamp(-200.0, 200.0);
    _transformController.value = Matrix4.identity()
      ..translate(offsetX, 0.0)
      ..scale(next);
  }

  void _reload({String? rootId}) {
    setState(() => _genealogyFuture = LiveDataService.instance.fetchGenealogy(rootMemberId: rootId));
  }

  Future<void> _openMember(String memberId) async {
    if (memberId.isEmpty || memberId == _rootMemberId) return;
    final previous = _rootMemberId;
    setState(() {
      if (previous != null && previous.isNotEmpty) _backStack.add(previous);
      _rootMemberId = memberId;
      _genealogyFuture = LiveDataService.instance.fetchGenealogy(rootMemberId: memberId);
    });
  }

  void _goBackOneLevel() {
    if (_backStack.isEmpty) return;
    final previous = _backStack.removeLast();
    setState(() {
      _rootMemberId = previous;
      _genealogyFuture = LiveDataService.instance.fetchGenealogy(rootMemberId: previous);
    });
  }

  void _handleBackPressed() {
    if (_backStack.isNotEmpty) {
      _goBackOneLevel();
    } else if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _returnToOwnId() {
    _backStack.clear();
    _rootMemberId = null;
    _reload();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _resetCameraToAnchor();
    });
  }

  Future<void> _openVacantPosition(int parentPositionId, String side) async {
    if (parentPositionId <= 0) return;
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => MemberRegistrationScreen(
        initialParentPositionId: parentPositionId,
        initialSide: side,
      ),
    ));
    if (mounted) _reload(rootId: _rootMemberId);
  }

  int _positionId(Map<String, dynamic> node) =>
      int.tryParse((node['id'] ?? '').toString()) ??
      int.tryParse((node['position_id'] ?? '').toString()) ?? 0;

  List<_PyramidSlot> _buildSlots(Map<String, dynamic> root) {
    final levels = <List<_PyramidSlot>>[[], [], [], []];
    void add(Map<String, dynamic>? node, int depth, int parentId, String side) {
      if (depth > 3) return;
      levels[depth].add(_PyramidSlot(
        node: node, level: depth, parentPositionId: parentId, side: side,
      ));
      if (depth == 3) return;
      if (node == null) {
        add(null, depth + 1, 0, 'left');
        add(null, depth + 1, 0, 'right');
        return;
      }
      final positionId = _positionId(node);
      final left = node['left'] is Map ? Map<String, dynamic>.from(node['left'] as Map) : null;
      final right = node['right'] is Map ? Map<String, dynamic>.from(node['right'] as Map) : null;
      add(left, depth + 1, positionId, 'left');
      add(right, depth + 1, positionId, 'right');
    }
    add(root, 0, 0, '');
    return levels.expand((level) => level).toList();
  }

  Widget _memberCard(_PyramidSlot slot) {
    final node = slot.node!;
    final memberId = (node['member_id'] ?? '').toString();
    final active = (node['status'] ?? '').toString().toLowerCase() == 'active';
    final isRoot = slot.level == 0;
    final compact = slot.level == 3;
    return Positioned(
      left: slot.x, top: _tops[slot.level],
      width: _widths[slot.level], height: _heights[slot.level],
      child: GestureDetector(
        onTap: memberId.isEmpty ? null : () => _openMember(memberId),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: compact ? 2 : 4, vertical: 2),
          decoration: BoxDecoration(
            color: isRoot ? const Color(0xFF102238) : Colors.white,
            borderRadius: BorderRadius.circular(compact ? 3 : 5),
            border: Border.all(
              color: isRoot ? const Color(0xFFD6A84B) : const Color(0xFF7040B5),
              width: isRoot ? 1.8 : 1.2,
            ),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1.5))],
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('OCTO7 ' + (memberId.isEmpty ? '—' : memberId),
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isRoot ? Colors.white : const Color(0xFF102238),
                fontSize: [10.5, 9.0, 7.5, 6.0][slot.level],
                fontWeight: FontWeight.bold,
              )),
            if (!compact || memberId.isNotEmpty)
              Text(active ? 'ACTIVE' : 'INACTIVE',
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isRoot
                      ? (active ? const Color(0xFF65E99A) : Colors.orangeAccent)
                      : (active ? const Color(0xFF168344) : Colors.redAccent),
                  fontSize: [8.5, 7.5, 6.5, 5.5][slot.level],
                  fontWeight: FontWeight.w700,
                )),
          ]),
        ),
      ),
    );
  }

  Widget _availableCard(_PyramidSlot slot) {
    final canRegister = slot.parentPositionId > 0;
    return Positioned(
      left: slot.x, top: _tops[slot.level],
      width: _widths[slot.level], height: _heights[slot.level],
      child: InkWell(
        onTap: canRegister ? () => _openVacantPosition(slot.parentPositionId, slot.side) : null,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: canRegister ? Colors.blueGrey.shade300 : Colors.white24),
          ),
          child: Center(child: Text(
            canRegister ? 'AVAILABLE' : '—',
            textAlign: TextAlign.center, maxLines: 1,
            style: TextStyle(
              color: canRegister ? const Color(0xFF7040B5) : Colors.black38,
              fontSize: [8, 7, 6, 5][slot.level],
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }

  Widget _pyramid(List<_PyramidSlot> slots) {
    for (int level = 0; level < 4; level++) {
      final row = slots.where((slot) => slot.level == level).toList();
      final sectorWidth = _canvasWidth / row.length;
      for (int i = 0; i < row.length; i++) {
        row[i].x = sectorWidth * i + sectorWidth / 2 - _widths[level] / 2;
      }
    }
    return SizedBox(
      width: _canvasWidth, height: _canvasHeight,
      child: CustomPaint(
        painter: _PyramidConnectorPainter(slots: slots),
        child: Stack(clipBehavior: Clip.none, children: [
          for (final slot in slots)
            if (slot.node != null) _memberCard(slot) else _availableCard(slot),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071426),
      appBar: AppBar(
        title: Text(_rootMemberId == null ? 'My Genealogy' : 'OCTO7 ' + _rootMemberId!,
          style: const TextStyle(color: Colors.white, fontSize: 18)),
        leading: IconButton(
          tooltip: 'Back to previous page',
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: _handleBackPressed,
        ),
        actions: [
          if (_backStack.isNotEmpty)
            IconButton(tooltip: 'Back one level', icon: const Icon(Icons.arrow_upward, color: Colors.amber), onPressed: _goBackOneLevel),
          IconButton(tooltip: 'Zoom out', icon: const Icon(Icons.remove, color: Colors.white), onPressed: () => _zoom(0.85)),
          IconButton(tooltip: 'Reset view', icon: const Icon(Icons.crop_free, color: Colors.white), onPressed: _resetCameraToAnchor),
          IconButton(tooltip: 'Zoom in', icon: const Icon(Icons.add, color: Colors.white), onPressed: () => _zoom(1.2)),
          IconButton(tooltip: 'Return to my ID', icon: const Icon(Icons.home_outlined, color: Colors.white), onPressed: _returnToOwnId),
          IconButton(tooltip: 'Refresh genealogy', icon: const Icon(Icons.refresh, color: Colors.white), onPressed: () => _reload(rootId: _rootMemberId)),
        ],
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
                Text('Unable to load genealogy: ' + snapshot.error.toString(),
                  textAlign: TextAlign.center, style: const TextStyle(color: Colors.orangeAccent)),
                TextButton(onPressed: () => _reload(rootId: _rootMemberId), child: const Text('Retry')),
              ]),
            ));
          }
          final data = snapshot.data ?? {};
          final rawNodes = data['nodes'];
          if (rawNodes is! List || rawNodes.isEmpty) {
            return const Center(child: Text('No genealogy positions were returned for this account.',
              style: TextStyle(color: Colors.white70)));
          }
          final root = LiveDataService.buildGenealogyTree(rawNodes);
          if (root == null) {
            return const Center(child: Text('Your genealogy root position could not be found.',
              style: TextStyle(color: Colors.white70)));
          }
          final returnedRootId = (data['root'] is Map
              ? data['root']['member_id'] : root['member_id'])?.toString();
          if (_rootMemberId == null && returnedRootId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _rootMemberId == null) setState(() => _rootMemberId = returnedRootId);
            });
          }
          final slots = _buildSlots(root);
          return Container(
            decoration: const BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
              colors: [Color(0xFF102A3B), Color(0xFF071426)],
            )),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Text('OCTO7 ' + (root['member_id'] ?? '').toString() +
                    '  •  Tap an ID to view its downline',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 11.5)),
              ),
              Expanded(child: InteractiveViewer(
                transformationController: _transformController,
                constrained: false, minScale: _minZoom, maxScale: _maxZoom,
                boundaryMargin: const EdgeInsets.all(180),
                child: _pyramid(slots),
              )),
              const Padding(
                padding: EdgeInsets.fromLTRB(12, 8, 12, 14),
                child: Text('Pinch to zoom • Tap AVAILABLE to register • Arrow returns one level',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white54, fontSize: 10)),
              ),
            ]),
          );
        },
      ),
    );
  }
}

class _PyramidSlot {
  _PyramidSlot({
    required this.node, required this.level,
    required this.parentPositionId, required this.side,
  });
  final Map<String, dynamic>? node;
  final int level;
  final int parentPositionId;
  final String side;
  double x = 0;
}

class _PyramidConnectorPainter extends CustomPainter {
  const _PyramidConnectorPainter({required this.slots});
  final List<_PyramidSlot> slots;

  @override
  void paint(Canvas canvas, Size size) {
    if (slots.length < 15) return;
    final paint = Paint()
      ..color = const Color(0xFF2C7A7B)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    for (int i = 0; i < 7; i++) {
      final parent = slots[i];
      final left = slots[2 * i + 1];
      final right = slots[2 * i + 2];
      final startX = parent.x + _width(parent.level) / 2;
      final startY = _top(parent.level) + _height(parent.level);
      final leftX = left.x + _width(left.level) / 2;
      final rightX = right.x + _width(right.level) / 2;
      final childY = _top(parent.level + 1);
      final middleY = startY + (childY - startY) / 2;
      final path = Path()
        ..moveTo(startX, startY)..lineTo(startX, middleY)
        ..moveTo(leftX, middleY)..lineTo(rightX, middleY)
        ..moveTo(leftX, middleY)..lineTo(leftX, childY)
        ..moveTo(rightX, middleY)..lineTo(rightX, childY);
      canvas.drawPath(path, paint);
    }
  }

  static double _width(int level) => [112.0, 92.0, 72.0, 44.0][level];
  static double _height(int level) => [58.0, 50.0, 42.0, 36.0][level];
  static double _top(int level) => [28.0, 128.0, 218.0, 300.0][level];

  @override
  bool shouldRepaint(covariant _PyramidConnectorPainter oldDelegate) => true;
}

class _TidyPlacement {
  const _TidyPlacement({
    required this.node, required this.x, required this.depth,
    this.parentPositionId = 0, this.side,
  });
  final Map<String, dynamic>? node;
  final double x;
  final int depth;
  final int parentPositionId;
  final String? side;
  _TidyPlacement shifted(double dx, int depthOffset) => _TidyPlacement(
    node: node, x: x + dx, depth: depth + depthOffset,
    parentPositionId: parentPositionId, side: side,
  );
}

class _TidySubtree {
  const _TidySubtree({
    required this.rootX, required this.placements,
    required this.leftContour, required this.rightContour,
  });
  final double rootX;
  final List<_TidyPlacement> placements;
  final Map<int, double> leftContour;
  final Map<int, double> rightContour;
}

class _TidyRenderData {
  const _TidyRenderData({
    required this.placements, required this.minX,
    required this.width, required this.height,
  });
  final List<_TidyPlacement> placements;
  final double minX;
  final double width;
  final double height;
}

class _TidyEdge {
  const _TidyEdge({
    required this.fromX, required this.fromY,
    required this.toX, required this.toY,
  });
  final double fromX, fromY, toX, toY;
}

class _TidyConnectorPainter extends CustomPainter {
  const _TidyConnectorPainter(this.edges);
  final List<_TidyEdge> edges;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF18A77C)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    for (final edge in edges) {
      final middleY = (edge.fromY + edge.toY) / 2;
      final path = Path()
        ..moveTo(edge.fromX, edge.fromY)
        ..lineTo(edge.fromX, middleY)
        ..lineTo(edge.toX, middleY)
        ..lineTo(edge.toX, edge.toY);
      canvas.drawPath(path, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _TidyConnectorPainter oldDelegate) =>
      !identical(oldDelegate.edges, edges);
}

class _BinaryBranchPainter extends CustomPainter {
  const _BinaryBranchPainter({
    required this.parentCenter,
    required this.leftCenter,
    required this.rightCenter,
  });

  final double parentCenter;
  final double leftCenter;
  final double rightCenter;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF18A77C)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final midY = size.height / 2;
    final path = Path()
      ..moveTo(parentCenter, 0)
      ..lineTo(parentCenter, midY)
      ..moveTo(leftCenter, midY)
      ..lineTo(rightCenter, midY)
      ..moveTo(leftCenter, midY)
      ..lineTo(leftCenter, size.height)
      ..moveTo(rightCenter, midY)
      ..lineTo(rightCenter, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BinaryBranchPainter oldDelegate) =>
      oldDelegate.parentCenter != parentCenter ||
      oldDelegate.leftCenter != leftCenter ||
      oldDelegate.rightCenter != rightCenter;
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


class MemberDashboardScreen extends StatefulWidget {
  const MemberDashboardScreen({super.key});

  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  late Future<Map<String, dynamic>> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = WalletService.instance.fetchDashboard();
  }

  Future<void> _refreshDashboard() async {
    final next = WalletService.instance.fetchDashboard();
    setState(() => _dashboardFuture = next);
    await next;
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
                future: _dashboardFuture,
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
                  final photoPath = (member['profile_photo_path'] ?? '').toString().trim();
                  final photoUrl = photoPath.isNotEmpty
                      ? Supabase.instance.client.storage.from('member-profile-photos').getPublicUrl(photoPath)
                      : (member['profile_photo_url'] ?? member['avatar_url'] ?? '').toString().trim();
                  return Row(children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: const Color(0xFF10B981),
                      backgroundImage: photoUrl.isNotEmpty ? NetworkImage(photoUrl) : null,
                      child: photoUrl.isEmpty
                          ? const Icon(Icons.person, size: 35, color: Colors.white)
                          : null,
                    ),
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
            const SizedBox(height: 14),
            FutureBuilder<Map<String, dynamic>>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                final binary = snapshot.data?['binary'] is Map
                    ? Map<String, dynamic>.from(snapshot.data!['binary'])
                    : <String, dynamic>{};
                final left = binary['left_child'] is Map
                    ? Map<String, dynamic>.from(binary['left_child'])
                    : <String, dynamic>{};
                final right = binary['right_child'] is Map
                    ? Map<String, dynamic>.from(binary['right_child'])
                    : <String, dynamic>{};
                String slotText(Map<String, dynamic> child) {
                  if (child.isEmpty) return 'Available';
                  final id = (child['member_id'] ?? '').toString();
                  final status = (child['status'] ?? 'registered').toString();
                  return 'OCTO7 $id • $status';
                }
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF060D1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('My Binary Positions',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(height: 10),
                      Row(children: [
                        Expanded(child: _metricCard('LEFT POSITION',
                          snapshot.hasError ? 'Unavailable' : slotText(left),
                          Icons.account_tree, Colors.blue)),
                        const SizedBox(width: 10),
                        Expanded(child: _metricCard('RIGHT POSITION',
                          snapshot.hasError ? 'Unavailable' : slotText(right),
                          Icons.account_tree, Colors.green)),
                      ]),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            FutureBuilder<Map<String, dynamic>>(
              future: _dashboardFuture,
              builder: (context, snapshot) {
                final coupon = snapshot.data?['coupon'] is Map
                    ? Map<String, dynamic>.from(snapshot.data!['coupon'])
                    : <String, dynamic>{};
                if (snapshot.hasError) return const SizedBox.shrink();
                final face = coupon['face_value'];
                final perPurchase = coupon['per_purchase'];
                final maxUses = coupon['max_uses'];
                final used = coupon['used_count'] ?? 0;
                final remaining = maxUses == null
                    ? null
                    : ((int.tryParse('$maxUses') ?? 0) - (int.tryParse('$used') ?? 0)).clamp(0, 999999);
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF060D1A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFD97706).withOpacity(0.45)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('My Purchase Coupon',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 8),
                    Text(coupon.isEmpty ? 'No coupon issued for this Member ID yet'
                      : 'Value: ₹${face ?? '—'}  •  Per eligible purchase: ₹${perPurchase ?? '—'}',
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                    if (remaining != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text('Redemptions remaining: $remaining',
                          style: const TextStyle(color: Color(0xFFD6A84B), fontSize: 12)),
                      ),
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


/// In-app profile-photo cropper. It stays in Flutter and does not launch
/// Android's external crop activity, avoiding the crash seen in earlier builds.
class ProfilePhotoCropScreen extends StatefulWidget {
  const ProfilePhotoCropScreen({super.key, required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<ProfilePhotoCropScreen> createState() => _ProfilePhotoCropScreenState();
}

class _ProfilePhotoCropScreenState extends State<ProfilePhotoCropScreen> {
  final CropController _cropController = CropController();
  bool _isCropping = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071321),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B192C),
        title: const Text('Adjust profile photo'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isCropping ? null : () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(
                'Move and zoom the photo inside the circle. Your saved photo will be square and display as a circle.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Crop(
                  image: widget.imageBytes,
                  controller: _cropController,
                  aspectRatio: 1,
                  withCircleUi: true,
                  interactive: true,
                  fixCropRect: true,
                  radius: 180,
                  baseColor: const Color(0xFF071321),
                  maskColor: Colors.black.withOpacity(0.62),
                  cornerDotBuilder: (size, edgeAlignment) =>
                      const DotControl(color: Color(0xFF10B981)),
                  progressIndicator: const CircularProgressIndicator(
                    color: Color(0xFF10B981),
                  ),
                  onCropped: (result) {
                    if (!mounted) return;
                    switch (result) {
                      case CropSuccess(:final croppedImage):
                        Navigator.of(context).pop<Uint8List>(croppedImage);
                        return;
                      case CropFailure(:final cause):
                        setState(() => _isCropping = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not crop photo: $cause')),
                        );
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isCropping
                      ? null
                      : () {
                          setState(() => _isCropping = true);
                          _cropController.crop();
                        },
                  icon: _isCropping
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline),
                  label: Text(_isCropping ? 'Cropping…' : 'Crop and use photo'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
