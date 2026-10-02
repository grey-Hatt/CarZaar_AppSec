import 'package:flutter/material.dart';
import '../models/report_model.dart';
import '../services/report_service.dart';
import '../services/session_service.dart';

class ReportUser extends StatefulWidget {
  final String? reportedUser;
  final String? carId;

  const ReportUser({
    super.key,
    this.reportedUser,
    this.carId,
  });

  @override
  State<ReportUser> createState() => _ReportUserState();
}

class _ReportUserState extends State<ReportUser> {
  final descriptionController = TextEditingController();

  final ReportService reportService = ReportService();

  String selectedReason = "Fake car listing";
  bool isLoading = false;

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  final List<String> reasons = [
    "Fake car listing",
    "Fake seller",
    "Wrong car details",
    "Fraud bid",
    "Meeting issue",
    "Other complaint",
  ];

  Future<void> submitReport() async {
    final user = SessionService.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter complaint description")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final report = ReportModel(
      reportedBy: user.id!,
      reportedUser: widget.reportedUser,
      carId: widget.carId,
      reason: selectedReason,
      description: descriptionController.text.trim(),
    );

    final error = await reportService.submitReport(report);

    if (!mounted) return;
    setState(() {
      isLoading = false;
    });

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Report submitted successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Submit Complaint"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Complaint Reason",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              initialValue: selectedReason,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: reasons.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(reason),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedReason = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Explain your complaint...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isLoading ? null : submitReport,
                icon: const Icon(Icons.report),
                label: Text(isLoading ? "Submitting..." : "Submit Report"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}