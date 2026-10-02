import 'package:flutter/material.dart';
import 'view_cars.dart';
import 'my_bids.dart';

class BuyerDashboard extends StatelessWidget {
  const BuyerDashboard({super.key});

  Widget card(BuildContext context, IconData icon, String title, String sub, Widget page) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: Colors.orange.shade100,
          child: Icon(icon, color: Colors.black),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(sub),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(colors: [Colors.black, Colors.orange]),
          ),
          child: const Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.white, size: 45),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Buyer Mode\nBrowse cars and place your best bid.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        card(context, Icons.directions_car, "Browse Cars", "Find active car listings", const ViewCars()),
        card(context, Icons.gavel, "My Bids", "View, edit, or withdraw your bids", const MyBids()),
      ],
    );
  }
}