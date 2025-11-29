import 'package:flutter/material.dart';

ValueNotifier navIndex = ValueNotifier<int>(0);

class BottomNavBarWidget extends StatelessWidget {
  const BottomNavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: navIndex,
      builder: (context, index, child) => BottomNavigationBar(
        currentIndex: index,
        onTap: (value) {
          navIndex.value = value;
        },
        selectedItemColor: Theme.of(context).colorScheme.onSurface,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: "Requests",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
