import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/auth/presentation/registration_screen.dart';
import 'package:handy_connect/features/customer/presentation/home_screen.dart';
import 'package:handy_connect/features/handyman/presentation/requests_list_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authenticated) {
          context.read<AuthBloc>().add(GetUserTypeRequested(state.user.uid));
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (state is AuthenticatedWithUserType) {
          if (state.userType == 'handyman') {
            return const RequestsListScreen();
          } else {
            return const HomeScreen();
          }
        } else {
          return const RegistrationScreen();
        }
      },
    );
  }
}
