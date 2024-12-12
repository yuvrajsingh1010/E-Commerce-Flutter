import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/auth_provider.dart';
import 'screens/homepage.dart';
import 'screens/auth_page.dart';
import 'screens/cart_page.dart';
import 'screens/checkout_page.dart'; // Import the CheckoutPage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Providing ProductProvider, CartProvider, and AuthProvider for the app
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'E-Commerce App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(
            color: Colors.purple, // AppBar color
            elevation: 4, // AppBar shadow effect
          ),
        ),
        // Set initial route to login page if user is not authenticated
        initialRoute: '/login',
        routes: {
          '/': (ctx) => const HomePage(), // Home page route
          '/login': (ctx) => const AuthPage(), // Login page route
          '/cart': (ctx) => CartPage(), // Cart page route
          '/checkout': (ctx) =>CheckoutPage(), // Checkout page route
        },
      ),
    );
  }
}
