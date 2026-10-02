import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/bid_service.dart';
import '../services/session_service.dart';
import '../utils/format.dart';
import '../widgets/car_image.dart';
import '../bidding/bid_car.dart';
import '../reports/report_user.dart';

class CarDetails extends StatefulWidget {
  final CarModel car;

  const CarDetails({super.key, required this.car});

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  final bidService = BidService();
  double highestBid = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBid();
  }

  Future<void> loadBid() async {
    final highest = await bidService.getHighestBid(widget.car.id!);
    if (!mounted) return;
    setState(() {
      highestBid = highest;
      loading = false;
    });
  }

  Widget info(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final user = SessionService.currentUser;
    final ownCar = user?.id == car.sellerId;
    final wide = MediaQuery.of(context).size.width > 850;

    final details = Card(
      child: Column(
        children: [
          info("Brand", car.brand, Icons.business),
          info("Model", car.model, Icons.car_rental),
          info("Year", "${car.year}", Icons.calendar_month),
          info("Starting Price", formatPrice(car.price), Icons.money),
          info("Location", car.location, Icons.location_on),
          info("Status", car.status, Icons.info),
          info(
            "Highest Bid",
            loading
                ? "Loading..."
                : highestBid == 0
                ? "No bids yet"
                : formatPrice(highestBid),
            Icons.gavel,
          ),
        ],
      ),
    );

    final imageBox = Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: CarImage(image: car.imageUrl, height: wide ? 330 : 230),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Car Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  colors: [Colors.black, Colors.orange],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    car.carName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "${car.brand} ${car.model} • ${car.year}",
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 2, child: details),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: imageBox),
                    ],
                  )
                : Column(children: [imageBox, details]),

            const SizedBox(height: 12),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    car.description,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.gavel),
                    label: Text(ownCar ? "Own Car" : "Place Bid"),
                    onPressed: ownCar
                        ? null
                        : () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BidCar(car: car),
                              ),
                            );
                            loadBid();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(15),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.report),
                    label: const Text("Report"),
                    onPressed: ownCar
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReportUser(
                                  reportedUser: car.sellerId,
                                  carId: car.id,
                                ),
                              ),
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
