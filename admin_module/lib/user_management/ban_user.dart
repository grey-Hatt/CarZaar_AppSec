import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class BanUserScreen extends StatefulWidget {
  final String userId;
  final String currentStatus;
  const BanUserScreen({super.key, required this.userId, required this.currentStatus});

  @override
  State<BanUserScreen> createState() => _BanUserScreenState();
}

class _BanUserScreenState extends State<BanUserScreen> {
  bool loading = false;

  Future<void> update() async {
    setState(() => loading = true);
    final next = widget.currentStatus == 'blocked' ? 'active' : 'blocked';
    try {
      await supabase.from('users').update({'status': next}).eq('id', widget.userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User status changed to $next')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final block = widget.currentStatus != 'blocked';
    return Scaffold(
      appBar: AppBar(title: Text(block ? 'Block User' : 'Activate User')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: adminCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(block ? Icons.block : Icons.lock_open, size: 70, color: block ? Colors.red : Colors.green),
            const SizedBox(height: 12),
            Text(block ? 'Block this user?' : 'Activate this user?', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : update, child: Text(loading ? 'Saving...' : 'Confirm'))),
          ])),
        ),
      ),
    );
  }
}
