class Product {
  final String id;        // Unique identifier for the product
  final String title;     // The title or name of the product
  final String image;     // URL or path of the product's image
  final double price;     // The price of the product
  final double rating;    // The rating of the product (e.g., 4.5)

  // Constructor for initializing the product object
  Product({
    required this.id,      // Required: Unique ID for the product
    required this.title,   // Required: Product title
    required this.image,   // Required: Product image URL/path
    required this.price,   // Required: Price of the product
    required this.rating,  // Required: Rating of the product
  });
}
