import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class ApproveListingScreen extends StatefulWidget {
  final String carId;
  const ApproveListingScreen({super.key, required this.carId});

  @override
  State<ApproveListingScreen> createState() => _ApproveListingScreenState();
}

class _ApproveListingScreenState extends State<ApproveListingScreen> {
  bool loading = false;

  Future<void> approve() async {
    setState(() => loading = true);
    try {
      await supabase.from('cars').update({'status': 'active'}).eq('id', widget.carId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing set to active')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Approve Listing')),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: adminCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.check_circle, size: 70, color: Colors.green),
      const SizedBox(height: 12),
      const Text('Set this car listing to active?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : approve, child: Text(loading ? 'Saving...' : 'Confirm'))),
    ])))),
  );
}
