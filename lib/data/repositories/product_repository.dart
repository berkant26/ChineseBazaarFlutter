import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository_interface.dart';
import '../sources/product_api.dart';

class ProductRepository implements ProductRepositoryInterface {
  final ProductApi api;

  ProductRepository(this.api);


  @override
  Future<List<Product>> fetchProductsByCategoryId(int categoryId) {
    return api.fetchProductsByCategoryId(categoryId);
  }
}
