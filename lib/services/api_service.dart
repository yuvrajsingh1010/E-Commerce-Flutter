import 'package:dio/dio.dart';
import '../models/product.dart';

class ApiService {
  final Dio _dio = Dio();  // Create an instance of Dio for making HTTP requests

  // Fetch a list of products from the API
  Future<List<Product>> fetchProducts() async {
    try {
      // Send GET request to the API endpoint to fetch products
      final response = await _dio.get('https://fakestoreapi.com/products');
      
      // Extract the list of products from the response data
      final List products = response.data;
      
      // Convert the list of product maps to a list of Product objects and return it
      return products.map((p) => Product.fromJson(p)).toList();
    } catch (e) {
      // Throw an exception if the request fails
      throw Exception('Failed to load products');
    }
  }
}
