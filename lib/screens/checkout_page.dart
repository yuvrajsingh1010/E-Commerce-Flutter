import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

/// The CheckoutPage displays the items in the cart and allows the user to place an order.
/// It shows the total price and includes a button to proceed with the order.
class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'), // Title of the checkout page
      ),
      body: cartProvider.cartItems.isEmpty
          ? const Center(child: Text('Your cart is empty!')) // Message when cart is empty
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length, // Number of items in the cart
                    itemBuilder: (ctx, i) {
                      final cartItem = cartProvider.cartItems[i];
                      return ListTile(
                        title: Text(cartItem.product.title), // Product title
                        subtitle: Text('\$${cartItem.product.price}'), // Product price
                        trailing: Text('x${cartItem.quantity}'), // Display quantity
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${cartProvider.totalPrice.toStringAsFixed(2)}', // Display total price
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Process checkout by clearing the cart and navigating to the order confirmation page
                          cartProvider.clearCart(); // Clear the cart after order placement
                          Navigator.pushReplacementNamed(context, '/order-confirmation'); // Navigate to confirmation page
                        },
                        child: const Text('Place Order'), // Button to place the order
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
