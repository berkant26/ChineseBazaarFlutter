import 'package:chinese_bazaar/domain/entities/category.dart';

import '../../domain/repositories/category_repository_interface.dart';
import '../sources/category_api.dart';

class CategoryRepository implements CategoryRepositoryInterface {
  final CategoryApi api;

  CategoryRepository(this.api);

  @override
  Future<List<Category>> fetchCategories() {
    return api.fetchCategories();
  }
}
