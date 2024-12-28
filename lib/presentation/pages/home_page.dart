import 'package:chinese_bazaar/presentation/widgets/categories_list_view_widget.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/sources/category_api.dart';
import '../widgets/category_card_widget.dart';
import 'product_list_page.dart';

class HomePage extends StatelessWidget {
  final repository = CategoryRepository(CategoryApi());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: FutureBuilder<List<String>>(
        future: repository.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Bakım zamanı '));
          }

          final categories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                CategoriesListView(categories: categories),
                
              ],
            ),
          );
        },
      ),
    );
  }
}
