import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';

class HandymanCard extends StatelessWidget {
  final HandymanUser handyman;

  const HandymanCard({super.key, required this.handyman});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: handyman.profilePhotoUrl.isNotEmpty
              ? NetworkImage(handyman.profilePhotoUrl)
              : null,
          child: handyman.profilePhotoUrl.isEmpty
              ? const Icon(Icons.person)
              : null,
        ),
        title: Text(handyman.name),
        subtitle: Text(handyman.location),
        onTap: () {
          context.push('/handyman_profile', extra: handyman);
        },
      ),
    );
  }
}
