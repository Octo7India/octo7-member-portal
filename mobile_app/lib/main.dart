import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/supabase_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase is initialized only when public project configuration is
  // supplied at build time. No service-role key belongs in this app.
  if (SupabaseConfig.isConfigured) {
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
            Image.asset(
              'assets/images/OCTO7_emblem_transparent-2.png',
              width: 260,
              height: 260,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.image_not_supported,
                color: Colors.white70,
                size: 80,
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
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  _memberNode('You (Rajesh)', 'OCT7-89210', const Color(0xFFD97706), true),
                  _connectorVertical(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(width: 140, height: 2, color: Colors.white54),
                    ],
                  ),
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
                                  _emptySlotNode(context),
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
                                  _emptySlotNode(context),
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

  static Widget _emptySlotNode(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MemberRegistrationScreen()));
      },
      child: Container(
        width: 90,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white30, style: BorderStyle.solid),
        ),
        child: Column(
          children: const [
            Icon(Icons.add_circle_outline, color: Color(0xFF10B981), size: 22),
            SizedBox(height: 4),
            Text('Add Member', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// --- MULTI-SECTOR PRODUCT CATALOG SCREEN ---
class ProductCatalogScreen extends StatefulWidget {
  const ProductCatalogScreen({super.key});

  @override
  State<ProductCatalogScreen> createState() => _ProductCatalogScreenState();
}

class _ProductCatalogScreenState extends State<ProductCatalogScreen> {
  int _selectedCategoryIndex = 0;
  final List<Map<String, dynamic>> _cartItems = [];

  final List<String> _categories = ['All Sectors', 'Apparel & Dress', 'IT Solutions', 'Dining Vouchers', 'Saloon & Spa'];

  final List<Map<String, dynamic>> _products = [
    {
      'title': 'Premium Cotton Dress Combo',
      'category': 'Apparel & Dress',
      'price': 2499,
      'pv': 50,
      'icon': Icons.checkroom,
      'color': Colors.deepOrangeAccent,
    },
    {
      'title': 'Stitched Designer Salwar Set',
      'category': 'Apparel & Dress',
      'price': 1899,
      'pv': 35,
      'icon': Icons.dry_cleaning,
      'color': Colors.pinkAccent,
    },
    {
      'title': 'OCTO7 POS & Billing Software',
      'category': 'IT Solutions',
      'price': 4999,
      'pv': 120,
      'icon': Icons.laptop_mac,
      'color': Colors.blueAccent,
    },
    {
      'title': 'OCTO7 Dining Privilege Card',
      'category': 'Dining Vouchers',
      'price': 1200,
      'pv': 25,
      'icon': Icons.restaurant,
      'color': Colors.amber,
    },
    {
      'title': 'Luxury Spa & Salon Pass',
      'category': 'Saloon & Spa',
      'price': 1500,
      'pv': 30,
      'icon': Icons.spa,
      'color': Colors.tealAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredProducts = _selectedCategoryIndex == 0
        ? _products
        : _products.where((p) => p['category'] == _categories[_selectedCategoryIndex]).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('OCTO7 Products Catalog', style: TextStyle(color: Colors.white, fontSize: 18)),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart, color: Color(0xFFD97706)),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartCheckoutScreen(cartItems: _cartItems),
                    ),
                  );
                },
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text(
                      '${_cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 55,
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: const Color(0xFF060D1A),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final isSelected = _selectedCategoryIndex == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(_categories[index]),
                    selected: isSelected,
                    selectedColor: const Color(0xFFD97706),
                    backgroundColor: Colors.white10,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey.shade300,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() => _selectedCategoryIndex = index);
                    },
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final item = filteredProducts[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF060D1A),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          child: Center(
                            child: Icon(item['icon'] as IconData, size: 50, color: item['color'] as Color),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('₹ ${item['price']}', style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${item['pv']} PV',
                                    style: const TextStyle(color: Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 30,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD97706),
                                  padding: EdgeInsets.zero,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _cartItems.add(item);
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${item['title']} added to cart!')),
                                  );
                                },
                                child: const Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 11)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- CART & CHECKOUT SCREEN ---
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

  final List<Map<String, dynamic>> _transactions = const [
    {
      'title': 'Federal Bank Withdrawal',
      'date': 'Oct 24, 2026',
      'amount': '- ₹ 12,000.00',
      'type': 'Payout',
      'status': 'Credited',
      'color': Colors.greenAccent,
      'icon': Icons.account_balance,
    },
    {
      'title': 'Binary Matching Bonus',
      'date': 'Oct 21, 2026',
      'amount': '+ ₹ 8,400.00',
      'type': 'Commission',
      'status': 'Completed',
      'color': Color(0xFF10B981),
      'icon': Icons.account_tree,
    },
    {
      'title': 'Direct Sponsor Income (Aarav S.)',
      'date': 'Oct 18, 2026',
      'amount': '+ ₹ 1,250.00',
      'type': 'Referral',
      'status': 'Completed',
      'color': Color(0xFF10B981),
      'icon': Icons.person_add_alt_1,
    },
    {
      'title': 'Federal Bank Withdrawal',
      'date': 'Oct 12, 2026',
      'amount': '- ₹ 15,000.00',
      'type': 'Payout',
      'status': 'Credited',
      'color': Colors.greenAccent,
      'icon': Icons.account_balance,
    },
    {
      'title': 'Apparel Sector Team Bonus',
      'date': 'Oct 05, 2026',
      'amount': '+ ₹ 4,200.00',
      'type': 'Sector Bonus',
      'status': 'Completed',
      'color': Color(0xFF10B981),
      'icon': Icons.shopping_bag,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Commission & Payout History', style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _transactions.length,
        itemBuilder: (context, index) {
          final tx = _transactions[index];
          final isPayout = tx['type'] == 'Payout';

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF060D1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: isPayout ? Colors.amber.withOpacity(0.2) : const Color(0xFF10B981).withOpacity(0.2),
                  child: Icon(tx['icon'] as IconData, color: isPayout ? const Color(0xFFD97706) : const Color(0xFF10B981), size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tx['title'] as String, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 3),
                      Text('${tx['date']} • ${tx['type']}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      tx['amount'] as String,
                      style: TextStyle(
                        color: isPayout ? const Color(0xFFD97706) : const Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tx['status'] as String,
                        style: const TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- RANK ADVANCEMENT & QUALIFICATION SCREEN ---
class RankTrackerScreen extends StatelessWidget {
  const RankTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Rank Advancement Tracker', style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF060D1A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFD97706)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.workspace_premium, size: 45, color: Color(0xFFD97706)),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Current Rank: Gold Executive', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('Next Target: Pearl Executive', style: TextStyle(color: Color(0xFF10B981), fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Qualification Progress', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _rankProgressCard('Left Leg BV Requirement', 12400, 20000, Colors.blue),
            const SizedBox(height: 10),
            _rankProgressCard('Right Leg BV Requirement', 15800, 20000, Colors.green),
            const SizedBox(height: 10),
            _rankProgressCard('Personal Purchase PV', 3200, 5000, Colors.amber),
            const SizedBox(height: 25),
            const Text('OCTO7 Executive Ranks Hierarchy', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _rankHierarchyItem('Gold Executive', 'Active Rank', '10,000 BV Pair', true),
            _rankHierarchyItem('Pearl Executive', '62% Completed', '20,000 BV Pair', false),
            _rankHierarchyItem('Ruby Executive', 'Locked', '50,000 BV Pair', false),
            _rankHierarchyItem('Diamond Executive', 'Locked', '100,000 BV Pair', false),
          ],
        ),
      ),
    );
  }

  static Widget _rankProgressCard(String label, int current, int target, Color color) {
    double progress = (current / target).clamp(0.0, 1.0);
    int percentage = (progress * 100).round();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF060D1A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              Text('$percentage%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text('$current / $target BV', style: const TextStyle(color: Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  static Widget _rankHierarchyItem(String rank, String status, String requirement, bool isCurrent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCurrent ? const Color(0xFF064E3B) : const Color(0xFF060D1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isCurrent ? const Color(0xFF10B981) : Colors.white12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(isCurrent ? Icons.check_circle : Icons.stars, color: isCurrent ? const Color(0xFF10B981) : Colors.grey, size: 20),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(rank, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(requirement, style: const TextStyle(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ],
          ),
          Text(status, style: TextStyle(color: isCurrent ? const Color(0xFF10B981) : Colors.white54, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// --- MEMBER REGISTRATION SCREEN ---
class MemberRegistrationScreen extends StatefulWidget {
  const MemberRegistrationScreen({super.key});

  @override
  State<MemberRegistrationScreen> createState() => _MemberRegistrationScreenState();
}

class _MemberRegistrationScreenState extends State<MemberRegistrationScreen> {
  String _selectedLeg = 'Left Leg';
  String _selectedPackage = 'Apparel & Dress Starter (₹2,499)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF052411),
      appBar: AppBar(
        backgroundColor: const Color(0xFF060D1A),
        title: const Text('Register New Member', style: TextStyle(color: Colors.white, fontSize: 18)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sponsor Details', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            _buildTextField('Sponsor ID', 'OCT7-89210 (Rajesh Kumar)', true),
            const SizedBox(height: 15),
            
            const Text('Placement Leg', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Left Leg', style: TextStyle(color: Colors.white, fontSize: 14)),
                    value: 'Left Leg',
                    groupValue: _selectedLeg,
                    activeColor: const Color(0xFF10B981),
                    onChanged: (val) => setState(() => _selectedLeg = val!),
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Right Leg', style: TextStyle(color: Colors.white, fontSize: 14)),
                    value: 'Right Leg',
                    groupValue: _selectedLeg,
                    activeColor: const Color(0xFF10B981),
                    onChanged: (val) => setState(() => _selectedLeg = val!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            const Text('New Member Personal Info', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            _buildTextField('Full Name', 'Enter full legal name', false),
            const SizedBox(height: 12),
            _buildTextField('Mobile Number', 'Enter 10-digit mobile number', false),
            const SizedBox(height: 12),
            _buildTextField('Email Address', 'Enter email address', false),
            const SizedBox(height: 15),

            const Text('Select Starter Package', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF060D1A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedPackage,
                  dropdownColor: const Color(0xFF060D1A),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  isExpanded: true,
                  items: [
                    'Apparel & Dress Starter (₹2,499)',
                    'IT Solutions Starter (₹4,999)',
                    'Dining Privilege Starter (₹1,200)',
                    'Saloon & Spa Starter (₹1,500)',
                  ].map((pkg) => DropdownMenuItem(value: pkg, child: Text(pkg))).toList(),
                  onChanged: (val) => setState(() => _selectedPackage = val!),
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Member Registered Successfully!')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Complete Registration & Generate ID', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTextField(String label, String hint, bool isReadOnly) {
    return TextField(
      readOnly: isReadOnly,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFF060D1A),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.white24)),
      ),
    );
  }
}

// --- MEMBER BACK-OFFICE & DASHBOARD SCREEN ---
class MemberDashboardScreen extends StatelessWidget {
  const MemberDashboardScreen({super.key});

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
                const Text('Available Balance: ₹ 45,850.00', style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.bold, fontSize: 14)),
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
            Row(
              children: [
                Expanded(child: _metricCard('Left Team BV', '12,400', Icons.trending_up, Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _metricCard('Right Team BV', '15,800', Icons.trending_up, Colors.green)),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RankTrackerScreen()));
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF060D1A),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFD97706).withOpacity(0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Rank Qualification Progress', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('62%', style: TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: 0.62,
                      backgroundColor: Colors.white10,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD97706)),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    const SizedBox(height: 6),
                    const Text('Tap to view next target: Pearl Executive', style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ],
                ),
              ),
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
