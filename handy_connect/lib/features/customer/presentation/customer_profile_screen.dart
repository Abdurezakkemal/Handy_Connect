import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (user != null) ...[
              Text(
                'Name: ${user.displayName ?? ''}',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              Text(
                'Email: ${user.email ?? ''}',
                style: const TextStyle(fontSize: 18),
              ),
            ],
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequested());
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
