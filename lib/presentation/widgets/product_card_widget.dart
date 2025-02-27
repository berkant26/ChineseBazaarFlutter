import 'package:chinese_bazaar/presentation/bloc/cart_bloc.dart';
import 'package:chinese_bazaar/presentation/pages/product_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import '../../domain/entities/product.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final List<ProductImage> productImages;

  const ProductCard({
    required this.product,
    required this.productImages,
    super.key,
  });

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final Logger logger = Logger();
  int currentPage = 0; // Track the current page index

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the ProductDetail page when the product card is tapped
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => BlocProvider.value(
               value: BlocProvider.of<CartBloc>(context),
               child: ProductDetailPage(product: widget.product, productImages: widget.productImages),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return child;
            },
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // PageView for images
                  PageView.builder(
                    itemCount: widget.productImages.length,
                    onPageChanged: (index) {
                      setState(() {
                        currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      logger.d(
                          'Image URL: ${widget.productImages[index].imageUrl} Product ID: ${widget.productImages[index].productId}');
                      return Image.network(
                        widget.productImages[index].imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                  // Circle Dots Indicator
                  Positioned(
                    bottom: 8.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.productImages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: currentPage == index ? 12.0 : 8.0,
                          height: currentPage == index ? 12.0 : 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentPage == index
                                ? Colors.black
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                "${widget.product.price.toStringAsFixed(0)} TL",
                style: const TextStyle(fontSize: 14, color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
