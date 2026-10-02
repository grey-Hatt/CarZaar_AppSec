import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../authentication/login.dart';
import '../connects/connects_wallet.dart';
import '../providers/app_provider.dart';
import '../reports/my_reports.dart';
import '../reports/seller_reports.dart';
import '../user_profile/profile_screen.dart';
import 'buyer_screen.dart';
import 'seller_screen.dart';

class MainHome extends StatelessWidget {
  const MainHome({super.key});

  void open(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  void logout(BuildContext context) {
    context.read<AppProvider>().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Login()),
      (_) => false,
    );
  }

  Widget logo() => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.directions_car, color: Colors.orange, size: 32),
          SizedBox(width: 8),
          Text(
            'CarZaar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  Widget navButton(String title, VoidCallback onTap) => TextButton(
        onPressed: onTap,
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget drawerItem(BuildContext context, IconData icon, String title, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        open(context, page);
      },
    );
  }

  Widget footerItem(String title, String detail, bool mobile) {
    return SizedBox(
      width: mobile ? double.infinity : 240,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              detail,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget modeButton({
    required IconData icon,
    required String title,
    required Color bg,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: 180,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(title),
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AppProvider>().currentUser;
    final width = MediaQuery.of(context).size.width;
    final mobile = width < 700;

    return Scaffold(
      appBar: mobile
          ? AppBar(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              title: logo(),
            )
          : null,
      drawer: mobile
          ? Drawer(
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      color: Colors.black,
                      child: logo(),
                    ),
                    drawerItem(context, Icons.person, 'User Profile', const UProfile()),
                    drawerItem(context, Icons.account_balance_wallet, 'Connects', const ConnectsWallet()),
                    drawerItem(context, Icons.report_gmailerrorred, 'My Complaints', const MyReports()),
                    drawerItem(context, Icons.report, 'Reports on My Listings', const SellerReports()),
                    const Spacer(),
                    ListTile(
                      leading: const Icon(Icons.logout, color: Colors.red),
                      title: const Text('Logout'),
                      onTap: () => logout(context),
                    ),
                  ],
                ),
              ),
            )
          : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (!mobile)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                color: Colors.black,
                child: Row(
                  children: [
                    logo(),
                    const Spacer(),
                    navButton('Home', () {}),
                    navButton('User Profile', () => open(context, const UProfile())),
                    navButton('Connects', () => open(context, const ConnectsWallet())),
                    navButton('My Complaints', () => open(context, const MyReports())),
                    navButton('Reports on My Listings', () => open(context, const SellerReports())),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => logout(context),
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

            Container(
              // minHeight (not a fixed height) so the text never overflows
              // on small phones or with a large system font size.
              constraints: BoxConstraints(minHeight: mobile ? 560 : 520),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: const NetworkImage(
                    'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1600&q=70',
                  ),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
              child: Container(
                color: Colors.black.withValues(alpha: 0.58),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(mobile ? 18 : 24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user == null ? 'Welcome to CarZaar' : 'Welcome, ${user.name}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mobile ? 20 : 26,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'CarZaar - Where Car Meets Best Prices',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: mobile ? 30 : 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bid smartly, sell confidently, and connect with real car buyers and sellers.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: mobile ? 15 : 18,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Wrap(
                            spacing: 16,
                            runSpacing: 14,
                            alignment: WrapAlignment.center,
                            children: [
                              modeButton(
                                icon: Icons.shopping_cart,
                                title: 'Buyer Mode',
                                bg: Colors.orange,
                                onTap: () {
                                  context.read<AppProvider>().switchRole('buyer');
                                  open(context, const BuyerScreen());
                                },
                              ),
                              modeButton(
                                icon: Icons.sell,
                                title: 'Seller Mode',
                                bg: Colors.white,
                                onTap: () {
                                  context.read<AppProvider>().switchRole('seller');
                                  open(context, const SellerScreen());
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(mobile ? 22 : 30),
              color: Colors.grey.shade100,
              child: Column(
                children: [
                  Text(
                    'Why Choose CarZaar?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: mobile ? 24 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'CarZaar helps buyers and sellers connect through a smart bidding system. Sellers list cars, buyers place bids, and communication happens after bid acceptance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 18,
                    runSpacing: 8,
                    children: [
                      footerItem('About CarZaar', 'A car bidding platform where sellers list vehicles and buyers compete with the best offers.', mobile),
                      footerItem('Features', 'Car listing, bidding, connects wallet, WhatsApp contact, reports, and seller/buyer modes.', mobile),
                      footerItem('Business Model', 'Users buy connects and spend them on featured listings and contact unlock.', mobile),
                      footerItem('Support', 'Users can report fake listings, wrong details, fraud bids, and meeting issues.', mobile),
                    ],
                  ),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 10),
                  const Text(
                    '© 2026 CarZaar. All rights reserved.',
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
