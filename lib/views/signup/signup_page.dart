import 'package:firebase_auth/firebase_auth.dart' as firestore;
import 'package:flutter/material.dart';
import 'package:hedieaty/models/repositories/user_repository.dart';
import 'package:hedieaty/models/user_model.dart';
import 'package:hedieaty/routes/app_routes.dart';
import 'package:hedieaty/services/user_service.dart';

import '../../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _selectedGender;
  bool _isLoading = false;
  String? _phoneError;

  Future<void> _signUp() async {

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final firestore.User? firebaseUser = await AuthService().signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      User userData = User(
        id: firebaseUser!.uid,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        gender: _selectedGender!,
      );

      if (firebaseUser != null) {
        // add user to the fire store


        // Save the user in the local database
        await UserRepository().insertUser(userData);
        print("user added to local database");

        await UserService().addUser(userData);
        print("user added to fire store");

        // Navigate to the next screen (e.g., home page)
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.length != 11) {
                    return 'Phone number must be exactly 11 digits';
                  }
                  return null; // No synchronous errors
                },
                onChanged: (value) async {
                  // Asynchronous phone number existence check
                  if (value.length == 11) {
                    final phoneExists = await UserRepository().doesPhoneNumberExist(value);
                    if (phoneExists) {
                      setState(() {
                        _phoneError = 'Phone number already exists';
                      });
                    } else {
                      setState(() {
                        _phoneError = null;
                      });
                    }
                  }
                },
              ),
              if (_phoneError != null)
                Text(
                  _phoneError!,
                  style: const TextStyle(color: Colors.red),
                ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.contains('@') ? null : 'Enter a valid email',
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) =>
                value!.length >= 6 ? null : 'Password must be at least 6 characters',
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) => value == _passwordController.text
                    ? null
                    : 'Passwords do not match',
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: const [
                  DropdownMenuItem(value: 'm', child: Text('Male')),
                  DropdownMenuItem(value: 'f', child: Text('Female')),
                ],
                decoration: const InputDecoration(labelText: 'Gender'),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                validator: (value) => value == null ? 'Gender is required' : null,
              ),
              const SizedBox(height: 20),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: _signUp,
                    child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
