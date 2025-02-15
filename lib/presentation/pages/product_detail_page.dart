import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chinese_bazaar/presentation/bloc/cart_bloc.dart';
import 'package:chinese_bazaar/presentation/bloc/cart_event.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../domain/entities/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;
  final List<ProductImage> productImages;

  const ProductDetailPage({super.key, required this.product, required this.productImages});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final PageController pageController = PageController();

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display product images
            SizedBox(
              height: screenHeight * 0.4,
              child: PageView.builder(
                controller: pageController,
                itemCount: productImages.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    productImages[index].imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
            // Page Indicator
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                child: SmoothPageIndicator(
                  controller: pageController,
                  count: productImages.length,
                  effect: const ExpandingDotsEffect(
                    dotWidth: 8.0,
                    dotHeight: 8.0,
                    spacing: 4.0,
                    dotColor: Colors.grey,
                    activeDotColor: Colors.blue,
                  ),
                ),
              ),
            ),
            // Product Name
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Text(
                product.name,
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Product Price
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Text(
                "${product.price.toStringAsFixed(2)} TL",
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: Colors.green,
                ),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
              child: Text(
                product.description,
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
          width: double.infinity,
          height: screenHeight * 0.08,
          child: ElevatedButton(
            onPressed: () {
              final updatedProduct = product.copyWith(imageUrl: productImages[0].imageUrl);
              context.read<CartBloc>().add(AddToCartEvent(updatedProduct));
                        
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sepete Eklendi"),duration:Duration(seconds: 1),backgroundColor: const Color.fromARGB(255, 59, 231, 65),));
                      },
            
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            child: const Text('Sepete Ekle', style: TextStyle(color: Colors.white)),
          ),
        ),
        
      ),
      
    );
    
  }
  
}

