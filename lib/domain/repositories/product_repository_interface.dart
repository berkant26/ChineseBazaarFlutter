import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';

abstract class ProductRepositoryInterface {
  Future<List<Product>> fetchProductsByCategoryId(int categoryId);
  Future<List<ProductImage>> fetchProductsImage(int productId);
  Future<bool>addProduct(Product product);
  
}
