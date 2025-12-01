import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/auth/presentation/registration_screen.dart';
import 'package:go_router/go_router.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();
  UserType _userType = UserType.customer;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double baseFontSize = screenWidth < 600 ? 16.0 : 18.0;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: screenWidth * 0.1),
          // App Logo and Title
          Icon(Icons.build, size: screenWidth * 0.15), // Placeholder for logo
          const SizedBox(height: 8),
          Text(
            'HandyConnect',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: baseFontSize + 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Connect with skilled handymen',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: baseFontSize, color: Colors.grey),
          ),
          SizedBox(height: screenWidth * 0.1),

          // User Type Toggle
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      setState(() => _userType = UserType.customer),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _userType == UserType.customer
                        ? Colors.black
                        : Colors.grey[200],
                    foregroundColor: _userType == UserType.customer
                        ? Colors.white
                        : Colors.black,
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                  ),
                  child: Text(
                    'Customer',
                    style: TextStyle(fontSize: baseFontSize),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      setState(() => _userType = UserType.handyman),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _userType == UserType.handyman
                        ? Colors.black
                        : Colors.grey[200],
                    foregroundColor: _userType == UserType.handyman
                        ? Colors.white
                        : Colors.black,
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                  ),
                  child: Text(
                    'Handyman',
                    style: TextStyle(fontSize: baseFontSize),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Form Fields
          Text(
            'Full Name *',
            style: TextStyle(
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter your name',
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.04,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your full name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          Text(
            'Email *',
            style: TextStyle(
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'your.email@example.com',
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.04,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || !value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          Text(
            'Password *',
            style: TextStyle(
              fontSize: baseFontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              border: const OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                vertical: screenWidth * 0.04,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Sign Up Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  SignUpRequested(
                    name: _nameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    userType: _userType,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.06),
            ),
            child: Text('Sign Up', style: TextStyle(fontSize: baseFontSize)),
          ),
          const SizedBox(height: 20),

          // Divider
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('or', style: TextStyle(fontSize: baseFontSize)),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 20),

          // Google Sign-In Button
          OutlinedButton.icon(
            onPressed: () {
              context.read<AuthBloc>().add(GoogleSignInRequested());
            },
            icon: Text(
              'G',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: baseFontSize + 2,
              ), // Placeholder
            ),
            label: Text(
              'Continue with Google',
              style: TextStyle(fontSize: baseFontSize),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.06),
            ),
          ),
          const SizedBox(height: 30),

          // Sign In Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: TextStyle(fontSize: baseFontSize),
              ),
              TextButton(
                onPressed: () {
                  context.go('/login');
                },
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: baseFontSize),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
