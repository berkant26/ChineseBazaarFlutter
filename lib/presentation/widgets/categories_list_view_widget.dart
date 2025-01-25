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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: screenHeight * 0.25, // Dynamic height for the container
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02), // Responsive padding
            child: Text(
              'Kategoriler',
              style: TextStyle(fontSize: screenWidth * 0.04), // Dynamic font size
            ),
          ),
          SizedBox(
            height: screenHeight * 0.18, // Dynamic height for the ListView
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Responsive spacing
                  child: CategoryCard(
                    category: categories[index],
                    onTap: () {  
                      Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProductListPage(
      categoryName: categories[index].name,
      categoryId: categories[index].id,
    ),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child; // No transition animation
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
