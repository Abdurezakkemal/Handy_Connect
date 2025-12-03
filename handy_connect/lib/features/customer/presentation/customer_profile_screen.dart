import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/customer/presentation/bloc/customer_profile_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;

    // Handle different authenticated states
    late final String uid;
    if (authState is Authenticated || authState is AuthenticatedWithUserType) {
      uid = (authState as dynamic).user.uid;
    } else {
      // If not authenticated, show a message and a button to go to login
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Please sign in to view your profile.'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    return BlocProvider(
      create: (_) =>
          locator<CustomerProfileBloc>()..add(GetCustomerProfileEvent(uid)),
      child: CustomerProfileView(uid: uid),
    );
  }
}

class CustomerProfileView extends StatefulWidget {
  final String uid;

  const CustomerProfileView({super.key, required this.uid});

  @override
  State<CustomerProfileView> createState() => _CustomerProfileViewState();
}

class _CustomerProfileViewState extends State<CustomerProfileView> {
  File? _profileImage;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        final file = File(pickedFile.path);
        if (!await file.exists()) {
          throw Exception('Selected file does not exist');
        }

        setState(() {
          _profileImage = file;
        });

        final bloc = context.read<CustomerProfileBloc>();
        if (bloc.state is CustomerProfileLoaded) {
          final customer = (bloc.state as CustomerProfileLoaded).customer;
          bloc.add(UpdateCustomerProfileEvent(customer, _profileImage));
        } else {
          throw Exception('Customer data not loaded');
        }
      } else {}
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              // Navigate to login screen after successful logout
              context.go('/login');
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          centerTitle: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Use GoRouter to navigate to the customer home screen
              context.go('/customer_home');
            },
          ),
        ),
        body: BlocConsumer<CustomerProfileBloc, CustomerProfileState>(
          listener: (context, state) {
            if (state is CustomerProfileUpdateSuccess) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            } else if (state is CustomerProfileError) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } else if (state is CustomerProfileLoading) {
            } else if (state is CustomerProfileLoaded) {}
          },
          builder: (context, state) {
            if (state is CustomerProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CustomerProfileLoaded) {
              final customer = state.customer;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.shade200,
                                  child: _profileImage != null
                                      ? ClipOval(
                                          child: Image.file(
                                            _profileImage!,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : customer.profilePhotoUrl.isNotEmpty
                                      ? ClipOval(
                                          child: Image.network(
                                            customer.profilePhotoUrl,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                customer.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Customer Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: const Icon(
                          Icons.email_outlined,
                          color: Colors.grey,
                        ),
                        title: const Text('Email'),
                        subtitle: Text(
                          customer.email,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          return OutlinedButton.icon(
                            onPressed: authState is AuthLoading
                                ? null
                                : () {
                                    context.read<AuthBloc>().add(
                                      SignOutRequested(),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 24,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              shadowColor: Colors.black12,
                            ),
                            icon: authState is AuthLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.black87,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.logout,
                                    color: Colors.black87,
                                  ),
                            label: Text(
                              authState is AuthLoading
                                  ? 'Logging out...'
                                  : 'Logout',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Failed to load profile.'));
          },
        ),
      ),
    );
  }
}
