import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/product_tile.dart';

/// The HomePage displays a list of products with options to filter and sort the list.
/// Users can search for products, filter by category, price range, and rating, and sort by price or rating.
/// It also includes logout and cart buttons in the app bar.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedSortOption = 'Price: Low to High'; // Default sort option
  String selectedCategory = 'All'; // Default category filter
  RangeValues selectedPriceRange = const RangeValues(0, 500); // Default price range
  double selectedRating = 0; // Default rating filter
  String searchQuery = ''; // Search query for products

  @override
  void initState() {
    super.initState();
    // Load products when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // Redirect to login if the user is not logged in
    if (!authProvider.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Commerce App'), // Title of the home page
        actions: [
          // Logout Button
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.logout();
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page after logout
              }
            },
          ),
          // Cart Button
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              if (mounted) {
                Navigator.pushNamed(context, '/cart'); // Navigate to cart page
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar for product search functionality
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                setState(() {
                  searchQuery = query;
                });
                productProvider.searchProducts(query); // Apply search filter
                productProvider.applyFiltersAndSort(); // Apply filters and sort after search
              },
            ),
          ),

          // Sorting and Filtering Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Category Dropdown for filtering products by category
                DropdownButton<String>(
                  value: selectedCategory,
                  onChanged: (category) {
                    if (category != null) {
                      setState(() {
                        selectedCategory = category; // Update selected category
                      });

                      productProvider.filterProductsByCategory(category); // Apply category filter
                    }
                  },
                  items: [
                    'All', // Default category
                    "Women's Clothing",
                    "Men's Clothing",
                    'Electronics',
                    'Jewelery',
                  ].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),

                // Sort Dropdown for sorting products
                DropdownButton<String>(
                  value: selectedSortOption,
                  onChanged: (sortOption) {
                    if (sortOption != null) {
                      setState(() {
                        selectedSortOption = sortOption; // Update selected sort option
                      });

                      productProvider.sortProducts(sortOption);  // Apply sorting
                    }
                  },
                  items: [
                    'Price: Low to High',
                    'Price: High to Low',
                    'Rating: High to Low',
                    'Rating: Low to High',
                  ].map((sortOption) {
                    return DropdownMenuItem(
                      value: sortOption,
                      child: Text(sortOption),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Price Range Filter (Compact horizontal slider)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter by Price Range'),
                Slider(
                  value: selectedPriceRange.end,
                  min: selectedPriceRange.start,
                  max: 1000, // Maximum price limit
                  divisions: 20, // Number of divisions in the slider
                  label: '\$${selectedPriceRange.end.round()}',
                  onChanged: (value) {
                    setState(() {
                      selectedPriceRange = RangeValues(selectedPriceRange.start, value); // Update price range
                    });
                    productProvider.filterProductsByPriceRange(
                      minPrice: selectedPriceRange.start,
                      maxPrice: selectedPriceRange.end,
                    );
                    productProvider.applyFiltersAndSort();  // Apply filters and sort after change
                  },
                ),
              ],
            ),
          ),

          // Rating Filter (Compact clickable rating stars)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filter by Rating'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < selectedRating
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () {
                        setState(() {
                          selectedRating = index + 1; // Set the selected rating
                        });
                        productProvider.filterProductsByRating(selectedRating); // Apply rating filter
                        productProvider.applyFiltersAndSort();  // Apply filters and sort after change
                      },
                    );
                  }),
                ),
              ],
            ),
          ),

          // Product List
          Expanded(
            child: productProvider.filteredProducts.isEmpty
                ? const Center(child: Text('No products found.')) // Display message when no products match filters
                : ListView.builder(
                    itemCount: productProvider.filteredProducts.length,
                    itemBuilder: (ctx, i) {
                      return ProductTile(
                        product: productProvider.filteredProducts[i], // Display each filtered product
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
