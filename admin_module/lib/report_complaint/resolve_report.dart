import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class ResolveReportScreen extends StatefulWidget {
  final String reportId;
  const ResolveReportScreen({super.key, required this.reportId});

  @override
  State<ResolveReportScreen> createState() => _ResolveReportScreenState();
}

class _ResolveReportScreenState extends State<ResolveReportScreen> {
  bool loading = false;

  Future<void> resolve() async {
    setState(() => loading = true);
    try {
      await supabase.from('reports').update({'status': 'resolved'}).eq('id', widget.reportId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report resolved')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Resolve Report')),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: adminCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.check_circle, size: 70, color: Colors.green),
      const SizedBox(height: 12),
      Text('Report ID: ${shortId(widget.reportId)}'),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : resolve, child: Text(loading ? 'Saving...' : 'Mark Resolved'))),
    ])))),
  );
}
