import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/auth/presentation/widgets/registration_form.dart';
import 'package:handy_connect/features/handyman/presentation/profile_setup_screen.dart';

enum UserType { customer, handyman }

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => locator<AuthBloc>(),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Successfully Registered!')),
              );
              if (state.userType == UserType.handyman) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
                );
              } else {
                // TODO: Navigate to customer home screen
              }
            } else if (state is Authenticated) {
              // Handle direct authentication (e.g., from Google Sign-In)
              // TODO: Navigate to the appropriate home screen based on user type from Firestore
            } else if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.0),
                child: RegistrationForm(),
              ),
            );
          },
        ),
      ),
    );
  }
}
