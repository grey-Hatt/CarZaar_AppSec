import 'package:flutter/material.dart';
import '../services/connects_service.dart';
import '../services/session_service.dart';
import '../utils/format.dart';

class BuyConnects extends StatefulWidget {
  const BuyConnects({super.key});

  @override
  State<BuyConnects> createState() => _BuyConnectsState();
}

class _BuyConnectsState extends State<BuyConnects> {
  final cardName = TextEditingController();
  final cardNumber = TextEditingController();
  final expiry = TextEditingController();
  final cvv = TextEditingController();

  final service = ConnectsService();
  bool loading = false;

  @override
  void dispose() {
    cardName.dispose();
    cardNumber.dispose();
    expiry.dispose();
    cvv.dispose();
    super.dispose();
  }

  int connects = 10;
  double amount = 100;

  final packages = [
    {"title": "Starter", "connects": 10, "amount": 100.0},
    {"title": "Value", "connects": 25, "amount": 200.0},
    {"title": "Pro", "connects": 50, "amount": 350.0},
  ];

  Future<void> buy() async {
    final user = SessionService.currentUser;
    if (user == null) return;

    if (cardName.text.trim().isEmpty ||
        cardNumber.text.trim().isEmpty ||
        expiry.text.trim().isEmpty ||
        cvv.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter demo payment details")),
      );
      return;
    }

    setState(() => loading = true);

    final error = await service.buyConnects(
      userId: user.id!,
      connects: connects,
      amount: amount,
    );

    if (!mounted) return;
    setState(() => loading = false);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$connects connects added")),
    );

    Navigator.pop(context);
  }

  Widget input(String label, TextEditingController c, IconData icon,
      {TextInputType? type, bool hide = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: type,
        obscureText: hide,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget pack(Map<String, dynamic> p) {
    final selected = connects == p["connects"];
    return GestureDetector(
      onTap: () => setState(() {
        connects = p["connects"];
        amount = p["amount"];
      }),
      child: Card(
        color: selected ? Colors.orange.shade100 : null,
        child: ListTile(
          leading: Icon(selected ? Icons.check_circle : Icons.circle_outlined),
          title: Text("${p["title"]} Pack"),
          subtitle: Text("${p["connects"]} Connects"),
          trailing: Text(
            formatPrice(p["amount"] as num),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Connects"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            ...packages.map(pack),
            const SizedBox(height: 15),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Demo payment - no real card is charged.",
                style: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 10),
            input("Card Holder Name", cardName, Icons.person),
            input("Demo Card Number", cardNumber, Icons.credit_card,
                type: TextInputType.number),
            input("Expiry MM/YY", expiry, Icons.date_range,
                type: TextInputType.datetime),
            input("CVV", cvv, Icons.lock, type: TextInputType.number, hide: true),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: loading ? null : buy,
                icon: const Icon(Icons.payment),
                label: Text(loading ? "Processing..." : "Pay ${formatPrice(amount)}"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.all(15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}