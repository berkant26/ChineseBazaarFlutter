import 'package:chinese_bazaar/presentation/pages/cart_page.dart';
import 'package:chinese_bazaar/presentation/pages/home_page.dart';
import 'package:chinese_bazaar/presentation/pages/myAccountPage.dart';
import 'package:chinese_bazaar/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  static final GlobalKey<_MainPageState> mainPageKey = GlobalKey<_MainPageState>();

  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  // Define GlobalKeys for each nested navigator
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
  ];

  // Back button handling for nested navigators
  Future<bool> _onWillPop() async {
    if (_navigatorKeys[_selectedIndex].currentState?.canPop() == true) {
      _navigatorKeys[_selectedIndex].currentState?.pop();
      return false;
    }
    return true; // Allow app to close if no pages can pop
  }

  @override
  Widget build(BuildContext context) {
    print("MainPage built, selectedIndex: $_selectedIndex"); // Debug için
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: [
            _buildNavigator(0,  HomePage()),
            _buildNavigator(1, const MyAccountPage()),
            _buildNavigator(2, const CartPage()),
          ],
        ),
       bottomNavigationBar: BottomNavigationBar(
  type: BottomNavigationBarType.fixed,
  currentIndex: _selectedIndex,
  onTap: (index) {
  if (_selectedIndex != index) { // Sadece farklı bir sekme seçildiğinde değiştir
    setState(() {
      _selectedIndex = index;
    });
  } else {
    _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
  }
},
  items: const [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'AnaSayfa',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Hesabım',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_basket),
      label: 'Sepetim',
    ),
  ],
),
      ),
    );
  }

  // Helper method to create navigators for each tab
  Widget _buildNavigator(int index, Widget child) {
    return Navigator(
      key: _navigatorKeys[index],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          settings: settings,
          builder: (BuildContext context) => child,
        );
      },
    );
  }

  // Navigate programmatically to ProductListPage
  void navigateToProductListPage(String categoryName, int categoryId) {
    setState(() {
      _selectedIndex = 3; // Switch to the "Ürünler" tab
    });

    _navigatorKeys[3].currentState?.push(MaterialPageRoute(
      builder: (context) => ProductListPage(categoryName: categoryName, categoryId: categoryId),
    ));
  }
}
