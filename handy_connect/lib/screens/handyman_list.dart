import 'package:flutter/material.dart';
import 'package:handy_connect/screens/details_screen.dart';
import 'package:handy_connect/widgets/handyman_card.dart';

class HandymanListPage extends StatefulWidget {
  const HandymanListPage({super.key});

  @override
  State<HandymanListPage> createState() => _HandymanListPageState();
}

class _HandymanListPageState extends State<HandymanListPage> {
  bool showSearchBar = false;
  final _fcs = FocusNode();
  @override
  Widget build(BuildContext context) {
    final handymen = [
      {
        "name": "Ahmed Hassan",
        "job": "Electrician",
        "location": "Downtown, Dubai",
        "image":
            "https://www.paralysistreatments.com/wp-content/uploads/2018/02/no_profile_img.png",
      },
      {
        "name": "Mohammed Ali",
        "job": "Plumber",
        "location": "Marina, Dubai",
        "image": "",
      },
      {
        "name": "Khalid Ibrahim",
        "job": "Carpenter",
        "location": "Jumeirah, Dubai",
        "image": "",
      },
      {
        "name": "Youssef Mahmoud",
        "job": "Painter",
        "location": "Business Bay, Dubai",
        "image": "",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Text(
          "Available Handymen",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                showSearchBar = !showSearchBar;
                if (showSearchBar) _fcs.requestFocus();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Visibility(
            visible: showSearchBar,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  focusNode: _fcs,
                  decoration: InputDecoration(
                    hintText: "Filter by location...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: handymen.length,
              itemBuilder: (context, index) {
                final item = handymen[index];
                return HandymanCard(
                  name: item["name"]!,
                  job: item["job"]!,
                  location: item["location"]!,
                  image: item["image"]!,
                  open: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HandymanDetailPage(
                        name: item["name"]!,
                        job: item["job"]!,
                        location: item["location"]!,
                        image: item["image"]!,
                        about:
                            "Certified electrician with 10+ years of experience in residential and commercial electrical work.",
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
