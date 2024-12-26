import '../../domain/repositories/category_repository_interface.dart';
import '../sources/category_api.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final CategoryApi api;

  CategoryRepository(this.api);

  @override
  Future<List<String>> fetchCategories() {
    return api.fetchCategories();
  }
}
