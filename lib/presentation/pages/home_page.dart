import 'package:chinese_bazaar/domain/entities/category.dart';
import 'package:chinese_bazaar/presentation/widgets/categories_list_view_widget.dart';
import 'package:flutter/material.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/sources/category_api.dart';

class HomePage extends StatelessWidget {
  final repository = CategoryRepository(CategoryApi());

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '',
          style: TextStyle(fontSize: screenWidth * 0.05), // Responsive font size
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: repository.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(fontSize: screenWidth * 0.04), // Dynamic font size
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'Bakım zamanı',
                style: TextStyle(fontSize: screenWidth * 0.04), // Dynamic font size
              ),
            );
          }

          final List<Category> categories = snapshot.data!;
          return Padding(
            padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
            child: Column(
              children: [
                CategoriesListView(categories: categories),
                const Center(child: Text(''),)
              ],
            ),
          );
        },
      ),
    );
  }
}
