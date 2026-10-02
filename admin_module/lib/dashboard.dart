import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';
import 'package:carzaar_admin/authentication/admin_login.dart';
import 'package:carzaar_admin/user_management/view_users.dart';
import 'package:carzaar_admin/car_listing_monitoring/view_listings.dart';
import 'package:carzaar_admin/bid_monitoring/view_bids.dart';
import 'package:carzaar_admin/report_complaint/view_report.dart';
import 'package:carzaar_admin/system_analytics/user_stats.dart';
import 'package:carzaar_admin/system_analytics/listing_stats.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool loading = true;
  int users = 0, cars = 0, bids = 0, reports = 0;

  @override
  void initState() {
    super.initState();
    loadCounts();
  }

  Future<void> loadCounts() async {
    try {
      // Run the four queries in parallel instead of one after another.
      final results = await Future.wait([
        supabase.from('users').select('id'),
        supabase.from('cars').select('id'),
        supabase.from('bids').select('id'),
        supabase.from('reports').select('id'),
      ]);
      if (!mounted) return;
      setState(() {
        users = results[0].length;
        cars = results[1].length;
        bids = results[2].length;
        reports = results[3].length;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Widget stat(String title, int value, IconData icon) => adminCard(
        child: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.deepOrange, child: Icon(icon, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$value', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(title, style: const TextStyle(color: Colors.white60)),
              ]),
            ),
          ],
        ),
      );

  Widget module(BuildContext context, String title, String sub, IconData icon, Widget page) => adminCard(
        child: ListTile(
          leading: CircleAvatar(backgroundColor: Colors.deepOrange, child: Icon(icon, color: Colors.white)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(sub),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
            loadCounts();
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarZaar Admin Dashboard'),
        actions: [
          IconButton(onPressed: loadCounts, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminLoginScreen())),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadCounts,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(colors: [Colors.black, Colors.deepOrange]),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.admin_panel_settings, size: 55, color: Colors.white),
                        SizedBox(height: 10),
                        Text('Welcome, Admin!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        Text('Monitor users, listings, bids and complaints in one place.', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(spacing: 12, runSpacing: 12, children: [
                    for (final item in [
                      ('Users', users, Icons.people),
                      ('Cars', cars, Icons.directions_car),
                      ('Bids', bids, Icons.gavel),
                      ('Reports', reports, Icons.report),
                    ])
                      // Two per row on a phone, more on wider screens.
                      SizedBox(
                        width: MediaQuery.of(context).size.width < 600
                            ? (MediaQuery.of(context).size.width - 36 - 12) / 2
                            : 250,
                        child: stat(item.$1, item.$2, item.$3),
                      ),
                  ]),
                  const SizedBox(height: 18),
                  module(context, 'User Management', 'View, block or reactivate users', Icons.people, const ViewUsersScreen()),
                  module(context, 'Car Listing Monitoring', 'Approve, block or remove cars', Icons.car_rental, const ViewListingsScreen()),
                  module(context, 'Bid Monitoring', 'Track and reject suspicious bids', Icons.gavel, const ViewBidsScreen()),
                  module(context, 'Report Complaints', 'Review buyer complaints', Icons.report, const ViewReportsScreen()),
                  module(context, 'User Analytics', 'User counts and status stats', Icons.bar_chart, const UserStatsScreen()),
                  module(context, 'Listing Analytics', 'Car, bid, earning and report stats', Icons.analytics, const ListingStatsScreen()),
                ],
              ),
            ),
    );
  }
}
