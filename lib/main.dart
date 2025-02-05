import 'dart:io';

import 'package:chinese_bazaar/data/sources/login_api.dart';
import 'package:chinese_bazaar/presentation/bloc/cart_bloc.dart';
import 'package:chinese_bazaar/presentation/pages/main_page.dart';
import 'package:chinese_bazaar/presentation/pages/myAccountPage.dart';
import 'package:flutter/material.dart';
import 'package:chinese_bazaar/Core/util/Router/fadeRouter.dart';
import 'package:chinese_bazaar/presentation/pages/auth/login_page.dart';
import 'package:chinese_bazaar/presentation/pages/auth/register_page.dart';
import 'package:chinese_bazaar/presentation/pages/cart_page.dart';
import 'package:chinese_bazaar/presentation/pages/product_list_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/pages/home_page.dart';
void main() {
  AuthApi().initialize(); 
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    BlocProvider(
      create: (context) => CartBloc(),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var appTitle = 'Chinese Bazaar';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return fadePageRoute(LoginPage());
          case '/cart':
            return fadePageRoute( const CartPage());
          case '/register':
            return fadePageRoute(const RegisterPage());
          case '/myAccount':
            return fadePageRoute(const MyAccountPage());
          case '/productList':
            final args = settings.arguments as Map<String, dynamic>;
            return fadePageRoute(ProductListPage(
              categoryName: args['categoryName'],
              categoryId: args['categoryId'],
            ));
          default:
            return fadePageRoute(HomePage());
        }
      },
    );
  }
}
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}