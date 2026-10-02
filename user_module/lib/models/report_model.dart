class ReportModel {
  final String? id;
  final String reportedBy;
  final String? reportedUser;
  final String? carId;
  final String reason;
  final String description;
  final String status;
  final String? createdAt;

  ReportModel({
    this.id,
    required this.reportedBy,
    this.reportedUser,
    this.carId,
    required this.reason,
    required this.description,
    this.status = "pending",
    this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'],
      reportedBy: json['reported_by'] ?? '',
      reportedUser: json['reported_user'],
      carId: json['car_id'],
      reason: json['reason'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 'pending',
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reported_by': reportedBy,
      'reported_user': reportedUser,
      'car_id': carId,
      'reason': reason,
      'description': description,
      'status': status,
    };
  }
}