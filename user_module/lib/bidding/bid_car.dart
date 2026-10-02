import 'package:flutter/material.dart';
import '../models/bid_model.dart';
import '../models/car_model.dart';
import '../services/bid_service.dart';
import '../services/session_service.dart';
import '../utils/format.dart';

class BidCar extends StatefulWidget {
  final CarModel car;

  const BidCar({
    super.key,
    required this.car,
  });

  @override
  State<BidCar> createState() => _BidCarState();
}

class _BidCarState extends State<BidCar> {
  final bidController = TextEditingController();

  final BidService bidService = BidService();

  bool isLoading = false;

  @override
  void dispose() {
    bidController.dispose();
    super.dispose();
  }

  Future<void> placeBid() async {
    final user = SessionService.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please login first")),
      );
      return;
    }

    // tryParse: typing letters or leaving the field empty no longer crashes.
    final bidAmount = double.tryParse(bidController.text.trim());

    if (bidAmount == null || bidAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a valid bid amount")),
      );
      return;
    }

    if (bidAmount <= widget.car.price) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bid must be greater than starting price")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final bid = BidModel(
      carId: widget.car.id!,
      buyerId: user.id!,
      sellerId: widget.car.sellerId,
      bidAmount: bidAmount,
    );

    final error = await bidService.placeBid(bid);

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
      const SnackBar(content: Text("Bid placed successfully")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Place Bid"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.car.carName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text("Starting Price: ${formatPrice(widget.car.price)}"),

            const SizedBox(height: 20),

            TextField(
              controller: bidController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Your Bid Amount",
                prefixText: "Rs. ",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : placeBid,
                child: Text(isLoading ? "Placing..." : "Place Bid"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}