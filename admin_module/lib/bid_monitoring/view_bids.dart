import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';
import 'package:carzaar_admin/bid_monitoring/remove_bid.dart';

class ViewBidsScreen extends StatefulWidget {
  const ViewBidsScreen({super.key});

  @override
  State<ViewBidsScreen> createState() => _ViewBidsScreenState();
}

class _ViewBidsScreenState extends State<ViewBidsScreen> {
  final search = TextEditingController();
  List<Map<String, dynamic>> bids = [];
  bool loading = true;
  String q = '', filter = 'All';
  final filters = ['All', 'pending', 'accepted', 'rejected', 'withdrawn', 'cancelled'];

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    try {
      final res = await supabase.from('bids').select().order('created_at', ascending: false);
      if (!mounted) return;
      setState(() { bids = List<Map<String, dynamic>>.from(res); loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget bidCard(Map<String, dynamic> b) {
    return FutureBuilder(
      future: Future.wait([fetchUser(b['buyer_id']), fetchUser(b['seller_id']), fetchCar(b['car_id'])]),
      builder: (_, AsyncSnapshot<List<Map<String, dynamic>?>> s) {
        final buyer = s.data?[0], seller = s.data?[1], car = s.data?[2];
        final status = b['bid_status'] ?? 'pending';
        return adminCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(backgroundColor: Colors.deepOrange, child: const Icon(Icons.gavel, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(child: Text(car?['car_name'] ?? 'Loading car...', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            statusChip(status),
          ]),
          const SizedBox(height: 10),
          Text('Bid Amount: ${formatPrice(b['bid_amount'])}', style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
          Text('Buyer: ${userName(buyer)}'),
          Text('Seller: ${userName(seller)}'),
          Text('Bid ID: ${shortId(b['id'])}'),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, child: OutlinedButton.icon(
            icon: const Icon(Icons.close), label: const Text('Reject / Remove Bid'),
            onPressed: status == 'rejected' ? null : () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => RemoveBidScreen(bidId: b['id']))); load(); },
          )),
        ]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = bids.where((b) {
      final status = b['bid_status'] ?? 'pending';
      final text = '${b['id']} ${b['car_id']} ${b['buyer_id']} ${b['seller_id']}'.toLowerCase();
      return text.contains(q) && (filter == 'All' || status == filter);
    }).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Bid Monitoring'), actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(14), child: TextField(controller: search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search bid/car/user id'), onChanged: (v) => setState(() => q = v.toLowerCase()))),
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 14), child: Row(children: filters.map((f) => Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: Text(f), selected: filter == f, onSelected: (_) => setState(() => filter = f)))).toList())),
        Expanded(child: loading ? const Center(child: CircularProgressIndicator()) : list.isEmpty ? emptyBox('No bids found', Icons.gavel) : RefreshIndicator(onRefresh: load, child: ListView.builder(padding: const EdgeInsets.all(14), itemCount: list.length, itemBuilder: (_, i) => bidCard(list[i])))),
      ]),
    );
  }
}
