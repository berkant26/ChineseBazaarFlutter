import 'package:chinese_bazaar/domain/entities/product.dart';

abstract class ProductRepositoryInterface {
  Future<List<Product>> fetchProductsByCategoryId(int categoryId);
}
