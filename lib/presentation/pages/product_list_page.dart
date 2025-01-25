import 'package:chinese_bazaar/Core/util/localization/translations.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/sources/product_api.dart';
import '../widgets/product_card_widget.dart';
import '../../domain/entities/product.dart';

class ProductListPage extends StatelessWidget {
  final String categoryName;
  final int categoryId;
  final repository = ProductRepository(ProductApi());

  ProductListPage({required this.categoryName, super.key, required this.categoryId});

   @override
  Widget build(BuildContext context) {
    final String translatedCategoryName = categoryTranslations[categoryName] ?? categoryName;

    return Scaffold(
      appBar: AppBar(title: Text('$translatedCategoryName ürünleri')),
      body: FutureBuilder<List<Product>>(
        future: repository.fetchProductsByCategoryId(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found'));
          }
          final products = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Set 2 items per row
              crossAxisSpacing: 8.0, // Space between items horizontally
              mainAxisSpacing: 8.0, // Space between items vertically
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              // Fetch images for each product
              return FutureBuilder<List<ProductImage>>(
                future: repository.fetchProductsImage(products[index].id), // Fetch images for the product
                builder: (context, imageSnapshot) {
                  if (imageSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (imageSnapshot.hasError) {
                    return Center(child: Text('Error: ${imageSnapshot.error}'));
                  } else if (!imageSnapshot.hasData || imageSnapshot.data!.isEmpty) {
                    return const Center(child: Text('No images available'));
                  }
                  final images = imageSnapshot.data!;
                  return ProductCard(
                    product: products[index],
                    productImages: images,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
