import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final int stockAmount;
  final String description;
  final int categoryId;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.stockAmount,
    required this.description,
  });

  // Factory constructor for creating a product without the id (for new products)
  factory Product.create({
    required  int? id,
    required String name,
    required double price,
    required int categoryId,
    required String description,
    required int stockAmount,
    required String imageUrl,
  }) {
    return Product(
      id: 0, // Temporary id for new products, will be set by DB
      name: name,
      price: price,
      imageUrl: imageUrl,
      categoryId: categoryId,
      stockAmount: stockAmount,
      description: description,
    );
  }

  // Convert a Product instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
      'stockAmount': stockAmount,
      'description': description,
    };
  }

  // Create a Product instance from a map (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int? ?? 0, // Default to 0 if 'id' is null
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if 'name' is null
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Convert to double with default value
      imageUrl: json['imageUrl'] ?? '',
      categoryId: json["categoryId"] as int? ?? 0,  // Default to 0 if null
      description: json["description"] ?? '',
      stockAmount: json['stockAmount'] as int? ?? 0,  // Default to 0 if null
    );
  }

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? imageUrl,
    int? categoryId,
    int? stockAmount,
    String? description,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId: categoryId ?? this.categoryId,
      stockAmount: stockAmount ?? this.stockAmount,
      description: description ?? this.description,
    );
  }

  @override
  List<Object?> get props => [id, name, price, imageUrl, categoryId, stockAmount, description];
}
