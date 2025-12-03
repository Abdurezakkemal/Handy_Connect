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
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 24),
          _buildInfoCard('About', handyman.description),
          const SizedBox(height: 16),
          _buildInfoCard('Experience', handyman.experience),
          const SizedBox(height: 24),
          _buildContactOptions(context),
        ],
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Request Service', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: handyman.profilePhotoUrl.isNotEmpty
              ? NetworkImage(handyman.profilePhotoUrl)
              : null,
          child: handyman.profilePhotoUrl.isEmpty
              ? const Icon(Icons.person, size: 60, color: Colors.grey)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          handyman.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          handyman.serviceType,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              handyman.location,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOptions(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Options',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('Contact via WhatsApp'),
              onTap: () => _launchURL(
                context,
                'https://wa.me/${handyman.socialLinks['whatsapp']}',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.send_outlined),
              title: const Text('Contact via Telegram'),
              onTap: () {
                final username =
                    handyman.socialLinks['telegram']?.replaceAll('@', '') ?? '';
                _launchURL(context, 'https://t.me/$username');
              },
            ),
            ListTile(
              leading: const Icon(Icons.call_outlined),
              title: Text('Call ${handyman.phone}'),
              onTap: () => _launchURL(context, 'tel:${handyman.phone}'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final uri = Uri.parse(url);

      // Handle Telegram URLs specially
      if (url.startsWith('https://t.me/')) {
        final username = url.replaceAll('https://t.me/', '');
        final telegramUrl = 'tg://resolve?domain=$username';
        final telegramUri = Uri.parse(telegramUrl);

        // Try to launch Telegram app first
        if (await canLaunchUrl(telegramUri)) {
          await launchUrl(telegramUri);
          return;
        }
        // Fallback to web version if app is not installed
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return;
        }
      } else {
        // Handle other URLs normally
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
          return;
        }
      }

      // If we get here, launching failed
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open the link: $url')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred while trying to open the link'),
          ),
        );
      }
    }
  }
}
