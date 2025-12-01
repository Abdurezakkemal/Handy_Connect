import 'package:flutter/material.dart';
import 'package:handy_connect/features/auth/presentation/widgets/sign_in_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: SingleChildScrollView(child: SignInForm())),
      ),
    );
  }
}
