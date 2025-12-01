import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/customer/presentation/bloc/handyman_list_bloc.dart';
import 'package:handy_connect/features/customer/presentation/widgets/handyman_card.dart';

class HandymanListScreen extends StatelessWidget {
  final String category;

  const HandymanListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<HandymanListBloc>()..add(FetchHandymen(category)),
      child: HandymanListView(category: category),
    );
  }
}

class HandymanListView extends StatelessWidget {
  final String category;

  const HandymanListView({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (query) {
                context.read<HandymanListBloc>().add(SearchHandymen(query));
              },
              decoration: InputDecoration(
                hintText: 'Search by location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<HandymanListBloc, HandymanListState>(
              builder: (context, state) {
                if (state is HandymanListLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is HandymanListLoaded) {
                  if (state.handymen.isEmpty) {
                    return const Center(child: Text('No handymen found.'));
                  }
                  return ListView.builder(
                    itemCount: state.handymen.length,
                    itemBuilder: (context, index) {
                      final handyman = state.handymen[index];
                      return HandymanCard(handyman: handyman);
                    },
                  );
                } else if (state is HandymanListError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
