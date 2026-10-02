import 'package:flutter/material.dart';
import '../buyer/buyer_dashboard.dart';

class BuyerScreen extends StatelessWidget {
  const BuyerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buyer Mode"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: BuyerDashboard(),
      ),
    );
  }
}