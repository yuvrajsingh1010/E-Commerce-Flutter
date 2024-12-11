import './product.dart';

/// Represents a single item in the shopping cart.
class CartItem {
  /// The product associated with this cart item.
  final Product product;

  /// The quantity of the product in the cart.
  /// Defaults to 1 if not explicitly set.
  int quantity;

  /// Constructor for creating a [CartItem] instance.
  /// Requires a [Product] and optionally allows specifying the initial [quantity].
  CartItem({required this.product, this.quantity = 1});
}
