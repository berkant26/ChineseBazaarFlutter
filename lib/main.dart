
import 'package:chinese_bazaar/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chinese Bazaar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home:  HomePage(),
    );
  }
}

