import 'package:flutter/material.dart';
import 'package:handy_connect/models/user.dart';
import 'package:handy_connect/screens/request_service_screen.dart';
import 'package:handy_connect/services/url_louncher.dart';
import 'package:handy_connect/widgets/contact_button.dart';

class HandymanDetailPage extends StatelessWidget {
  final User handymen;

  const HandymanDetailPage({super.key, required this.handymen});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RequestServicePage(handyman: handymen),
                ),
              );
            },
            child: Text(
              "Request Service",
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 110,
                    height: 110,
                    child: Image.network(
                      handymen.profilePhotoUrl,
                      errorBuilder: (context, _, _) =>
                          Icon(Icons.engineering, size: 110),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  handymen.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  handymen.serviceType,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      handymen.location,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 20),
            Divider(color: Colors.grey.shade300, thickness: 1),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "About",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        handymen.experience,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(color: Colors.grey.shade300, thickness: 1),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Contact Options",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),

                  Visibility(
                    visible: handymen.socialLinks.keys.contains("whatsapp"),
                    child: ContactButton(
                      icon: Icons.chat,
                      label: "Contact via WhatsApp",
                      onTap: () {
                        launchUniversalLink(handymen.socialLinks["whatsapp"]);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  Visibility(
                    visible: handymen.socialLinks.keys.contains("telegram"),

                    child: ContactButton(
                      icon: Icons.send,
                      label: "Contact via Telegram",
                      onTap: () {
                        launchUniversalLink(handymen.socialLinks["telegram"]);
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  ContactButton(
                    icon: Icons.call,
                    label: "Call ${handymen.phone}",
                    onTap: () {
                      launchUniversalLink("tel:${handymen.phone}");
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
