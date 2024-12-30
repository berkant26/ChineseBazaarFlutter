import 'package:chinese_bazaar/domain/entities/category.dart';
import 'package:chinese_bazaar/presentation/pages/product_list_page.dart';
import 'package:chinese_bazaar/presentation/widgets/category_card_widget.dart';
import 'package:flutter/material.dart';

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({
    super.key,
    required this.categories,
  });

  final List<Category> categories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
          height: 200, // Adjusted to allow space for both the text and the list
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns the text to the start
            children: [
    const Padding(
      padding: EdgeInsets.all(8.0), // Adds padding around the text
      child: Text(
        'Kategoriler', // The title text
        style: TextStyle(fontSize: 15), // Optional: styling the text
      ),
    ),
          SizedBox(
            height: 150, // Limits the height of the ListView
            child: ListView.builder(
    scrollDirection: Axis.horizontal, // Enables horizontal scrolling
    itemCount: categories.length, // Number of items
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0), // Adds spacing between cards
        child: CategoryCard(
          category: categories[index], // Pass the category name
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ProductListPage(categoryName: categories[index].name,categoryId:categories[index].id),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    ),
            );
          },
        ),
      );
    },
            ),
          ),
        ],
      ),
    );
  }
}
