/// Represents a product with detailed information such as title, description, price, rating, and category.
class Product {
  /// Unique identifier for the product.
  final int id;

  /// The title or name of the product.
  final String title;

  /// A detailed description of the product.
  final String description;

  /// URL or path to the product's image.
  final String image;

  /// The price of the product.
  final double price;

  /// The average rating of the product.
  final double rating;

  /// The category to which the product belongs.
  final String category;

  /// Constructor for creating a [Product] instance with all required fields.
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.rating,
    required this.category,
  });

  /// Factory method to create a [Product] instance from a JSON object.
  /// 
  /// - [json]: A map containing the product's data.
  /// - Converts numerical fields like `price` and `rating` to `double` for consistency.
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      image: json['image'],
      price: json['price'].toDouble(),
      rating: json['rating']['rate'].toDouble(),
      category: json['category'],
    );
  }
}
