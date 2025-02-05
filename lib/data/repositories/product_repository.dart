import 'dart:convert';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/repositories/product_repository_interface.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sources/product_api.dart';

class ProductRepository implements ProductRepositoryInterface {
  final ProductApi api;

  ProductRepository(this.api);

  @override
  Future<List<Product>> fetchProductsByCategoryId(int categoryId) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('products_$categoryId');

   

    // Fetch from API if not cached
    final products = await api.fetchProductsByCategoryId(categoryId);
    // Cache the fetched data
    await prefs.setString('products_$categoryId', jsonEncode(products.map((e) => e.toJson()).toList()));

    return products;
  }

  @override
  Future<List<ProductImage>> fetchProductsImage(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    

    

    // Fetch from API if not cached
    final images = await api.fetchProductsImages(productId);
    // Cache the fetched data
    await prefs.setString('product_images_$productId', jsonEncode(images.map((e) => e.toJson()).toList()));

    return images;
  }
  
  @override
  Future<ProductAddResult> addProduct(Product product) {
    return ProductApi().addProduct(product);
  }
  
  @override
  Future<bool> uploadProductImages(int productId, List<PlatformFile> selectedImages) {
    return ProductApi().uploadProductImages(productId, selectedImages);
  }
  
  @override
  Future<ProductAddResult> updateProduct(Product product,int productId) {
    return ProductApi().updateProduct(productId,product);

  }
  
  @override
  Future<bool> updateProductImages(int productId, List<PlatformFile> selectedImages) {
    return ProductApi().updateProductImages(productId, selectedImages);

  }
  
  @override
  Future<List<Product>> fetchAllProducts() {
    return ProductApi().fetchAllProducts();
  }
  
  @override
  Future<bool> deleteProduct(Product product) {
    return ProductApi().deleteProduct(product);
  }
  
  @override
  Future<bool> deleteProductImages(List<ProductImage> productImage) {
        return ProductApi().deleteProductImage(productImage);

  }
  
  



  
  
}



