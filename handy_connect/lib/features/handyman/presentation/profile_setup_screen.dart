import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/presentation/bloc/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';

class ProfileSetupScreen extends StatelessWidget {
  const ProfileSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated &&
        authState is! AuthenticatedWithUserType) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Error: User not authenticated.')),
      );
    }

    final uid = (authState is Authenticated)
        ? authState.user.uid
        : (authState as AuthenticatedWithUserType).user.uid;

    return BlocProvider(
      create: (_) => locator<ProfileBloc>()..add(GetProfile(uid)),
      child: ProfileSetupView(uid: uid),
    );
  }
}

class ProfileSetupView extends StatefulWidget {
  final String uid;

  const ProfileSetupView({super.key, required this.uid});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final _formKey = GlobalKey<FormState>();
  File? _profileImage;
  String? _serviceType;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _telegramController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _serviceType = 'Electrician'; // Initialize with default value
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/handyman_home');
          },
        ),
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequested());
            },
          ),
        ],
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            _nameController.text = state.handyman.name;
            _phoneController.text = state.handyman.phone;
            _whatsappController.text =
                state.handyman.socialLinks['whatsapp'] ?? '';
            _telegramController.text =
                state.handyman.socialLinks['telegram'] ?? '';
            // Ensure a default service type is set if the loaded one is empty.
            if (state.handyman.serviceType.isNotEmpty) {
              _serviceType = state.handyman.serviceType;
            } else {
              _serviceType = _serviceTypes.first;
            }
            _locationController.text = state.handyman.location;
            _descriptionController.text = state.handyman.description;
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Help customers find and contact you',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : (state is ProfileLoaded &&
                                            state
                                                .handyman
                                                .profilePhotoUrl
                                                .isNotEmpty
                                        ? NetworkImage(
                                            state.handyman.profilePhotoUrl,
                                          )
                                        : null)
                                    as ImageProvider?,
                          child:
                              _profileImage == null &&
                                  (state is! ProfileLoaded ||
                                      state.handyman.profilePhotoUrl.isEmpty)
                              ? const Icon(Icons.person, size: 60)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt),
                            onPressed: _pickImage,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(
                        Icons.upload_file,
                        color: Colors.black87,
                      ),
                      label: Text(
                        'Upload Photo',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 14.0
                              : 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.0,
                          ),
                        ),
                        backgroundColor: Colors.grey.shade100,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    _nameController,
                    'Full Name',
                    isRequired: true,
                  ),
                  _buildTextField(
                    _phoneController,
                    'Phone Number',
                    isRequired: true,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    _whatsappController,
                    'WhatsApp Number',
                    isRequired: false,
                    keyboardType: TextInputType.phone,
                  ),
                  _buildTextField(
                    _telegramController,
                    'Telegram Username',
                    isRequired: false,
                  ),
                  _buildServiceTypeDropdown(),
                  _buildTextField(
                    _locationController,
                    'Location',
                    isRequired: true,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 14.0
                              : 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width < 600
                              ? 14.0
                              : 16.0,
                        ),
                        decoration: InputDecoration(
                          hintText:
                              'Tell us about yourself and your services...',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 2.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(16.0),
                          hintStyle: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: MediaQuery.of(context).size.width < 600
                                ? 14.0
                                : 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final authState = context.read<AuthBloc>().state;
                        final email = (authState is Authenticated)
                            ? authState.user.email
                            : (authState is AuthenticatedWithUserType)
                            ? authState.user.email
                            : '';

                        final handyman = HandymanUser(
                          uid: widget.uid,
                          name: _nameController.text,
                          email: email ?? '',
                          phone: _phoneController.text,
                          location: _locationController.text,
                          profilePhotoUrl: (state is ProfileLoaded)
                              ? state.handyman.profilePhotoUrl
                              : '',
                          socialLinks: {
                            'whatsapp': _whatsappController.text,
                            'telegram': _telegramController.text,
                          },
                          serviceType: _serviceType!,
                          description: _descriptionController.text,
                          experience: '', // Not in UI
                        );
                        context.read<ProfileBloc>().add(
                          UpdateProfile(handyman, _profileImage),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Complete Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isRequired = true,
    TextInputType? keyboardType,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth < 600 ? 14.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(fontSize: baseFontSize),
          decoration: InputDecoration(
            hintText: 'Enter ${label.toLowerCase().replaceAll('*', '').trim()}',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.04,
              horizontal: screenWidth * 0.04,
            ),
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: baseFontSize,
            ),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return 'This field is required';
            }
            if (keyboardType == TextInputType.phone &&
                value != null &&
                value.isNotEmpty) {
              final phoneRegex = RegExp(r'^[0-9+\-\s()]{10,}$');
              if (!phoneRegex.hasMatch(value)) {
                return 'Please enter a valid phone number';
              }
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  List<String> get _serviceTypes => const [
    'Electrician',
    'Plumber',
    'Carpenter',
    'Painter',
    'AC Repair',
    'General Handyman',
  ];

  Widget _buildServiceTypeDropdown() {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseFontSize = screenWidth < 600 ? 14.0 : 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Type *',
          style: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _serviceType,
          isExpanded: true,
          style: TextStyle(fontSize: baseFontSize, color: Colors.black87),
          decoration: InputDecoration(
            hintText: 'Select your service type',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(
              vertical: screenWidth * 0.04,
              horizontal: screenWidth * 0.04,
            ),
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontSize: baseFontSize,
            ),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black87),
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          items: _serviceTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: TextStyle(fontSize: baseFontSize)),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _serviceType = newValue!;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a service type';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
