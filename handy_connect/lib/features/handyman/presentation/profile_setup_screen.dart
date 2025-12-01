import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:handy_connect/features/handyman/presentation/bloc/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
        title: const Text('Complete Your Profile'),
        centerTitle: true,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdateSuccess) {
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
          } else if (state is ProfileLoaded) {
            _nameController.text = state.handyman.name;
            _phoneController.text = state.handyman.phone;
            _whatsappController.text =
                state.handyman.socialLinks['whatsapp'] ?? '';
            _telegramController.text =
                state.handyman.socialLinks['telegram'] ?? '';
            _serviceType = state.handyman.serviceType;
            _locationController.text = state.handyman.location;
            _descriptionController.text = state.handyman.description;
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
                      icon: const Icon(Icons.upload_file),
                      label: const Text('Upload Photo'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(_nameController, 'Full Name *'),
                  _buildTextField(_phoneController, 'Phone Number *'),
                  _buildTextField(
                    _whatsappController,
                    'WhatsApp Number (optional)',
                  ),
                  _buildTextField(
                    _telegramController,
                    'Telegram Username (optional)',
                  ),
                  _buildServiceTypeDropdown(),
                  _buildTextField(_locationController, 'Location *'),
                  _buildTextField(
                    _descriptionController,
                    'Description *',
                    maxLines: 4,
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
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: label.replaceAll(' *', ''),
            ),
            validator: (value) {
              if (label.endsWith('*') && (value == null || value.isEmpty)) {
                return 'Please enter your $label';
              }
              return null;
            },
          ),
        ],
      ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service Type *',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _serviceTypes.contains(_serviceType)
                ? _serviceType
                : _serviceTypes.first,
            hint: const Text('Select a service type'),
            onChanged: (value) {
              setState(() {
                _serviceType = value;
              });
            },
            items: _serviceTypes.map((type) {
              return DropdownMenuItem(value: type, child: Text(type));
            }).toList(),
            decoration: const InputDecoration(border: OutlineInputBorder()),
            validator: (value) {
              if (value == null) {
                return 'Please select a service type';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
