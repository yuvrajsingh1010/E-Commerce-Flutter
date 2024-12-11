/// Represents a user with basic contact information.
class User {
  /// The name of the user.
  final String name;

  /// The email address of the user.
  final String email;

  /// The phone number of the user.
  final String phone;

  /// Constructor for creating a [User] instance with all required fields.
  User({
    required this.name,
    required this.email,
    required this.phone,
  });
}