import 'package:chinese_bazaar/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import 'cart_event.dart';
void main() {
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
    return MaterialApp(
      title: 'Chinese Bazaar',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(), // Replace with your actual home page
    );
  }
}
class CartBloc extends Bloc<CartEvent, CartState> {
  final Map<Product, int> _cartItems = {};
  final Set<Product> _selectedProducts = {};

  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>((event, emit) {
      final currentQuantity = _cartItems[event.product] ?? 0;
      if (currentQuantity < 5) {
        _cartItems[event.product] = currentQuantity + 1;
      }
      emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
    });
on<RemoveProductEvent>((event, emit) {
  if (_cartItems.containsKey(event.product)) {
    _cartItems.remove(event.product); // Remove from cart
    _selectedProducts.remove(event.product); // Remove from selected products
    emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
  }
});

    on<ToggleProductSelectionEvent>((event, emit) {
      if (_selectedProducts.contains(event.product)) {
        _selectedProducts.remove(event.product);
      } else {
        _selectedProducts.add(event.product);
      }
      emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
    });
on<ClearCartEvent>((event, emit) {
  _cartItems.clear();
  _selectedProducts.clear();
  emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
});

    on<UpdateProductQuantityEvent>((event, emit) {
      if (event.quantity > 0 && event.quantity <= 5) {
        _cartItems[event.product] = event.quantity;
        emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
      }
    });

    on<SubmitCartEvent>((event, emit) {
      final selectedItems = _selectedProducts.map((product) {
        return {
          'product': product,
          'quantity': _cartItems[product],
        };
      }).toList();
      print('Submitting cart: $selectedItems');
      emit(CartSubmitted());
    });
  }
}
