class CompanyModel {
  final int id;
  final String name;
  final String description;
  final String type;
  final String website;
  final String phone;
  final String email;
  final String address;
  final double latitude;
  final double longitude;

  CompanyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.website,
    required this.phone,
    required this.email,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      website: json['website'] ?? '',
      phone: (json['phone'] as String? ?? '').split(',').first.trim(),
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'website': website,
      'phone': phone,
      'email': email,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
