import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';
import 'package:carzaar_admin/report_complaint/resolve_report.dart';
import 'package:carzaar_admin/report_complaint/dismiss_report.dart';

class ViewReportsScreen extends StatefulWidget {
  const ViewReportsScreen({super.key});

  @override
  State<ViewReportsScreen> createState() => _ViewReportsScreenState();
}

class _ViewReportsScreenState extends State<ViewReportsScreen> {
  List<Map<String, dynamic>> reports = [];
  bool loading = true;
  String filter = 'All';
  final filters = ['All', 'pending', 'resolved', 'dismissed'];

  @override
  void initState() { super.initState(); load(); }

  Future<void> load() async {
    try {
      final res = await supabase.from('reports').select().order('created_at', ascending: false);
      if (!mounted) return;
      setState(() { reports = List<Map<String, dynamic>>.from(res); loading = false; });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget reportCard(Map<String, dynamic> r) {
    return FutureBuilder(
      future: Future.wait([fetchUser(r['reported_by']), fetchUser(r['reported_user']), fetchCar(r['car_id'])]),
      builder: (_, AsyncSnapshot<List<Map<String, dynamic>?>> s) {
        final buyer = s.data?[0], seller = s.data?[1], car = s.data?[2];
        final status = r['status'] ?? 'pending';
        return adminCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(backgroundColor: Colors.red.shade700, child: const Icon(Icons.report, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(child: Text(r['reason'] ?? 'Report', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            statusChip(status),
          ]),
          const SizedBox(height: 10),
          Text('Car: ${car?['car_name'] ?? 'Loading car...'}'),
          Text('Reported By: ${userName(buyer)}'),
          Text('Reported Seller: ${userName(seller)}'),
          const SizedBox(height: 8),
          Text(r['description'] ?? '', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: ElevatedButton.icon(icon: const Icon(Icons.check), label: const Text('Resolve'), onPressed: status == 'resolved' ? null : () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => ResolveReportScreen(reportId: r['id']))); load(); })),
            const SizedBox(width: 10),
            Expanded(child: OutlinedButton.icon(icon: const Icon(Icons.close), label: const Text('Dismiss'), onPressed: status == 'dismissed' ? null : () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => DismissReportScreen(reportId: r['id']))); load(); })),
          ]),
        ]));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final list = reports.where((r) => filter == 'All' || (r['status'] ?? 'pending') == filter).toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Report Complaints'), actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.all(14), child: Row(children: filters.map((f) => Padding(padding: const EdgeInsets.only(right: 8), child: FilterChip(label: Text(f), selected: filter == f, onSelected: (_) => setState(() => filter = f)))).toList())),
        Expanded(child: loading ? const Center(child: CircularProgressIndicator()) : list.isEmpty ? emptyBox('No reports found', Icons.report) : RefreshIndicator(onRefresh: load, child: ListView.builder(padding: const EdgeInsets.all(14), itemCount: list.length, itemBuilder: (_, i) => reportCard(list[i])))),
      ]),
    );
  }
}
