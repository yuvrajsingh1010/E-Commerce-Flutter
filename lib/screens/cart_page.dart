import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

/// The CartPage displays the shopping cart and allows users to modify quantities or remove items.
/// It also shows the total price and provides a checkout button if the cart is not empty.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'), // Title of the cart page
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty!', // Message when the cart is empty
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length, // Number of items in the cart
                    itemBuilder: (ctx, i) {
                      final cartItem = cartProvider.cartItems[i];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                        child: ListTile(
                          leading: Image.network(
                            cartItem.product.image, // Display product image
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image, // Fallback icon if image fails to load
                                size: 50,
                                color: Colors.grey,
                              );
                            },
                          ),
                          title: Text(
                            cartItem.product.title, // Display product title
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            '\$${cartItem.product.price.toStringAsFixed(2)}', // Display product price
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Quantity controls (decrement, quantity display, increment)
                              IconButton(
                                icon: const Icon(Icons.remove), // Decrease quantity
                                onPressed: () {
                                  if (cartItem.quantity > 1) {
                                    cartProvider.updateQuantity(
                                      cartItem.product,
                                      cartItem.quantity - 1,
                                    );
                                  }
                                },
                              ),
                              Text(
                                '${cartItem.quantity}', // Display current quantity
                                style: const TextStyle(fontSize: 16),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add), // Increase quantity
                                onPressed: () {
                                  cartProvider.updateQuantity(
                                    cartItem.product,
                                    cartItem.quantity + 1,
                                  );
                                },
                              ),
                              // Delete button to remove item from the cart
                              IconButton(
                                icon: const Icon(Icons.delete),
                                color: Colors.red,
                                onPressed: () {
                                  cartProvider.removeFromCart(cartItem.product);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}', // Display total price
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: cartProvider.cartItems.isEmpty
                            ? null // Disable button if the cart is empty
                            : () {
                                Navigator.pushNamed(context, '/checkout'); // Navigate to checkout page
                              },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        ),
                        child: const Text('Checkout'), // Checkout button text
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
