import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Horizontal scrollable image row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Add images for the product (use a placeholder image if no image URL)
                Image.network(
                  product.imageUrl,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
                // If you have more images, you can add them like this:
                // Image.network(product.otherImageUrl, width: 100, height: 100, fit: BoxFit.cover),
              ],
            ),
          ),
          // Product name and price
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.name,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }



}
