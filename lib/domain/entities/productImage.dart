class ProductImage {
  final int id;
  final int productId;
  final String imageUrl;

  ProductImage({
    required this.id,
    required this.productId,
    required this.imageUrl,
  });

  // From JSON to ProductImage
  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] as int,
      productId: json['productId'] as int,
      imageUrl: json['imageUrl'] ?? '', // Use corrected field name
    );
  }

  // Convert ProductImage to Map (to JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'imageUrl': imageUrl,
    };
  }
}
