import 'package:flutter/material.dart';
import '../listing/update_car.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';
import '../services/connects_service.dart';
import '../services/session_service.dart';
import '../utils/format.dart';
import '../widgets/car_image.dart';
import '../widgets/status_chip.dart';

class MyCars extends StatefulWidget {
  const MyCars({super.key});

  @override
  State<MyCars> createState() => _MyCarsState();
}

class _MyCarsState extends State<MyCars> {
  final carService = CarService();
  final connects = ConnectsService();
  List<CarModel> cars = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    final u = SessionService.currentUser;
    if (u == null) {
      if (mounted) setState(() => loading = false);
      return;
    }
    final result = await carService.getSellerCars(u.id!);
    if (!mounted) return;
    setState(() {
      cars = result;
      loading = false;
    });
  }

  Future<void> msg(Future<String?> task, String ok) async {
    final e = await task;
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e ?? ok)));
    load();
  }

  Future<void> confirmRemove(CarModel c) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Remove this listing?'),
        content: Text('"${c.carName}" will no longer be visible to buyers.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remove', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await msg(carService.deleteCar(c.id!), 'Car removed');
    }
  }

  Widget carCard(CarModel c) {
    final canFeature = !c.isFeatured && c.status == 'active';

    return Card(
      elevation: 3,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CarImage(image: c.imageUrl, height: 120),
          const SizedBox(height: 8),
          Row(children: [
            Expanded(
              child: Text(
                c.carName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            if (c.isFeatured) const Icon(Icons.star, color: Colors.orange, size: 20),
          ]),
          const SizedBox(height: 4),
          Text(
            '${c.brand} ${c.model} • ${c.year}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            formatPrice(c.price),
            style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
          ),
          Text(c.location, maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Align(alignment: Alignment.centerLeft, child: StatusChip(c.status)),
          const Spacer(),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit, size: 16),
                label: const Text('Update'),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => UpdateCar(car: c)),
                  );
                  load();
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.delete, size: 16),
                label: const Text('Remove'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => confirmRemove(c),
              ),
            ),
          ]),
          if (canFeature) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.star, size: 16),
                label: const Text('Feature - 10 Connects'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  final u = SessionService.currentUser!;
                  msg(
                    connects.makeCarFeatured(userId: u.id!, carId: c.id!),
                    'Car featured',
                  );
                },
              ),
            ),
          ],
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visible = cars.where((c) => c.status != 'removed').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Listed Cars')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: load,
              child: visible.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 120),
                        Icon(Icons.directions_car, size: 60, color: Colors.black26),
                        SizedBox(height: 10),
                        Center(child: Text('No cars listed yet')),
                      ],
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: visible.length,
                      // Fixed card height + flexible columns: no overflow on any width.
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        mainAxisExtent: 410,
                      ),
                      itemBuilder: (_, i) => carCard(visible[i]),
                    ),
            ),
    );
  }
}
