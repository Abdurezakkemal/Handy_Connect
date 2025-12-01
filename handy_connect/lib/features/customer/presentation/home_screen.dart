import 'package:flutter/material.dart';
import 'package:handy_connect/features/customer/presentation/widgets/category_card.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HandyConnect'),
        leading: const Icon(Icons.build_outlined),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find skilled professionals',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Search for services...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Service Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: const [
                  CategoryCard(category: 'Electrician', icon: Icons.flash_on),
                  CategoryCard(category: 'Plumber', icon: Icons.plumbing),
                  CategoryCard(category: 'Carpenter', icon: Icons.construction),
                  CategoryCard(category: 'Painter', icon: Icons.format_paint),
                  CategoryCard(category: 'AC Repair', icon: Icons.ac_unit),
                  CategoryCard(category: 'General', icon: Icons.handyman),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 1) {
            context.go('/my_requests');
          } else if (index == 2) {
            context.go('/customer_profile');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
