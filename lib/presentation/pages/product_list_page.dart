import 'package:flutter/material.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/sources/product_api.dart';
import '../widgets/product_card.dart';
import '../../domain/entities/product.dart';

class ProductListPage extends StatelessWidget {
  final String category;
  final repository = ProductRepository(ProductApi());

  ProductListPage({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products in $category')),
      body: FutureBuilder<List<Product>>(
        future: repository.fetchProductsByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          final products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return ProductCard(product: products[index]);
            },
          );
        },
      ),
    );
  }
}
