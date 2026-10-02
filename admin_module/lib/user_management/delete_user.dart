import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';

class DeleteUserScreen extends StatefulWidget {
  final String userId;
  const DeleteUserScreen({super.key, required this.userId});

  @override
  State<DeleteUserScreen> createState() => _DeleteUserScreenState();
}

class _DeleteUserScreenState extends State<DeleteUserScreen> {
  bool loading = false;

  Future<void> softDelete() async {
    setState(() => loading = true);
    try {
      await supabase.from('users').update({'status': 'blocked'}).eq('id', widget.userId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User soft deleted/blocked')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Soft Delete User')),
    body: Center(child: Padding(
      padding: const EdgeInsets.all(24),
      child: adminCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Icon(Icons.delete_forever, size: 70, color: Colors.red),
        const SizedBox(height: 12),
        const Text('This will block the user instead of deleting DB rows.', textAlign: TextAlign.center),
        const SizedBox(height: 20),
        SizedBox(width: double.infinity, child: ElevatedButton(onPressed: loading ? null : softDelete, child: Text(loading ? 'Saving...' : 'Confirm'))),
      ])),
    )),
  );
}
