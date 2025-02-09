import 'package:chinese_bazaar/data/repositories/product_repository.dart';
import 'package:chinese_bazaar/data/sources/product_api.dart';
import 'package:chinese_bazaar/domain/entities/category.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:chinese_bazaar/presentation/widgets/categories_list_view_widget.dart';
import 'package:chinese_bazaar/presentation/widgets/product_card_widget.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/sources/category_api.dart';

class HomePage extends StatelessWidget {
  final repository = CategoryRepository(CategoryApi());
  final productRepository = ProductRepository(ProductApi());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontSize: screenWidth * 0.05), // Responsive font size
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: repository.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: screenWidth * 0.04), // Dynamic font size
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Bakım zamanı',
                style: TextStyle(fontSize: screenWidth * 0.04), // Dynamic font size
              ),
            );
          }

          final List<Category> categories = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
            child: SingleChildScrollView( // Make the whole body scrollable
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoriesListView(categories: categories),
                  // Displaying products here -------------------------------
                  FutureBuilder<List<Product>>(
                    future: productRepository.fetchAllProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No products available'));
                      }

                      final List<Product> products = snapshot.data!;
                      return Padding(
                        padding: EdgeInsets.all(screenWidth * 0.02),
                        child: GridView.builder(
                          shrinkWrap: true, // Ensure GridView takes up only as much space as needed
                          physics: NeverScrollableScrollPhysics(), // Prevent GridView from scrolling independently
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // Adjust for responsive layout
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            childAspectRatio: 0.75, // Adjust based on design
                          ),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            return FutureBuilder<List<ProductImage>>(
                              future: productRepository.fetchProductsImage(products[index].id),
                              builder: (context, imageSnapshot) {
                                if (imageSnapshot.connectionState == ConnectionState.waiting) {
                                  return SizedBox(
                                    height: 200, // Prevent layout issues
                                    child: const Center(child: CircularProgressIndicator()),
                                  );
                                } else if (imageSnapshot.hasError) {
                                  return SizedBox(
                                    height: 200,
                                    child: Center(child: Text('Error: ${imageSnapshot.error}')),
                                  );
                                } else if (!imageSnapshot.hasData || imageSnapshot.data!.isEmpty) {
                                  return SizedBox(
                                    height: 200,
                                    child: const Center(child: Text('No images available')),
                                  );
                                }

                                final images = imageSnapshot.data!;
                                return ProductCard(
                                  product: products[index],
                                  productImages: images,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

