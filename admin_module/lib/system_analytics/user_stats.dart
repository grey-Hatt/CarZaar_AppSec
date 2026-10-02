import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class UserStatsScreen extends StatefulWidget {
  const UserStatsScreen({super.key});

  @override
  State<UserStatsScreen> createState() => _UserStatsScreenState();
}

class _UserStatsScreenState extends State<UserStatsScreen> {
  bool loading = true;
  int total = 0, active = 0, blocked = 0, verified = 0;

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    try {
      final users = List<Map<String, dynamic>>.from(await supabase.from('users').select());
      if (!mounted) return;
      setState(() {
        total = users.length;
        active = users.where((u) => (u['status'] ?? 'active') == 'active').length;
        blocked = users.where((u) => u['status'] == 'blocked').length;
        verified = users.where((u) => u['is_verified'] == true).length;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => loading = false);
    }
  }

  Widget stat(String title, int value, IconData icon, Color color) => adminCard(child: Row(children: [
    CircleAvatar(backgroundColor: color, child: Icon(icon, color: Colors.white)),
    const SizedBox(width: 12),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('$value', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
      Text(title, style: const TextStyle(color: Colors.white60)),
    ]),
  ]));

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('User Analytics'), actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh))]),
    body: loading ? const Center(child: CircularProgressIndicator()) : ListView(padding: const EdgeInsets.all(18), children: [
      stat('Total Users', total, Icons.people, Colors.blue),
      stat('Active Users', active, Icons.check_circle, Colors.green),
      stat('Blocked Users', blocked, Icons.block, Colors.red),
      stat('Verified Sellers', verified, Icons.verified, Colors.orange),
    ]),
  );
}
