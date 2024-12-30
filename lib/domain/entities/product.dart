class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  // Convert a Product instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Create a Product instance from a map (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int, // Ensure 'id' is an integer in the response
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if 'name' is null
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Convert to double with default value
      imageUrl: json['imageUrl'] ?? '', // Default to an empty string if 'imageUrl' is null
    );
  }
}