import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';
import 'package:carzaar_admin/car_listing_monitoring/approve_listing.dart';
import 'package:carzaar_admin/car_listing_monitoring/delete_listing.dart';

class ViewListingsScreen extends StatefulWidget {
  const ViewListingsScreen({super.key});

  @override
  State<ViewListingsScreen> createState() => _ViewListingsScreenState();
}

class _ViewListingsScreenState extends State<ViewListingsScreen> {
  final search = TextEditingController();
  List<Map<String, dynamic>> cars = [];
  bool loading = true;
  String q = '', filter = 'All';
  final filters = ['All', 'active', 'deal_pending', 'sold', 'removed', 'blocked'];

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    try {
      final res = await supabase.from('cars').select().order('created_at', ascending: false);
      if (!mounted) return;
      setState(() { cars = List<Map<String, dynamic>>.from(res); loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget carCard(Map<String, dynamic> c) {
    final status = c['status'] ?? 'active';
    return adminCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      CarImageBox(image: c['image_url'], height: 120),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: Text(c['car_name'] ?? 'Unknown Car', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold))),
        if (c['is_featured'] == true) const Icon(Icons.star, color: Colors.orange),
      ]),
      Text('${c['brand'] ?? ''} ${c['model'] ?? ''} • ${c['year'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis),
      Text(formatPrice(c['price']), style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold)),
      Text(c['location'] ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 6),
      statusChip(status),
      const Spacer(),
      Row(children: [
        Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.check, size: 16), label: const Text('Active'), onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => ApproveListingScreen(carId: c['id']))); load(); })),
        const SizedBox(width: 8),
        Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.block, size: 16), label: const Text('Block'), onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => DeleteListingScreen(carId: c['id']))); load(); })),
      ]),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final list = cars.where((c) {
      final text = '${c['car_name'] ?? ''} ${c['brand'] ?? ''} ${c['model'] ?? ''} ${c['location'] ?? ''}'.toLowerCase();
      final status = c['status'] ?? 'active';
      return text.contains(q) && (filter == 'All' || status == filter);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Car Listing Monitoring'), actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        Padding(padding: const EdgeInsets.all(14), child: TextField(controller: search, decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search cars'), onChanged: (v) => setState(() => q = v.toLowerCase()))),
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 14), child: Row(children: filters.map((f) => Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: Text(f), selected: filter == f, onSelected: (_) => setState(() => filter = f)))).toList())),
        Expanded(
          child: loading ? const Center(child: CircularProgressIndicator()) : list.isEmpty ? emptyBox('No listings found', Icons.car_rental) : RefreshIndicator(
            onRefresh: load,
            child: GridView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: list.length,
              // Fixed card height + flexible columns: no overflow on any screen width.
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 400, crossAxisSpacing: 14, mainAxisSpacing: 14, mainAxisExtent: 400),
              itemBuilder: (_, i) => carCard(list[i]),
            ),
          ),
        ),
      ]),
    );
  }
}
