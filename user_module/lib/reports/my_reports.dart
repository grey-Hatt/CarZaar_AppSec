import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../services/session_service.dart';
import '../widgets/status_chip.dart';

class MyReports extends StatefulWidget {
  const MyReports({super.key});

  @override
  State<MyReports> createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
  final ReportService reportService = ReportService();

  List<ReportModel> reports = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    final user = SessionService.currentUser;

    if (user == null) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    final result = await reportService.getMyReports(user.id!);

    if (!mounted) return;
    setState(() {
      reports = result;
      isLoading = false;
    });
  }

  Widget reportCard(ReportModel report) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const Icon(Icons.report),
        title: Text(
          report.reason,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(report.description),
        trailing: StatusChip(report.status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Complaints"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: loadReports,
              child: reports.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Icon(Icons.report_gmailerrorred, size: 60, color: Colors.black26),
                        SizedBox(height: 10),
                        Center(child: Text("No complaints submitted yet")),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: reports.length,
                      itemBuilder: (context, index) {
                        return reportCard(reports[index]);
                      },
                    ),
            ),
    );
  }
}