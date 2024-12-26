import 'package:flutter/material.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/sources/category_api.dart';
import '../widgets/category_card.dart';
import 'product_list_page.dart';

class HomePage extends StatelessWidget {
  final repository = CategoryRepository(CategoryApi());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories')),
      body: FutureBuilder<List<String>>(
        future: repository.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          final categories = snapshot.data!;
          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return CategoryCard(
                category: categories[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListPage(category: categories[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
