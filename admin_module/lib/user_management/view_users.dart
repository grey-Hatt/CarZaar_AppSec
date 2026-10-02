import 'package:flutter/material.dart';
import 'package:carzaar_admin/admin_utils.dart';
import 'package:carzaar_admin/user_management/ban_user.dart';
import 'package:carzaar_admin/user_management/delete_user.dart';

class ViewUsersScreen extends StatefulWidget {
  const ViewUsersScreen({super.key});

  @override
  State<ViewUsersScreen> createState() => _ViewUsersScreenState();
}

class _ViewUsersScreenState extends State<ViewUsersScreen> {
  final search = TextEditingController();
  List<Map<String, dynamic>> users = [];
  bool loading = true;
  String q = '', filter = 'All';
  final filters = ['All', 'active', 'blocked'];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    try {
      final res = await supabase.from('users').select().order('created_at', ascending: false);
      if (!mounted) return;
      setState(() {
        users = List<Map<String, dynamic>>.from(res);
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = users.where((u) {
      final text = '${userName(u)} ${u['email'] ?? ''} ${u['phone'] ?? ''}'.toLowerCase();
      final status = u['status'] ?? 'active';
      return text.contains(q) && (filter == 'All' || status == filter);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('User Management'), actions: [IconButton(onPressed: load, icon: const Icon(Icons.refresh))]),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: TextField(
            controller: search,
            decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search user'),
            onChanged: (v) => setState(() => q = v.toLowerCase()),
          ),
        ),
        Wrap(spacing: 8, children: filters.map((f) => FilterChip(label: Text(f), selected: filter == f, onSelected: (_) => setState(() => filter = f))).toList()),
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : list.isEmpty
                  ? emptyBox('No users found', Icons.people_outline)
                  : RefreshIndicator(
                      onRefresh: load,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final u = list[i];
                          final status = u['status'] ?? 'active';
                          return adminCard(
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                CircleAvatar(backgroundColor: Colors.deepOrange, child: Text(userName(u)[0].toUpperCase())),
                                const SizedBox(width: 12),
                                Expanded(child: Text(userName(u), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                                statusChip(status),
                              ]),
                              const SizedBox(height: 8),
                              Text('Email: ${u['email'] ?? ''}'),
                              Text('Phone: ${u['phone'] ?? ''}'),
                              Text('City: ${u['city'] ?? ''}'),
                              const SizedBox(height: 10),
                              Row(children: [
                                Expanded(child: ElevatedButton.icon(
                                  icon: Icon(status == 'blocked' ? Icons.lock_open : Icons.block),
                                  label: Text(status == 'blocked' ? 'Activate' : 'Block'),
                                  onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => BanUserScreen(userId: u['id'], currentStatus: status))); load(); },
                                )),
                                const SizedBox(width: 10),
                                Expanded(child: OutlinedButton.icon(
                                  icon: const Icon(Icons.delete), label: const Text('Soft Delete'),
                                  onPressed: () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => DeleteUserScreen(userId: u['id']))); load(); },
                                )),
                              ]),
                            ]),
                          );
                        },
                      ),
                    ),
        ),
      ]),
    );
  }
}
