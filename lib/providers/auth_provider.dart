import 'package:flutter/material.dart';

/// A provider class for managing user authentication state, including login, registration, and validation.
class AuthProvider with ChangeNotifier {
  /// Indicates whether the user is currently logged in.
  bool _isLoggedIn = false;

  /// Token that represents the user's authentication status.
  String _userToken = ''; 

  /// User's name, stored for session use.
  String _userName = '';

  /// User's email, used for login and session.
  String _userEmail = '';

  /// User's phone number, used for login and session.
  String _userPhone = '';

  /// User's password, stored securely (hashed in real-world apps).
  String _userPassword = ''; 

  /// Returns whether the user is logged in.
  bool get isLoggedIn => _isLoggedIn;

  /// Returns the current user token.
  String get userToken => _userToken;

  /// Returns the user's name.
  String get userName => _userName;

  /// Returns the user's email address.
  String get userEmail => _userEmail;

  /// Returns the user's phone number.
  String get userPhone => _userPhone;

  /// Returns whether the user is authenticated based on the presence of a user token.
  bool get isAuthenticated => _userToken.isNotEmpty;

  /// Logs in the user if credentials are correct.
  ///
  /// - [email]: The email provided for login.
  /// - [phone]: The phone number provided for login.
  /// - [password]: The password provided for login.
  Future<void> login(String email, String phone, String password) async {
    // Validate input fields
    if (email.isEmpty || phone.isEmpty || password.isEmpty) {
      throw Exception('Email, phone, and password cannot be empty');
    }

    // Validate the email, phone, and password against stored values
    if (_userEmail != email) {
      throw Exception('User not registered. Please register first.');
    }

    if (_userPhone != phone) {
      throw Exception('Incorrect phone number. Please use the registered phone number.');
    }

    if (_userPassword != password) {
      throw Exception('Incorrect password. Please try again.');
    }

    // Successful login: set login status and token
    _isLoggedIn = true;
    _userToken = 'dummy-token'; // In production, this will come from the backend.

    // Notify listeners about the state change.
    notifyListeners();
  }

  /// Registers a new user with the provided details.
  ///
  /// - [name]: The user's name.
  /// - [email]: The user's email.
  /// - [phone]: The user's phone number.
  /// - [password]: The user's password.
  Future<void> register(String name, String email, String phone, String password) async {
    // Validate input fields
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    // Validate email format
    if (!isValidEmail(email)) {
      throw Exception('Invalid email address');
    }

    // Validate phone number format
    if (!isValidPhone(phone)) {
      throw Exception('Invalid phone number');
    }

    // Validate password strength
    if (!isValidPassword(password)) {
      throw Exception('Password must be at least 6 characters');
    }

    // Store user details (Dummy logic - should be handled by a backend in production)
    _userName = name;
    _userEmail = email;
    _userPhone = phone;
    _userPassword = password; // Store password securely (hashed in production).
    _userToken = 'dummy-token'; // In production, this will be provided by the backend.

    // Notify listeners about the state change.
    notifyListeners();
  }

  /// Logs the user out, resetting all session-related data.
  void logout() {
    _isLoggedIn = false;
    _userToken = '';
    _userName = '';
    _userEmail = '';
    _userPhone = '';
    _userPassword = ''; // Reset password for security.
    
    // Notify listeners about the state change.
    notifyListeners();
  }

  /// Validates whether the given email is in a correct format.
  ///
  /// - [email]: The email address to validate.
  /// - Returns true if the email is valid; false otherwise.
  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  /// Validates whether the given phone number is in a valid format (e.g., 10 digits).
  ///
  /// - [phone]: The phone number to validate.
  /// - Returns true if the phone number is valid; false otherwise.
  bool isValidPhone(String phone) {
    final phoneRegExp = RegExp(r'^[0-9]{10}$');
    return phoneRegExp.hasMatch(phone);
  }

  /// Validates whether the password meets the minimum length requirement (6 characters).
  ///
  /// - [password]: The password to validate.
  /// - Returns true if the password is valid; false otherwise.
  bool isValidPassword(String password) {
    return password.length >= 6;
  }
}
