import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

/// A provider class for managing the cart state, including adding, removing, and updating items.
class CartProvider with ChangeNotifier {
  /// A private list to hold the cart items.
  final List<CartItem> _cartItems = [];

  /// Returns an unmodifiable list of cart items.
  List<CartItem> get cartItems => List.unmodifiable(_cartItems);

  /// Adds a product to the cart.
  /// If the product is already in the cart, the quantity is increased by 1.
  ///
  /// - [product]: The product to be added to the cart.
  void addToCart(Product product) {
    // Check if the product is already in the cart
    final existingItemIndex = _cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex >= 0) {
      // If product is already in cart, increase its quantity
      _cartItems[existingItemIndex].quantity++;
    } else {
      // If product is not in cart, add it with quantity 1
      _cartItems.add(CartItem(product: product));
    }

    // Notify listeners about the cart state change
    notifyListeners();
  }

  /// Removes a product from the cart.
  ///
  /// - [product]: The product to be removed from the cart.
  void removeFromCart(Product product) {
    // Find the index of the product in the cart
    final existingItemIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
    if (existingItemIndex >= 0) {
      // Remove the product if it exists in the cart
      _cartItems.removeAt(existingItemIndex);
      // Notify listeners that the cart has been updated
      notifyListeners();
    }
  }

  /// Updates the quantity of a product in the cart.
  /// If the quantity is 0 or less, the product is removed from the cart.
  ///
  /// - [product]: The product whose quantity is to be updated.
  /// - [quantity]: The new quantity for the product.
  void updateQuantity(Product product, int quantity) {
    if (quantity <= 0) {
      // If quantity is 0 or less, remove the product from the cart
      removeFromCart(product);
    } else {
      // Find the product in the cart
      final existingItemIndex = _cartItems.indexWhere((item) => item.product.id == product.id);
      if (existingItemIndex >= 0) {
        // Update the quantity of the existing product
        _cartItems[existingItemIndex].quantity = quantity;
        // Notify listeners that the quantity has been updated
        notifyListeners();
      }
    }
  }

  /// Calculates and returns the total price of all products in the cart.
  double get totalPrice {
    return _cartItems.fold(0.0, (sum, item) {
      // Sum the total price of each cart item (price * quantity)
      return sum + (item.product.price * item.quantity);
    });
  }

  /// Clears all items from the cart.
  void clearCart() {
    // Clear the list of cart items
    _cartItems.clear();
    // Notify listeners that the cart has been cleared
    notifyListeners();
  }
}
