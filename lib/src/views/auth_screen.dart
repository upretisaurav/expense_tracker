import 'package:expense_tracker/src/providers/user_provider.dart';
import 'package:expense_tracker/src/services/api_service.dart';
import 'package:expense_tracker/src/views/custom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get_it/get_it.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final ApiService _apiService = GetIt.instance<ApiService>();
  bool isSignIn = true;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _professionController = TextEditingController();
  String? _photoPath;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    try {
      await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.gallery,
                      maxWidth: 1024,
                      maxHeight: 1024,
                      imageQuality: 85,
                    );

                    if (image != null) {
                      setState(() {
                        _photoPath = image.path;
                      });
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    final ImagePicker picker = ImagePicker();
                    final XFile? image = await picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 1024,
                      maxHeight: 1024,
                      imageQuality: 85,
                    );

                    if (image != null) {
                      setState(() {
                        _photoPath = image.path;
                      });
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pick image: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        if (isSignIn) {
          final response = await _apiService.signIn(
            email: _emailController.text,
            password: _passwordController.text,
          );

          // Extract user_id and store it
          final userId = response['user_id'] as String;
          await Provider.of<UserProvider>(context, listen: false)
              .setUserId(userId);

          // Navigate to CustomNavBar
          if (mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => CustomNavBar(
                  key: GlobalKey<CustomNavBarState>(),
                ),
              ),
              (route) => false, // This removes all previous routes
            );
          }
        } else {
          if (_photoPath == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please select a profile photo')),
            );
            return;
          }

          final response = await _apiService.signUp(
            name: _nameController.text,
            profession: _professionController.text,
            photo: _photoPath!,
            email: _emailController.text,
            password: _passwordController.text,
          );

          // Extract user_id and store it
          final userId = response['user_id'] as String;
          await Provider.of<UserProvider>(context, listen: false)
              .setUserId(userId);

          // Navigate to sigin
          if (mounted) {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    isSignIn ? 'Welcome Back!' : 'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  if (!isSignIn) ...[
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: _photoPath != null
                            ? FileImage(File(_photoPath!))
                            : null,
                        child: _photoPath == null
                            ? const Icon(Icons.add_a_photo, size: 30)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _professionController,
                      decoration: const InputDecoration(
                        labelText: 'Profession',
                        prefixIcon: Icon(Icons.work),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Please enter your profession';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      }
                      if (!value!.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your password';
                      }
                      if ((value?.length ?? 0) < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(
                            isSignIn ? 'Sign In' : 'Sign Up',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isSignIn = !isSignIn;
                      });
                    },
                    child: Text(
                      isSignIn
                          ? 'Don\'t have an account? Sign Up'
                          : 'Already have an account? Sign In',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _professionController.dispose();
    super.dispose();
  }
}
