class BidModel {
  final String? id;
  final String carId;
  final String buyerId;
  final String sellerId;
  final double bidAmount;
  final String bidStatus;
  final String? createdAt;

  BidModel({
    this.id,
    required this.carId,
    required this.buyerId,
    required this.sellerId,
    required this.bidAmount,
    this.bidStatus = "pending",
    this.createdAt,
  });

  factory BidModel.fromJson(Map<String, dynamic> json) {
    return BidModel(
      id: json['id'],
      carId: json['car_id'] ?? '',
      buyerId: json['buyer_id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      bidAmount: double.parse(json['bid_amount'].toString()),
      bidStatus: json['bid_status'] ?? 'pending',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'car_id': carId,
      'buyer_id': buyerId,
      'seller_id': sellerId,
      'bid_amount': bidAmount,
      'bid_status': bidStatus,
    };
  }
}