import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';

/// The `ProductDetailPage` displays detailed information about a specific product,
/// including an image, title, price, description, rating, and category.
/// It also allows the user to add the product to their shopping cart.
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title), // Display product title in app bar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image displayed at the top
            Image.network(
              product.image,
              fit: BoxFit.contain, // Ensure image fits within the container
              height: 300, // Fixed height for the image
              width: double.infinity, // Full width of the screen
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.title, // Product title
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '\$${product.price}', // Display product price with currency symbol
                style: const TextStyle(fontSize: 20, color: Colors.green), // Green text for price
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description, // Product description
                style: const TextStyle(fontSize: 16), // Style for description text
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Product rating displayed in stars
                  Text(
                    'Rating: ${product.rating} ⭐',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  // Product category displayed
                  Text(
                    'Category: ${product.category}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            // Button to add product to cart
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Add product to cart when the button is pressed
                  cartProvider.addToCart(product);
                  // Show a snackbar notification confirming the action
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.title} added to cart!')),
                  );
                },
                child: const Text('Add to Cart'), // Button label
              ),
            ),
          ],
        ),
      ),
    );
  }
}
