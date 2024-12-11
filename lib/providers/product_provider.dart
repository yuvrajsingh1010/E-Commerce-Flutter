import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

/// A provider class for managing product-related state, including fetching products,
/// applying filters, sorting, and searching.
class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  /// A list to store all products fetched from the API.
  List<Product> _allProducts = [];

  /// A list to store the filtered products based on user preferences.
  List<Product> _filteredProducts = [];

  /// A boolean indicating the loading state for API calls.
  bool _isLoading = false;

  // Filters and Sorting state
  String _selectedCategory = 'all'; // Default category filter
  final String _selectedSortOption = 'Price: Low to High'; // Default sort option
  double _minPrice = 0.0; // Default minimum price
  double _maxPrice = 10000.0; // Default maximum price (Assuming a high max price)
  double _selectedRating = 0.0; // Default rating filter (0 means no filter)
  String _searchQuery = '';

  // Getters
  List<Product> get filteredProducts => _filteredProducts;
  bool get isLoading => _isLoading;
  String get selectedCategory => _selectedCategory;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  double get selectedRating => _selectedRating;
  String get searchQuery => _searchQuery;
  String get selectedSortOption => _selectedSortOption;

  /// Fetches products from the API and updates the state with the fetched products.
  /// It handles loading and error states.
  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allProducts = await _apiService.fetchProducts();
      _filteredProducts = List.from(_allProducts); // Initially show all products
    } catch (e) {
      // Handle API failure gracefully
      debugPrint("Error loading products: $e");
      _allProducts = [];
      _filteredProducts = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sorts the products based on the selected sorting option.
  /// Supports sorting by price and rating (ascending or descending).
  void sortProducts(String sortOption) {
    switch (sortOption) {
      case 'Price: Low to High':
        _filteredProducts.sort((a, b) => a.price.compareTo(b.price)); // Ascending order
        break;
      case 'Price: High to Low':
        _filteredProducts.sort((a, b) => b.price.compareTo(a.price)); // Descending order
        break;
      case 'Rating: High to Low':
        _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating)); // Descending order
        break;
      case 'Rating: Low to High':
        _filteredProducts.sort((a, b) => a.rating.compareTo(b.rating)); // Ascending order
        break;
    }
    notifyListeners();
  }

  /// Applies all filters (category, price range, rating, search query) and then sorts the products.
  void applyFiltersAndSort() {
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'all' ||
          product.category.toLowerCase() == _selectedCategory;

      final matchesPrice = product.price >= _minPrice && product.price <= _maxPrice;

      final matchesRating = _selectedRating == 0 || product.rating >= _selectedRating;

      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesPrice && matchesRating && matchesSearch;
    }).toList();
    // Apply sorting based on the selected option
    sortProducts(_selectedSortOption);
    notifyListeners();
  }

  /// Applies category, price range, and rating filters to the product list.
  void applyFilters() {
    _filteredProducts = _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'all' ||
          product.category.toLowerCase() == _selectedCategory;

      final matchesPrice = product.price >= _minPrice && product.price <= _maxPrice;

      final matchesRating = _selectedRating == 0 || product.rating >= _selectedRating;

      return matchesCategory && matchesPrice && matchesRating;
    }).toList();

    // Apply sorting based on the selected option
    sortProducts(_selectedSortOption);
    notifyListeners();
  }

  /// Filters products by the selected category.
  /// If "All" is selected, all products are shown.
  void applyCategoryFilter() {
    if (_selectedCategory == 'All') {
      _filteredProducts = List.from(_allProducts);
    } else {
      _filteredProducts = _allProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }
    notifyListeners();
  }

  /// Searches for products by the provided query.
  /// The search is applied after category and filter settings.
  void searchProducts(String query) {
    _searchQuery = query;
    applyCategoryFilter(); 
    applyFilters(); // Apply filters after search
    notifyListeners();
  }

  /// Filters products based on the selected category.
  /// It updates the `filteredProducts` list according to the category.
  void filterProductsByCategory(String category) {
    _selectedCategory = category.toLowerCase();
    if (_selectedCategory == 'all') {
      _filteredProducts = List.from(_allProducts); // Show all products
    } else {
      _filteredProducts = _allProducts
          .where((product) => product.category.toLowerCase() == _selectedCategory)
          .toList(); // Filter products based on selected category
    }
    notifyListeners();
    applyFilters(); // Apply any other active filters
  }

  /// Sorts products by price, either ascending or descending.
  void sortProductsByPrice({bool ascending = true}) {
    _filteredProducts.sort((a, b) => ascending
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));
    notifyListeners();
    applyFilters(); // Reapply filters after sorting
  }

  /// Sorts products by rating in descending order.
  void sortProductsByRating() {
    _filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
    notifyListeners();
    applyFilters(); // Reapply filters after sorting
  }

  /// Filters products by a specified price range.
  /// - [minPrice]: The minimum price.
  /// - [maxPrice]: The maximum price.
  void filterProductsByPriceRange({required double minPrice, required double maxPrice}) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;

    // Apply price filter after setting the price range
    _filteredProducts = _allProducts.where((product) {
      return product.price >= _minPrice && product.price <= _maxPrice;
    }).toList();

    notifyListeners();
    applyFilters(); // Reapply filters after price filtering
  }

  /// Filters products by the selected rating.
  /// - [rating]: The minimum rating to filter by.
  void filterProductsByRating(double rating) {
    _selectedRating = rating;

    // Apply rating filter after setting the rating
    _filteredProducts = _allProducts.where((product) {
      return product.rating >= _selectedRating;
    }).toList();

    notifyListeners();
    applyFilters(); // Reapply filters after rating filtering
  }
}
