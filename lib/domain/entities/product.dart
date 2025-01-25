import 'package:equatable/equatable.dart';

class Product extends Equatable { 
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final int categoryId;
  
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this. categoryId
  });
  // Factory constructor for creating a product without the id (for new products)
  factory Product.create({
    required String name,
    required double price,
    required int categoryId,
    String imageUrl = "",
  }) {
    return Product(
      id: 0, // Temporary id for new products, will be set by DB
      name: name,
      price: price,
      imageUrl: imageUrl,
      categoryId: categoryId,
    );
  }

  // Convert a Product instance to a map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'categoryId': categoryId
    };
  }

  // Create a Product instance from a map (JSON)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int, // Ensure 'id' is an integer in the response
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if 'name' is null
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Convert to double with default value
     imageUrl: json['imageUrl'] ?? '',
      categoryId: json["categoryId"] as int // Default to an empty string if 'imageUrl' is null
    );
  }

  get stockAmount => null;

  Product copyWith({
    int? id,
    String? name,
    double? price,
    String? imageUrl,
    int? categoryId
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categoryId:categoryId ?? this.categoryId
    );
  }
  
  @override
  // TODO: implement props
  List<Object?> get props => [id, name, price, imageUrl,categoryId];
}