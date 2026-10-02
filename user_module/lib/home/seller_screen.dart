import 'package:flutter/material.dart';
import '../seller/seller_dashboard.dart';

class SellerScreen extends StatelessWidget {
  const SellerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Seller Mode"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(18),
        child: SellerDashboard(),
      ),
    );
  }
}