class CarModel {
  final String? id;
  final String sellerId;
  final String carName;
  final String brand;
  final String model;
  final int year;
  final double price;
  final String description;
  final String location;
  final String imageUrl;
  final String status;
  final bool isFeatured;

  CarModel({
    this.id,
    required this.sellerId,
    required this.carName,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.description,
    required this.location,
    this.imageUrl = '',
    this.status = 'active',
    this.isFeatured = false,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        id: json['id'],
        sellerId: json['seller_id'] ?? '',
        carName: json['car_name'] ?? '',
        brand: json['brand'] ?? '',
        model: json['model'] ?? '',
        year: int.tryParse(json['year'].toString()) ?? 0,
        price: double.tryParse(json['price'].toString()) ?? 0,
        description: json['description'] ?? '',
        location: json['location'] ?? '',
        imageUrl: json['image_url'] ?? '',
        status: json['status'] ?? 'active',
        isFeatured: json['is_featured'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'seller_id': sellerId,
        'car_name': carName,
        'brand': brand,
        'model': model,
        'year': year,
        'price': price,
        'description': description,
        'location': location,
        'image_url': imageUrl,
        'status': status,
        'is_featured': isFeatured,
      };
}
