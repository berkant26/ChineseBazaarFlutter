import 'dart:convert';

import 'package:chinese_bazaar/data/sources/category_api.dart';
import 'package:chinese_bazaar/domain/entities/category.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CategoryRepository {
  final CategoryApi categoryApi;
  static const String _cachedCategoriesKey = 'cached_categories';

  CategoryRepository(this.categoryApi);

  Future<List<Category>> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();

    // Try to get cached data from SharedPreferences
    

    // If no cached data, fetch from API
    try {
      final categories = await categoryApi.fetchCategories();
      // Save fetched data to SharedPreferences
      final jsonData = json.encode(categories.map((e) => e.toJson()).toList());
      await prefs.setString(_cachedCategoriesKey, jsonData);
      print('Loading from db');
      return categories;
    } catch (e) {
      rethrow;
    }
  }

  // Optionally, clear cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cachedCategoriesKey);
  }
}
