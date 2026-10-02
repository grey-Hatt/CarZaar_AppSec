import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class DismissReportScreen extends StatefulWidget {
  final String reportId;
  const DismissReportScreen({super.key, required this.reportId});

  @override
  State<DismissReportScreen> createState() => _DismissReportScreenState();
}

class _DismissReportScreenState extends State<DismissReportScreen> {
  bool loading = false;

  Future<void> dismiss() async {
    setState(() => loading = true);
    try {
      await supabase.from('reports').update({'status': 'dismissed'}).eq('id', widget.reportId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Report dismissed')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Dismiss Report')),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: adminCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.cancel, size: 70, color: Colors.red),
      const SizedBox(height: 12),
      Text('Report ID: ${shortId(widget.reportId)}'),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : dismiss, child: Text(loading ? 'Saving...' : 'Dismiss Report'))),
    ])))),
  );
}
