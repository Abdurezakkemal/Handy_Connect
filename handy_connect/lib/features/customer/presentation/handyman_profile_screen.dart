import 'package:flutter/material.dart';
import 'package:handy_connect/features/handyman/domain/models/handyman_user.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class HandymanProfileScreen extends StatelessWidget {
  final HandymanUser handyman;

  const HandymanProfileScreen({super.key, required this.handyman});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: handyman.profilePhotoUrl.isNotEmpty
                  ? NetworkImage(handyman.profilePhotoUrl)
                  : null,
              child: handyman.profilePhotoUrl.isEmpty
                  ? const Icon(Icons.person, size: 60)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              handyman.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              handyman.serviceType,
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  handyman.location,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 40),
            const Text(
              'About',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              handyman.description,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(height: 40),
            const Text(
              'Contact Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContactButton(
              'Contact via WhatsApp',
              Icons.chat_bubble_outline,
              () => _launchURL(
                'https://wa.me/${handyman.socialLinks['whatsapp']}',
              ),
            ),
            _buildContactButton(
              'Contact via Telegram',
              Icons.send_outlined,
              () => _launchURL(
                'https://t.me/${handyman.socialLinks['telegram']}',
              ),
            ),
            _buildContactButton(
              'Call ${handyman.phone}',
              Icons.call_outlined,
              () => _launchURL('tel:${handyman.phone}'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            context.push('/booking', extra: handyman);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Request Service', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildContactButton(
    String text,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black),
        label: Text(text, style: const TextStyle(color: Colors.black)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // TODO: Show a snackbar with an error message
    }
  }
}
