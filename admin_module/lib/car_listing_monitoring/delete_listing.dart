import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class DeleteListingScreen extends StatefulWidget {
  final String carId;
  const DeleteListingScreen({super.key, required this.carId});

  @override
  State<DeleteListingScreen> createState() => _DeleteListingScreenState();
}

class _DeleteListingScreenState extends State<DeleteListingScreen> {
  bool loading = false;

  Future<void> block() async {
    setState(() => loading = true);
    try {
      await supabase.from('cars').update({'status': 'blocked'}).eq('id', widget.carId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Listing blocked')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Block Listing')),
    body: Center(child: Padding(padding: const EdgeInsets.all(24), child: adminCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.block, size: 70, color: Colors.red),
      const SizedBox(height: 12),
      const Text('Block this car listing?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      const SizedBox(height: 20),
      SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : block, child: Text(loading ? 'Saving...' : 'Confirm'))),
    ])))),
  );
}
