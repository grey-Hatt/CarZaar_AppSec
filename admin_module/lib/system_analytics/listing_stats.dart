import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class ListingStatsScreen extends StatefulWidget {
  const ListingStatsScreen({super.key});

  @override
  State<ListingStatsScreen> createState() => _ListingStatsScreenState();
}

class _ListingStatsScreenState extends State<ListingStatsScreen> {
  bool loading = true;
  int cars = 0, active = 0, pending = 0, sold = 0, bids = 0, reports = 0, earnings = 0;

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    try {
      final c = List<Map<String, dynamic>>.from(await supabase.from('cars').select());
      final b = await supabase.from('bids').select('id');
      final r = await supabase.from('reports').select('id');
      final e = await supabase.from('connects_transactions').select('id').eq('type', 'purchase');
      if (!mounted) return;
      setState(() {
        cars = c.length;
        active = c.where((x) => (x['status'] ?? 'active') == 'active').length;
        pending = c.where((x) => x['status'] == 'deal_pending').length;
        sold = c.where((x) => x['status'] == 'sold').length;
        bids = b.length;
        reports = r.length;
        earnings = e.length;
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
    appBar: AppBar(title: const Text('System Analytics'), actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh))]),
    body: loading ? const Center(child: CircularProgressIndicator()) : ListView(padding: const EdgeInsets.all(18), children: [
      stat('Total Cars', cars, Icons.directions_car, Colors.blue),
      stat('Active Cars', active, Icons.check_circle, Colors.green),
      stat('Deal Pending', pending, Icons.pending_actions, Colors.orange),
      stat('Sold Cars', sold, Icons.done_all, Colors.teal),
      stat('Total Bids', bids, Icons.gavel, Colors.purple),
      stat('Reports', reports, Icons.report, Colors.red),
      stat('Connect Purchases', earnings, Icons.payments, Colors.amber),
    ]),
  );
}
