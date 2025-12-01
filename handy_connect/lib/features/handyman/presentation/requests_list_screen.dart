import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';
import 'package:handy_connect/features/handyman/presentation/bloc/requests_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:handy_connect/features/handyman/presentation/widgets/request_card.dart';
import 'package:handy_connect/features/handyman/presentation/request_details_screen.dart';

class RequestsListScreen extends StatelessWidget {
  const RequestsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          return locator<RequestsBloc>()..add(GetRequests(authState.user.uid));
        }
        return locator<RequestsBloc>();
      },
      child: const RequestsListView(),
    );
  }
}

class RequestsListView extends StatefulWidget {
  const RequestsListView({super.key});

  @override
  State<RequestsListView> createState() => _RequestsListViewState();
}

class _RequestsListViewState extends State<RequestsListView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Requests'),
        leading: const Icon(Icons.build_outlined),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              context.go('/handyman_profile_setup');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'All Requests'),
          ],
        ),
      ),
      body: BlocBuilder<RequestsBloc, RequestsState>(
        builder: (context, state) {
          if (state is RequestsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is RequestsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildRequestsList(
                  state.requests
                      .where((r) => r.status == RequestStatus.pending)
                      .toList(),
                ),
                _buildRequestsList(state.requests),
              ],
            );
          } else if (state is RequestsError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text('No requests found.'));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 1) {
            context.go('/handyman_profile_setup');
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
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

  Widget _buildRequestsList(List<ServiceRequest> requests) {
    if (requests.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No requests yet',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            Text(
              'Pending requests will appear here',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: BlocProvider.of<RequestsBloc>(context),
                  child: RequestDetailsScreen(request: request),
                ),
              ),
            );
          },
          child: RequestCard(request: request),
        );
      },
    );
  }
}
