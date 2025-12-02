import 'package:flutter/material.dart';

import '../handyman_bloc.dart';
import '../models/handyman_profile.dart';

class ProfilePage extends StatefulWidget {
  final HandymanBloc bloc;

  const ProfilePage({super.key, required this.bloc});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late HandymanProfile profile;

  final _serviceTypes = [
    'Electrician',
    'Plumber',
    'Carpenter',
    'AC Technician',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    profile = HandymanProfile(id: 'me');
    // subscribe to profile updates
    widget.bloc.profileStream.listen((p) {
      setState(() => profile = p);
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    await widget.bloc.saveProfile(profile);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    }
  }

  InputDecoration fieldDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Complete Your Profile',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Help customers find and contact you',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 18),

              // upload card
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const Icon(
                        Icons.upload_outlined,
                        size: 36,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Text(
                          'Upload Photo',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Name *',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: profile.fullName,
                      decoration: fieldDecoration(''),
                      onSaved: (v) => profile.fullName = v ?? '',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Full name is required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Phone Number *',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: profile.phoneNumber,
                      decoration: fieldDecoration('+251 97 031 9181'),
                      onSaved: (v) => profile.phoneNumber = v ?? '',
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Phone is required'
                          : null,
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'WhatsApp Number (optional)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: profile.whatsappNumber,
                      decoration: fieldDecoration('+251 97 031 9181'),
                      onSaved: (v) => profile.whatsappNumber = v ?? '',
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Username (optional)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: profile.username,
                      decoration: fieldDecoration('@username'),
                      onSaved: (v) => profile.username = v ?? '',
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Service Type *',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: profile.serviceType.isEmpty
                          ? null
                          : profile.serviceType,
                      decoration: fieldDecoration('Select a service type'),
                      items: _serviceTypes
                          .map(
                            (s) => DropdownMenuItem(value: s, child: Text(s)),
                          )
                          .toList(),
                      onChanged: (v) =>
                          setState(() => profile.serviceType = v ?? ''),
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Service type is required'
                          : null,
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Location *',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: profile.location,
                      decoration: fieldDecoration(
                        'e.g., Addis Abeba, Ethiopia',
                      ),
                      onSaved: (v) => profile.location = v ?? '',
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Location required' : null,
                    ),
                    const SizedBox(height: 12),

                    const Text(
                      'Description *',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: profile.description,
                      decoration: fieldDecoration(
                        'Describe your experience and services...',
                      ),
                      minLines: 4,
                      maxLines: 6,
                      onSaved: (v) => profile.description = v ?? '',
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Description required'
                          : null,
                    ),
                    const SizedBox(height: 36),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: _save,
            child: const Text('Complete Profile'),
          ),
        ),
      ),
    );
  }
}
