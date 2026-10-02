import 'package:flutter/material.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';
import '../utils/format.dart';
import '../widgets/car_image.dart';
import 'car_details.dart';

class ViewCars extends StatefulWidget {
  const ViewCars({super.key});

  @override
  State<ViewCars> createState() => _ViewCarsState();
}

class _ViewCarsState extends State<ViewCars> {
  final service = CarService();
  final search = TextEditingController();

  List<CarModel> cars = [];
  List<CarModel> filtered = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadCars();
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  Future<void> loadCars() async {
    final result = await service.getAllActiveCars();
    if (!mounted) return;
    setState(() {
      cars = result;
      loading = false;
    });
    filterCars(search.text);
  }

  void filterCars(String value) {
    final q = value.trim().toLowerCase();

    setState(() {
      filtered = cars.where((c) {
        return c.carName.toLowerCase().contains(q) ||
            c.brand.toLowerCase().contains(q) ||
            c.model.toLowerCase().contains(q) ||
            c.location.toLowerCase().contains(q);
      }).toList();
    });
  }

  Widget carCard(CarModel car) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CarDetails(car: car)),
        );
      },
      child: Card(
        elevation: 3,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarImage(image: car.imageUrl, height: 130),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      car.carName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (car.isFeatured)
                    const Icon(Icons.star, color: Colors.orange, size: 18),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                '${car.brand} ${car.model} • ${car.year}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 3),
              Text(
                formatPrice(car.price),
                style: const TextStyle(
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(car.location, maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse Cars')),
      body: Column(
        children: [
          Container(
            color: Colors.black,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: TextField(
              controller: search,
              onChanged: filterCars,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search by name, brand, model or city...',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.search, color: Colors.orange),
                suffixIcon: search.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          search.clear();
                          filterCars('');
                        },
                      ),
                filled: true,
                fillColor: Colors.white12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: loadCars,
                    child: filtered.isEmpty
                        // ListView so pull-to-refresh also works on the empty state.
                        ? ListView(
                            children: const [
                              SizedBox(height: 120),
                              Icon(Icons.search_off, size: 60, color: Colors.black26),
                              SizedBox(height: 10),
                              Center(child: Text('No cars found')),
                            ],
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filtered.length,
                            // Fixed card height + flexible columns: no overflow on any width.
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 380,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              mainAxisExtent: 270,
                            ),
                            itemBuilder: (_, i) => carCard(filtered[i]),
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
