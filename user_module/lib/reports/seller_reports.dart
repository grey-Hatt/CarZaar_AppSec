import 'package:flutter/material.dart';
import '../services/report_service.dart';
import '../services/session_service.dart';
import '../widgets/status_chip.dart';

class SellerReports extends StatefulWidget {
  const SellerReports({super.key});

  @override
  State<SellerReports> createState() => _SellerReportsState();
}

class _SellerReportsState extends State<SellerReports> {
  final service = ReportService();
  List<Map<String, dynamic>> reports = [];
  bool loading = true;

  // Cached lookups so a rebuild does not re-query the database for every card.
  final Map<String, Future<List<Map<String, dynamic>?>>> _details = {};

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

    final result = await service.getReportsAgainstSeller(user.id!);
    if (!mounted) return;
    setState(() {
      reports = result;
      _details.clear();
      loading = false;
    });
  }

  Widget reportCard(Map<String, dynamic> r) {
    return FutureBuilder<List<Map<String, dynamic>?>>(
      future: _details.putIfAbsent(
        '${r['id']}',
        () => Future.wait<Map<String, dynamic>?>([
          service.getUserById(r['reported_by']),
          service.getCarById(r['car_id']),
        ]),
      ),
      builder: (_, s) {
        final done = s.connectionState == ConnectionState.done;
        final buyer = s.data?[0];
        final car = s.data?[1];

        return Card(
          margin: const EdgeInsets.only(bottom: 14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.red.shade100,
                      child: const Icon(Icons.report, color: Colors.red),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        r['reason'] ?? "Report",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusChip((r['status'] ?? 'pending').toString()),
                  ],
                ),
                const SizedBox(height: 10),
                Text("Car: ${car?['car_name'] ?? (done ? 'Unknown car' : 'Loading car...')}"),
                Text(
                  "Reported by: ${buyer?['name'] ?? (done ? 'Unknown user' : 'Loading...')}",
                ),
                const SizedBox(height: 8),
                Text(r['description'] ?? ""),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports on My Listings"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: load,
              child: reports.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Icon(Icons.verified_user, size: 60, color: Colors.black26),
                        SizedBox(height: 10),
                        Center(child: Text("No reports on your listings")),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: reports.length,
                      itemBuilder: (_, i) => reportCard(reports[i]),
                    ),
            ),
    );
  }
}