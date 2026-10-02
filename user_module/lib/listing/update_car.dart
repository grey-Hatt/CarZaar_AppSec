import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';
import '../widgets/car_image.dart';

class UpdateCar extends StatefulWidget {
  final CarModel car;
  const UpdateCar({super.key, required this.car});

  @override
  State<UpdateCar> createState() => _UpdateCarState();
}

class _UpdateCarState extends State<UpdateCar> {
  final service = CarService();
  late TextEditingController name, brand, model, year, price, location, desc;
  late String carImage;
  String selectedImageName = 'Current image saved';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    final c = widget.car;
    name = TextEditingController(text: c.carName);
    brand = TextEditingController(text: c.brand);
    model = TextEditingController(text: c.model);
    year = TextEditingController(text: '${c.year}');
    price = TextEditingController(
      text: c.price == c.price.roundToDouble() ? '${c.price.toInt()}' : '${c.price}',
    );
    location = TextEditingController(text: c.location);
    desc = TextEditingController(text: c.description);
    carImage = c.imageUrl;
  }

  @override
  void dispose() {
    for (final c in [name, brand, model, year, price, location, desc]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> pickImage() async {
    try {
      // Downscale + compress: full camera photos make the app and lists very slow.
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1280,
        imageQuality: 75,
      );
      if (img == null) return;
      final bytes = await img.readAsBytes();
      if (!mounted) return;
      setState(() {
        carImage = base64Encode(bytes);
        selectedImageName = img.name;
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not pick the image')),
      );
    }
  }

  Future<void> update() async {
    final y = int.tryParse(year.text.trim());
    final p = double.tryParse(price.text.trim());

    if ([name, brand, model, year, price, location, desc]
        .any((c) => c.text.trim().isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Fill all fields')),
      );
      return;
    }
    if (y == null || p == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Year and price must be numbers')),
      );
      return;
    }
    if (y < 1950 || y > DateTime.now().year + 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid model year')),
      );
      return;
    }
    if (p <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Price must be greater than zero')),
      );
      return;
    }

    setState(() => loading = true);
    final e = await service.updateCar(CarModel(
      id: widget.car.id,
      sellerId: widget.car.sellerId,
      carName: name.text.trim(),
      brand: brand.text.trim(),
      model: model.text.trim(),
      year: y,
      price: p,
      location: location.text.trim(),
      description: desc.text.trim(),
      imageUrl: carImage,
      status: widget.car.status,
      isFeatured: widget.car.isFeatured,
    ));
    if (!mounted) return;
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e ?? 'Car updated successfully')),
    );
    if (e == null) Navigator.pop(context);
  }

  Widget field(String label, TextEditingController c, IconData icon,
      {bool number = false, int lines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: lines,
        keyboardType: number
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  Widget imageRow() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(children: [
          const Icon(Icons.image, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(selectedImageName,
                maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          TextButton(onPressed: pickImage, child: const Text('Change')),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Car'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          const Icon(Icons.edit, size: 70, color: Colors.orange),
          const SizedBox(height: 15),
          imageRow(),
          if (carImage.isNotEmpty) ...[
            const SizedBox(height: 12),
            CarImage(image: carImage, height: 170),
          ],
          const SizedBox(height: 15),
          field('Car Name', name, Icons.directions_car),
          field('Brand', brand, Icons.business),
          field('Model', model, Icons.car_rental),
          field('Year', year, Icons.calendar_month, number: true),
          field('Starting Price', price, Icons.money, number: true),
          field('Location', location, Icons.location_on),
          field('Description', desc, Icons.description, lines: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: loading ? null : update,
              icon: const Icon(Icons.save),
              label: Text(loading ? 'Updating...' : 'Update Car'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.all(15),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
