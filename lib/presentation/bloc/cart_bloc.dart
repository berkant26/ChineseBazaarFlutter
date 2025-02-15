import 'package:chinese_bazaar/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
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
  final Logger _logger = Logger();

  CartBloc() : super(CartInitial()) {
    on<AddToCartEvent>(_onAddToCart);
    on<UpdateProductQuantityEvent>(_onUpdateProductQuantity);
    on<RemoveProductEvent>(_onRemoveProduct);
    on<ToggleProductSelectionEvent>(_onToggleProductSelection);
    on<ClearCartEvent>(_onClearCart);
    on<SubmitCartEvent>(_onSubmitCart);
  }

  // Handler for AddToCartEvent
  void _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) {
    final currentQuantity = _cartItems[event.product] ?? 0;
    if (currentQuantity < 5) {
      _cartItems[event.product] = currentQuantity + 1;
    }
    emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
  }

  // Handler for UpdateProductQuantityEvent
  void _onUpdateProductQuantity(UpdateProductQuantityEvent event, Emitter<CartState> emit) {
    _logger.d("Updating quantity for product: ${event.product.name}");
    _logger.d("Current quantity: ${_cartItems[event.product]}");
    _logger.d("Requested quantity: ${event.quantity}");

    if (event.quantity > 0 && event.quantity <= 5) {
      // Update the quantity directly without creating a new product
      _cartItems[event.product] = event.quantity;
      _logger.d("Updated product quantity. Cart now: $_cartItems");

      emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
    } else {
      _logger.d("Quantity is out of bounds (0 or > 5). No update made.");
    }
  }

  // Handler for RemoveProductEvent
  void _onRemoveProduct(RemoveProductEvent event, Emitter<CartState> emit) {
    if (_cartItems.containsKey(event.product)) {
      _cartItems.remove(event.product); // Remove from cart
      _selectedProducts.remove(event.product); // Remove from selected products
      emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
    }
  }

  // Handler for ToggleProductSelectionEvent
  void _onToggleProductSelection(ToggleProductSelectionEvent event, Emitter<CartState> emit) {
    if (_selectedProducts.contains(event.product)) {
      _selectedProducts.remove(event.product);
    } else {
      _selectedProducts.add(event.product);
    }
    emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
  }

  // Handler for ClearCartEvent
  void _onClearCart(ClearCartEvent event, Emitter<CartState> emit) {
    _cartItems.clear();
    _selectedProducts.clear();
    emit(CartUpdated(Map.from(_cartItems), Set.from(_selectedProducts)));
  }

  // Handler for SubmitCartEvent
  void _onSubmitCart(SubmitCartEvent event, Emitter<CartState> emit) {
    final selectedItems = _selectedProducts.map((product) {
      return {
        'product': product,
        'quantity': _cartItems[product],
      };
    }).toList();
    _logger.d('Submitting cart: $selectedItems');
    emit(CartSubmitted());
  }
}