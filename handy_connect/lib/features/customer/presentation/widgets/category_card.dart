import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;

  const CategoryCard({super.key, required this.category, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.go('/handyman_list/$category');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Text(category, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
