
import 'package:chinese_bazaar/data/sources/address_api.dart';
import 'package:chinese_bazaar/domain/entities/product.dart';
import 'package:chinese_bazaar/presentation/pages/payment/paymentScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chinese_bazaar/presentation/bloc/cart_bloc.dart';
import 'package:chinese_bazaar/presentation/bloc/cart_event.dart';

import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final AddressApi _addressApi = AddressApi();
  double totalPrice = 0;
  var selectedProducts;
  Map<Product, int> cartItems = {}; // Sınıf seviyesinde tanımla

  // Check if the user is logged in by looking for the 'token' in SharedPreferences
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('token');
  }

  // Handle checkout logic
  void _onCheckoutPressed() async {
    bool isLoggedIn = await _checkLoginStatus();
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final existingAddress = await _addressApi.getUserAddress(userId);

    if (!isLoggedIn) {
      // Show login prompt and navigate to LoginPage
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Giriş Yapın'),
            content: const Text('Siparişi Tamamlamak için Giriş Yapın.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  // Navigator.pushNamed(context, '/login'); // Navigate to LoginPage
                },
                child: const Text('Tamam'),
              ),
            ],
          );
        },
      );
    } else if (existingAddress == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Adres ekleyin"),
            content: const Text('Sepeti onaylamadan önce adres bilgilerini girin'),
          );
        },
      );
    } else if (totalPrice == 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sepete ürün ekleyin"),
            content: const Text('Sepete ürün ekle'),
          );
        },
      );
    } else if (isLoggedIn && totalPrice > 0) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PaymentScreen(
            totalPrice: totalPrice,
            products: selectedProducts.toList(),
            cartItems: cartItems, // Sepetteki miktarları aktar
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sepetim'),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartInitial) {
            return const Center(child: Text('Sepetiniz boş!'));
          } else if (state is CartUpdated) {
            cartItems = state.cartItems; // cartItems'ı güncelle
            selectedProducts = state.selectedProducts;

            totalPrice = selectedProducts.fold(
              0.0,
              (sum, product) => sum + (product.price * cartItems[product]!),
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems.keys.toList()[index];
                      final quantity = cartItems[product]!;

                      double productTotalPrice = product.price * quantity;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Checkbox(
                                value: selectedProducts.contains(product),
                                onChanged: (value) {
                                  context.read<CartBloc>().add(
                                        ToggleProductSelectionEvent(product),
                                      );
                                },
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  product.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(
                                      Icons.image_not_supported,
                                      size: 60,
                                      color: Colors.grey,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "${productTotalPrice.toStringAsFixed(2)} TL",
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (quantity > 1) {
                                        context.read<CartBloc>().add(
                                              UpdateProductQuantityEvent(product, quantity - 1),
                                            );
                                      }
                                    },
                                  ),
                                  Text('$quantity'),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      if (quantity < 5) {
                                        context.read<CartBloc>().add(
                                             UpdateProductQuantityEvent(product.copyWith(stockAmount: 1), quantity + 1),
                                            );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                BottomAppBar(
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Toplam: ${totalPrice.toStringAsFixed(2)}TL',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          ElevatedButton(
                            onPressed: _onCheckoutPressed,
                            child: const Text('Sepeti Onayla'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}