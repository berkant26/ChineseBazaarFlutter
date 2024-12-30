class Category {
  final int id;
  final String name;

  Category({required this.name, required this.id});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as int, // Assuming the JSON has 'id' field
      name: json['categoryName'] ?? 'Unknown', // Default to 'Unknown' if 'categoryName' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'categoryName': name, // Convert the name to 'categoryName' for API requests
    };
  }
}