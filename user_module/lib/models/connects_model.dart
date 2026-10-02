class ConnectsTransactionModel {
  final String? id;
  final String userId;
  final String type;
  final String feature;
  final int connects;
  final double amount;
  final String status;
  final String? createdAt;

  ConnectsTransactionModel({
    this.id,
    required this.userId,
    required this.type,
    required this.feature,
    required this.connects,
    required this.amount,
    this.status = "success",
    this.createdAt,
  });

  factory ConnectsTransactionModel.fromJson(Map<String, dynamic> json) {
    return ConnectsTransactionModel(
      id: json['id'],
      userId: json['user_id'] ?? '',
      type: json['type'] ?? '',
      feature: json['feature'] ?? '',
      connects: json['connects'] ?? 0,
      amount: double.parse(json['amount'].toString()),
      status: json['status'] ?? 'success',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'type': type,
      'feature': feature,
      'connects': connects,
      'amount': amount,
      'status': status,
    };
  }
}