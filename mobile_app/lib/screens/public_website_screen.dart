import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Native public-facing OCTO7 website pages for the Android app.
/// Content follows the public sections in the OCTO7 India website.
class PublicWebsiteScreen extends StatefulWidget {
  const PublicWebsiteScreen({super.key, required this.onMemberLogin});
  final VoidCallback onMemberLogin;

  @override
  State<PublicWebsiteScreen> createState() => _PublicWebsiteScreenState();
}

class _PublicWebsiteScreenState extends State<PublicWebsiteScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  static const _navy = Color(0xFF11152E);
  static const _green = Color(0xFF25D366);
  static const _gold = Color(0xFFD6B46A);
  static const _purple = Color(0xFF7040B5);

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _contactEmail() async {
    await Clipboard.setData(const ClipboardData(text: 'octo7india@gmail.com'));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email address copied: octo7india@gmail.com')),
      );
    }
  }

  Widget _brand({double size = 22}) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: size * .9, height: size * .9,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: size * .09),
        ),
        child: Text('🌎', style: TextStyle(fontSize: size * .55, height: 1)),
      ),
      const SizedBox(width: 3),
      Text('CTO', style: TextStyle(color: Colors.white, fontSize: size,
        fontWeight: FontWeight.w900, letterSpacing: .5, height: 1)),
      Text('7', style: TextStyle(color: _gold, fontSize: size,
        fontWeight: FontWeight.w900, height: 1)),
      const SizedBox(width: 5),
      Text('India', style: TextStyle(color: Colors.white,
        fontSize: size * .58, fontWeight: FontWeight.w700, height: 1)),
    ]);
  }

  Widget _sectionTitle(String title, {Color color = _navy}) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(title, textAlign: TextAlign.center,
      style: TextStyle(color: color, fontSize: 27, fontWeight: FontWeight.w800)),
  );

  Widget _bodyText(String text, {Color color = const Color(0xFF505050)}) =>
      Text(text, textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 15, height: 1.65));

  Widget _page(Widget child, {Color background = const Color(0xFFF4FFF7)}) =>
      Container(
        color: background,
        width: double.infinity,
        child: SafeArea(child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 34),
          child: Center(child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: child,
          )),
        )),
      );

  Widget _actionButton(String label, VoidCallback action, {bool secondary = false}) =>
      OutlinedButton(
        onPressed: action,
        style: OutlinedButton.styleFrom(
          backgroundColor: secondary ? Colors.transparent : _gold,
          foregroundColor: secondary ? Colors.white : _navy,
          side: BorderSide(color: secondary ? Colors.white : _gold),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        ),
        child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _homePage() => LayoutBuilder(
    builder: (context, constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;
      return Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_bg.png',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF001B54), Color(0xFF0064D8)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'WELCOME',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (width * 0.065).clamp(20.0, 29.0).toDouble(),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.2,
                  shadows: const [
                    Shadow(color: Colors.black87, blurRadius: 8, offset: Offset(0, 2)),
                  ],
                ),
              ),
            ),
          ),
          // Transparent hit target connects the artwork's Member Login button
          // to the existing member authentication flow.
          Positioned(
            left: width * 0.06,
            right: width * 0.06,
            top: height * 0.695,
            height: height * 0.085,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onMemberLogin,
                borderRadius: BorderRadius.circular(48),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      );
    },
  );

  Widget _infoCard(IconData icon, String heading, String text) => Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 13),
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [BoxShadow(color: Color(0x12000000), blurRadius: 12, offset: Offset(0, 4))]),
    child: Column(children: [
      Icon(icon, size: 38, color: _purple),
      const SizedBox(height: 9),
      Text(heading, textAlign: TextAlign.center,
        style: const TextStyle(color: _purple, fontSize: 18, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      _bodyText(text),
    ]),
  );

  Widget _aboutPage() => _page(Column(children: [
    _sectionTitle('About OCTO7 India'),
    _bodyText('OCTO7 India is a developing business network focused on bringing people and product categories together through a member-based platform. Our vision is to build a professional network with a customer-first approach, quality products and responsible business practices.'),
    const SizedBox(height: 24),
    _infoCard(Icons.public, 'Our Vision',
      'To build a connected business network with a wider reach.'),
    _infoCard(Icons.handshake_outlined, 'Our Mission',
      'To support members through products, service and collaboration.'),
    _infoCard(Icons.star_outline, 'Our Values',
      'Trust, transparency, responsibility and customer satisfaction.'),
  ]));

  Widget _productCard(String emoji, String title, String description) =>
      Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(color: Colors.white,
          borderRadius: BorderRadius.circular(13),
          boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 9, offset: Offset(0, 3))]),
        child: Column(children: [
          Text(emoji, style: const TextStyle(fontSize: 34)),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center,
            style: const TextStyle(color: _purple, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 5),
          Text(description, textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF555555), fontSize: 12, height: 1.4)),
        ]),
      );

  Widget _productsPage() => _page(Column(children: [
    _sectionTitle('Our Products'),
    _bodyText('Explore our range of product categories. Product availability and details will be updated on the member platform.'),
    const SizedBox(height: 22),
    GridView.count(
      crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.13,
      children: const [
        _PublicProductTile(emoji: '👗', title: 'Garments', description: "Ladies' and gents' clothing and casual wear."),
        _PublicProductTile(emoji: '💎', title: 'Imitation Ornaments', description: 'Fashion jewellery and imitation ornaments.'),
        _PublicProductTile(emoji: '🏠', title: 'Home Care', description: 'Products for everyday home care.'),
        _PublicProductTile(emoji: '🧴', title: 'Personal Care', description: 'Personal care and grooming products.'),
        _PublicProductTile(emoji: '🌿', title: 'Health & Wellness', description: 'Health and wellness product categories.'),
        _PublicProductTile(emoji: '🥗', title: 'Nutrition', description: 'Nutrition-related product categories.'),
        _PublicProductTile(emoji: '🌶️', title: 'Spices', description: 'Spices and selected food ingredients.'),
        _PublicProductTile(emoji: '🥫', title: 'Food & Beverages', description: 'Packed foods and beverage products.'),
      ],
    ),
    const SizedBox(height: 14),
    _bodyText('Product availability and details will be updated on the member platform.'),
  ]));

  Widget _opportunityPage() => _page(Column(children: [
    _sectionTitle('Business Opportunity'),
    _bodyText('Discover the OCTO7 member platform and learn about its product, customer and business activities. Members can access their accounts through the secure member login.'),
    const SizedBox(height: 22),
    _infoCard(Icons.shopping_bag_outlined, 'Product-focused network',
      'Explore product categories and customer-focused business activities.'),
    _infoCard(Icons.groups_outlined, 'Member community',
      'Connect with a growing network and access member services through the OCTO7 platform.'),
    _infoCard(Icons.verified_user_outlined, 'Responsible participation',
      'Participation is subject to OCTO7 India’s official terms and policies.'),
    const SizedBox(height: 12),
    _actionButton('MEMBER LOGIN', widget.onMemberLogin),
  ]));

  Widget _contactPage() => _page(Column(children: [
    _sectionTitle('Contact OCTO7 India'),
    _bodyText('For membership, product and business enquiries, contact our team.'),
    const SizedBox(height: 24),
    Container(
      width: double.infinity, padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(children: [
        const Icon(Icons.email_outlined, color: _purple, size: 42),
        const SizedBox(height: 12),
        const Text('Email', style: TextStyle(color: _navy, fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 6),
        InkWell(onTap: _contactEmail,
          child: const Text('octo7india@gmail.com',
            style: TextStyle(color: _purple, fontSize: 16, decoration: TextDecoration.underline))),
        const SizedBox(height: 14),
        _actionButton('EMAIL OCTO7', _contactEmail),
      ]),
    ),
  ]));

  @override
  Widget build(BuildContext context) {
    const labels = ['Home', 'About Us', 'Products', 'Opportunity', 'Contact'];
    return Scaffold(
      backgroundColor: _green,
      appBar: AppBar(
        backgroundColor: _navy,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: TabBar(
            controller: _tabs, isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorColor: _gold, indicatorWeight: 3,
            labelColor: Colors.white, unselectedLabelColor: Colors.white70,
            tabs: labels.map((label) => Tab(text: label)).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabs,
        children: [_homePage(), _aboutPage(), _productsPage(), _opportunityPage(), _contactPage()],
      ),
    );
  }
}

class _PublicProductTile extends StatelessWidget {
  const _PublicProductTile({required this.emoji, required this.title, required this.description});
  final String emoji;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(13),
      boxShadow: const [BoxShadow(color: Color(0x10000000), blurRadius: 9, offset: Offset(0, 3))]),
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(emoji, style: const TextStyle(fontSize: 34)),
      const SizedBox(height: 8),
      Text(title, textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF7040B5), fontWeight: FontWeight.bold, fontSize: 15)),
      const SizedBox(height: 5),
      Text(description, textAlign: TextAlign.center,
        style: const TextStyle(color: Color(0xFF555555), fontSize: 12, height: 1.4)),
    ]),
  );
}
