import 'package:chinese_bazaar/domain/entities/category.dart';

abstract class CategoryRepositoryInterface {
  Future<List<Category>> fetchCategories();
}