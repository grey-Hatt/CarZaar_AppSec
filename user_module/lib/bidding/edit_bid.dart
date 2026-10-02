import 'package:flutter/material.dart';
import '../models/bid_model.dart';
import '../services/bid_service.dart';

class EditBid extends StatefulWidget {
  final BidModel bid;

  const EditBid({
    super.key,
    required this.bid,
  });

  @override
  State<EditBid> createState() => _EditBidState();
}

class _EditBidState extends State<EditBid> {
  final bidController = TextEditingController();

  final BidService bidService = BidService();

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Show 2500000 instead of 2500000.0
    final amount = widget.bid.bidAmount;
    bidController.text =
        amount == amount.roundToDouble() ? amount.toInt().toString() : amount.toString();
  }

  @override
  void dispose() {
    bidController.dispose();
    super.dispose();
  }

  Future<void> updateBid() async {
    final newAmount = double.tryParse(bidController.text.trim());

    if (newAmount == null || newAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid bid amount")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final error = await bidService.updateBid(widget.bid.id!, newAmount);

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
      const SnackBar(content: Text("Bid updated successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Bid"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            TextField(
              controller: bidController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "New Bid Amount",
                prefixText: "Rs. ",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateBid,
                child: Text(isLoading ? "Updating..." : "Update Bid"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}