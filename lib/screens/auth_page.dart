import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/homepage.dart';

/// The authentication page for login and registration.
/// It includes form fields for the user to input their details, and the logic for submitting the form.
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>(); // Form key for form validation
  final _emailController = TextEditingController(); // Controller for email input
  final _passwordController = TextEditingController(); // Controller for password input
  final _nameController = TextEditingController(); // Controller for name input (only for registration)
  final _phoneController = TextEditingController(); // Controller for phone number input
  bool _isLogin = true; // Tracks whether the user is on the login screen or the registration screen

  /// Submits the form, either logging in or registering the user, based on `_isLogin`.
  /// If login or registration is successful, navigates to the homepage.
  void _submit() async {
    if (!_formKey.currentState!.validate()) {
      return; // Stop if form is not valid
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // Perform login or registration based on _isLogin
      if (_isLogin) {
        await authProvider.login(
          _emailController.text,
          _phoneController.text,
          _passwordController.text,
        );
      } else {
        final phone = _phoneController.text;

        // Validate phone number format
        if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
          throw Exception('Invalid phone number');
        }

        await authProvider.register(
          _nameController.text,
          _emailController.text,
          phone,
          _passwordController.text,
        );
      }

      if (mounted) {
        // Navigate to homepage if the user is logged in or registered
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (error) {
      if (mounted) {
        // Show an error dialog if something goes wrong
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'), // App bar title based on the current state
        automaticallyImplyLeading: false, 
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assigning form key for validation
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Display name input field only if registration is selected
                if (!_isLogin)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name'; // Validation for name input
                      }
                      return null;
                    },
                  ),
                // Email input field with validation for proper email format
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty || !authProvider.isValidEmail(value)) {
                      return 'Please enter a valid email'; // Email validation
                    }
                    return null;
                  },
                ),
                // Phone number input field with validation for valid phone number format
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value!.isEmpty || !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                      return 'Please enter a valid phone number'; // Phone number validation
                    }
                    return null;
                  },
                ),
                // Password input field with validation for a minimum length
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true, // Hide the password text
                  validator: (value) {
                    if (value!.isEmpty || value.length < 6) {
                      return 'Password must be at least 6 characters long'; // Password validation
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Submit button for login or registration
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'Login' : 'Register'),
                ),
                // Toggle button to switch between login and registration
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin; // Toggle between login and registration state
                    });
                  },
                  child: Text(_isLogin
                      ? 'Don\'t have an account? Register'
                      : 'Already have an account? Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
