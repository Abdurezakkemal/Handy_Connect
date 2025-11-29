import 'package:flutter/material.dart';
import 'package:handy_connect/screens/handyman_list.dart';
import 'package:handy_connect/screens/my_requests_screen.dart';
import 'package:handy_connect/widgets/bottom_nav.dart';
import 'package:handy_connect/widgets/service_card.dart';

class Navigate extends StatelessWidget {
  Navigate({super.key});
  final List<Widget> _pages = [
    HandymanHome(),
    MyRequestsScreen(),
    Center(child: Text("Profile")),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      bottomNavigationBar: BottomNavBarWidget(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),

            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.handyman,
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "HandyConnect",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Find skilled professionals",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ValueListenableBuilder(
              valueListenable: navIndex,
              builder: (context, index, child) => _pages.elementAt(index),
            ),
          ),
        ],
      ),
    );
  }
}

class HandymanHome extends StatelessWidget {
  const HandymanHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Search for services...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Service Categories",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.1,
                padding: EdgeInsets.all(8),
                children: [
                  ServiceCard(
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandymanListPage(),
                        ),
                      );
                    },
                    icon: Icons.electric_bolt,
                    title: "Electrician",
                  ),
                  ServiceCard(
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandymanListPage(),
                        ),
                      );
                    },
                    icon: Icons.water_drop,
                    title: "Plumber",
                  ),
                  ServiceCard(
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandymanListPage(),
                        ),
                      );
                    },
                    icon: Icons.plumbing,
                    title: "Carpenter",
                  ),
                  ServiceCard(
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandymanListPage(),
                        ),
                      );
                    },
                    icon: Icons.brush,
                    title: "Painter",
                  ),
                  ServiceCard(
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandymanListPage(),
                        ),
                      );
                    },
                    icon: Icons.wind_power,
                    title: "AC Repair",
                  ),
                  ServiceCard(
                    onClick: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandymanListPage(),
                        ),
                      );
                    },
                    icon: Icons.settings,
                    title: "General",
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
