import 'package:chinese_bazaar/Core/util/localization/translations.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final VoidCallback onTap;

  const CategoryCard({required this.category, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
final String translatedCategoryName = categoryTranslations[category] ?? category;
    
    return SizedBox(
      width: 100,
      child: SingleChildScrollView( // Wrap the entire button with a scroll view
  child: ElevatedButton(
    onPressed: () {
      // Define the action when the button is pressed
    },
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.zero, backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Make the button background transparent
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), // Optional: to give rounded corners
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min, // Ensures the column takes minimal space
      children: [
        // Image as the button's background
        Image.asset(
          'assets/${category}.png', // Your image path
          width: 100, // You can adjust the width and height as needed
          height: 100,
          fit: BoxFit.cover, // Makes the image cover the button area
        ),
        // Text below the image
         Padding(
          padding: const EdgeInsets.only(top: 8.0), // Adds space between image and text
          child: Text(
            translatedCategoryName, // Your category name
            style: TextStyle(
              color: Colors.black, // Text color
              fontSize: 16, // Text size
              fontWeight: FontWeight.bold, // Optional: to make the text bold
            ),
          ),
        ),
      ],
    ),
  ),
)
  
    );
  }
}