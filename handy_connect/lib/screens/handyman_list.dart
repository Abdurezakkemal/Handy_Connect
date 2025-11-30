import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_connect/providers/filter_handymen_provider.dart';
import 'package:handy_connect/screens/details_screen.dart';
import 'package:handy_connect/widgets/handyman_card.dart';

class HandymanListPage extends ConsumerStatefulWidget {
  final String service;
  const HandymanListPage({super.key, required this.service});

  @override
  ConsumerState<HandymanListPage> createState() => _HandymanListPageState();
}

class _HandymanListPageState extends ConsumerState<HandymanListPage> {
  bool showSearchBar = false;
  final _fcs = FocusNode();
  @override
  Widget build(BuildContext context) {
    final handymenList = ref.watch(contentModuleProvider(widget.service));

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
      body: handymenList.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(child: Text("No Handymen Found"));
          }
          return Column(
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
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return HandymanCard(
                      name: item.name,
                      job: item.service,
                      location: item.location,
                      image: item.image,
                      open: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HandymanDetailPage(handymen: item),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
