import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class RemoveBidScreen extends StatefulWidget {
  final String bidId;
  const RemoveBidScreen({super.key, required this.bidId});

  @override
  State<RemoveBidScreen> createState() => _RemoveBidScreenState();
}

class _RemoveBidScreenState extends State<RemoveBidScreen> {
  bool loading = false;

  Future<void> reject() async {
    setState(() => loading = true);
    try {
      await supabase.from('bids').update({'bid_status': 'rejected'}).eq('id', widget.bidId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bid rejected successfully')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Reject Bid')),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: adminCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.warning, size: 70, color: Colors.red),
      const SizedBox(height: 12),
      Text('Bid ID: ${shortId(widget.bidId)}'),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : reject, child: Text(loading ? 'Saving...' : 'Reject Bid'))),
    ])))),
  );
}
