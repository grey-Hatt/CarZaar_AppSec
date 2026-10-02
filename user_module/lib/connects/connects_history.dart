import 'package:flutter/material.dart';
import '../models/connects_model.dart';
import '../services/connects_service.dart';
import '../services/session_service.dart';
import '../utils/format.dart';

class ConnectsHistory extends StatefulWidget {
  const ConnectsHistory({super.key});

  @override
  State<ConnectsHistory> createState() => _ConnectsHistoryState();
}

class _ConnectsHistoryState extends State<ConnectsHistory> {
  final service = ConnectsService();
  List<ConnectsTransactionModel> history = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final user = SessionService.currentUser;
    if (user == null) {
      if (mounted) setState(() => loading = false);
      return;
    }

    final result = await service.getHistory(user.id!);
    if (!mounted) return;
    setState(() {
      history = result;
      loading = false;
    });
  }

  Widget card(ConnectsTransactionModel t) {
    final purchase = t.type == "purchase";
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: purchase ? Colors.green.shade100 : Colors.red.shade100,
          child: Icon(
            purchase ? Icons.add : Icons.remove,
            color: purchase ? Colors.green : Colors.red,
          ),
        ),
        title: Text(
          t.feature.replaceAll('_', ' '),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("${t.type} • ${formatPrice(t.amount)}"),
        trailing: Text(
          "${purchase ? "+" : "-"}${t.connects}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: purchase ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Connects History"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: load,
              child: history.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Icon(Icons.history, size: 60, color: Colors.black26),
                        SizedBox(height: 10),
                        Center(child: Text("No history found")),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: history.length,
                      itemBuilder: (_, i) => card(history[i]),
                    ),
            ),
    );
  }
}