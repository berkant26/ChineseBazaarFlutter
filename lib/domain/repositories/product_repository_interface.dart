import 'package:chinese_bazaar/data/sources/product_api.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/domain/entities/productImage.dart';
import 'package:file_picker/file_picker.dart';

abstract class ProductRepositoryInterface {
  Future<List<Product>> fetchProductsByCategoryId(int categoryId);
  Future<List<Product>> fetchAllProducts();

  Future<List<ProductImage>> fetchProductsImage(int productId);
  Future<bool> uploadProductImages(int productId, List<PlatformFile> selectedImages);
  Future<ProductAddResult> addProduct(Product product);
   Future<bool> updateProductImages(int productId, List<PlatformFile> selectedImages);
  Future<ProductAddResult> updateProduct(Product product,int productId);
  Future<bool> deleteProduct(int productId);
}

