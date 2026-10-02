import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/car_model.dart';
import '../services/car_service.dart';
import '../services/session_service.dart';
import '../widgets/car_image.dart';

class AddCar extends StatefulWidget {
  const AddCar({super.key});

  @override
  State<AddCar> createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  final service = CarService();
  final name = TextEditingController();
  final brand = TextEditingController();
  final model = TextEditingController();
  final year = TextEditingController();
  final price = TextEditingController();
  final location = TextEditingController();
  final desc = TextEditingController();

  bool loading = false;
  String carImage = '';
  String selectedImageName = 'No image selected';

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

  Future<void> add() async {
    final u = SessionService.currentUser;
    final y = int.tryParse(year.text.trim());
    final p = double.tryParse(price.text.trim());

    if (u == null) return;
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
    final e = await service.addCar(CarModel(
      sellerId: u.id!,
      carName: name.text.trim(),
      brand: brand.text.trim(),
      model: model.text.trim(),
      year: y,
      price: p,
      location: location.text.trim(),
      description: desc.text.trim(),
      imageUrl: carImage,
    ));
    if (!mounted) return;
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e ?? 'Car added successfully')),
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
          TextButton(onPressed: pickImage, child: const Text('Select')),
        ]),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Car Listing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [Colors.black, Colors.orange]),
            ),
            child: const Row(children: [
              Icon(Icons.add_circle, color: Colors.white, size: 45),
              SizedBox(width: 14),
              Expanded(
                child: Text('Create a car listing\nand start receiving bids.',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ]),
          ),
          const SizedBox(height: 20),
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
              onPressed: loading ? null : add,
              icon: const Icon(Icons.save),
              label: Text(loading ? 'Adding...' : 'Add Car'),
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
