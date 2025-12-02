import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/auth/presentation/registration_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  UserType _userType = UserType.customer;
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
                horizontal: screenWidth * 0.04,
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
                horizontal: screenWidth * 0.04,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              return null;
            },
          ),
          const SizedBox(height: 30),

          // Sign In Button
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(
                  SignInRequested(
                    email: _emailController.text,
                    password: _passwordController.text,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
            ),
            child: Text('Sign In', style: TextStyle(fontSize: baseFontSize)),
          ),
          const SizedBox(height: 20),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text('or', style: TextStyle(fontSize: baseFontSize)),
              ),
              const Expanded(child: Divider()),
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
              ),
            ),
            label: Text(
              'Continue with Google',
              style: TextStyle(fontSize: baseFontSize),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: screenWidth * 0.05),
            ),
          ),
          const SizedBox(height: 30),

          // Sign Up Link
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don't have an account?",
                style: TextStyle(fontSize: baseFontSize),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: Text(
                  'Sign up',
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
