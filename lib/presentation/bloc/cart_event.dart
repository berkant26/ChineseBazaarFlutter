import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

// Base CartEvent class
abstract class CartEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Event to add a product to the cart
class AddToCartEvent extends CartEvent {
  final Product product;

  AddToCartEvent(this.product);

  @override
  List<Object?> get props => [product];
}

// Event to toggle the selection state of a product
class ToggleProductSelectionEvent extends CartEvent {
  final Product product;

  ToggleProductSelectionEvent(this.product);

  @override
  List<Object?> get props => [product];
}

// Event to update the quantity of a product in the cart
class UpdateProductQuantityEvent extends CartEvent {
  final Product product;
  final int quantity;

  UpdateProductQuantityEvent(this.product, this.quantity);

  @override
  List<Object?> get props => [product, quantity];
}

// Event to submit the cart (e.g., simulate checkout or payment)
class SubmitCartEvent extends CartEvent {
  SubmitCartEvent();

  @override
  List<Object?> get props => [];
}
// Event to remove a product from the cart
class RemoveProductEvent extends CartEvent {
  final Product product;

  RemoveProductEvent(this.product);

  @override
  List<Object?> get props => [product];
}

class ClearCartEvent extends CartEvent {}

abstract class CartState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartUpdated extends CartState {
  final Map<Product, int> cartItems;
  final Set<Product> selectedProducts;

  CartUpdated(this.cartItems, this.selectedProducts);

  @override
  List<Object?> get props => [cartItems, selectedProducts];
}

class CartSubmitted extends CartState {}