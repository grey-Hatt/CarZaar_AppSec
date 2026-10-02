import 'package:flutter/material.dart';
import '../listing/add_car.dart';
import 'my_cars.dart';
import 'received_bids.dart';

class SellerDashboard extends StatelessWidget {
  const SellerDashboard({super.key});

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
              Icon(Icons.sell, color: Colors.white, size: 45),
              SizedBox(width: 15),
              Expanded(
                child: Text(
                  "Seller Mode\nList your cars and manage buyer bids.",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        card(context, Icons.add_circle, "Add Car", "Create a new car listing", const AddCar()),
        card(context, Icons.car_rental, "My Listed Cars", "Update, remove, or feature cars", const MyCars()),
        card(context, Icons.price_check, "Received Bids", "Accept, reject, or manage deals", const ReceivedBids()),
      ],
    );
  }
}