import 'dart:convert';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/repositories/product_repository_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sources/product_api.dart';

class ProductRepository implements ProductRepositoryInterface {
  final ProductApi api;

  ProductRepository(this.api);

  @override
  Future<List<Product>> fetchProductsByCategoryId(int categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('products_$categoryId');

    if (cachedData != null) {
      print('Loading products from cache');
      // Parse and return cached data
      final List<dynamic> jsonData = jsonDecode(cachedData);
      return jsonData.map((data) => Product.fromJson(data)).toList();
    }

    print('Loading products from API');
    // Fetch from API if not cached
    final products = await api.fetchProductsByCategoryId(categoryId);
    // Cache the fetched data
    await prefs.setString('products_$categoryId', jsonEncode(products.map((e) => e.toJson()).toList()));

    return products;
  }

  @override
  Future<List<ProductImage>> fetchProductsImage(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('product_images_$productId');

    if (cachedData != null) {
      print('Loading product images from cache');
      // Parse and return cached data
      final List<dynamic> jsonData = jsonDecode(cachedData);
      return jsonData.map((data) => ProductImage.fromJson(data)).toList();
    }

    print('Loading product images from API');
    // Fetch from API if not cached
    final images = await api.fetchProductsImages(productId);
    // Cache the fetched data
    await prefs.setString('product_images_$productId', jsonEncode(images.map((e) => e.toJson()).toList()));

    return images;
  }
  
  @override
  Future<bool> addProduct(Product product) async {
    return await api.addProduct(product); // Delegate the call to the API
  }
  
}



