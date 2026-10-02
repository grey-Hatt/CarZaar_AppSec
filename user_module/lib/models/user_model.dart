class UserModel {
  final String? id;
  final String name;
  final String email;
  final String password;
  final String phone;
  final String city;
  final String? profileImage;
  final bool isVerified;
  final String status;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.city,
    this.profileImage,
    this.isVerified = false,
    this.status = "active",
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      phone: json['phone'] ?? '',
      city: json['city'] ?? '',
      profileImage: json['profile_image'],
      isVerified: json['is_verified'] ?? false,
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'city': city,
      'profile_image': profileImage,
      'is_verified': isVerified,
      'status': status,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? phone,
    String? city,
    String? profileImage,
    bool? isVerified,
    String? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      profileImage: profileImage ?? this.profileImage,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
    );
  }
}
