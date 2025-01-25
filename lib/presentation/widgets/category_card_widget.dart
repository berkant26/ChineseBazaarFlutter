import 'package:chinese_bazaar/Core/util/localization/translations.dart';
import 'package:chinese_bazaar/domain/entities/category.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryCard({required this.category, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final String translatedCategoryName = 
        categoryTranslations[category.name] ?? category.name;

    return SizedBox(
      width: screenWidth * 0.25, // Dynamically adjusts width based on screen size
      child: SingleChildScrollView(
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(screenWidth * 0.02), // Responsive corner radius
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image as the button's background
              Image.asset(
                'assets/${category.name}.png',
                width: screenWidth * 0.25, // Responsive width
                height: screenWidth * 0.25, // Responsive height
                fit: BoxFit.cover,
              ),
              // Text below the image
              Padding(
                padding: EdgeInsets.only(top: screenWidth * 0.02), // Responsive padding
                child: Text(
                  translatedCategoryName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: screenWidth * 0.04, // Responsive font size
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
