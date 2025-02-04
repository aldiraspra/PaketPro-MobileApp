class Package {
  final String key; // Unique key Firebase
  final String id;
  final String jalur;
  final String status;
  final String? updatedAt;

  Package({
    required this.key,
    required this.id,
    required this.jalur,
    required this.status,
    this.updatedAt,
  });

  //mengambil
  factory Package.fromMap(String key, Map<dynamic, dynamic> data) {
    return Package(
      key: key,
      id: data['id'] as String,
      jalur: data['jalur'] as String,
      status: data['status'] as String,
      updatedAt: data['updated_at'] as String?,
    );
  }
  
  //menyimpan
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jalur': jalur,
      'status': status,
      'updated_at': updatedAt,
    };
  }
}
