import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';
import 'package:handy_connect/features/handyman/presentation/request_details_screen.dart';
import 'package:handy_connect/features/handyman/presentation/bloc/requests_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:handy_connect/features/handyman/presentation/widgets/request_card.dart';

class RequestsListScreen extends StatelessWidget {
  const RequestsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => locator<RequestsBloc>(),
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
  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? Colors.black87 : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.black87 : Colors.grey,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final authState = context.read<AuthBloc>().state;
    debugPrint('Auth state: ${authState.runtimeType}');
    if (authState is AuthenticatedWithUserType) {
      final uid = authState.user.uid;
      debugPrint(
        'Dispatching GetRequests for user (AuthenticatedWithUserType): $uid',
      );
      context.read<RequestsBloc>().add(GetRequests(uid));
    } else if (authState is Authenticated) {
      final uid = authState.user.uid;
      debugPrint('Dispatching GetRequests for user (Authenticated): $uid');
      context.read<RequestsBloc>().add(GetRequests(uid));
    } else {
      debugPrint('User is not authenticated, not fetching requests');
    }
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
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.build_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Requests',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Manage your service requests',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'PENDING'),
            Tab(text: 'ALL REQUESTS'),
          ],
        ),
        elevation: 0,
      ),
      body: BlocBuilder<RequestsBloc, RequestsState>(
        builder: (context, state) {
          debugPrint('Current RequestsBloc state: ${state.runtimeType}');
          if (state is RequestsError) {
            debugPrint('Error state: ${state.message}');
          }
          if (state is RequestsLoading) {
            debugPrint('Requests are being loaded...');
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.list_alt_outlined,
                activeIcon: Icons.list_alt_rounded,
                label: 'Requests',
                isActive: _selectedIndex == 0,
                onTap: () {
                  setState(() => _selectedIndex = 0);
                },
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profile',
                isActive: _selectedIndex == 1,
                onTap: () {
                  setState(() => _selectedIndex = 1);
                  context.go('/handyman_profile_setup');
                },
              ),
            ],
          ),
        ),
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
        return RequestCard(
          request: request,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<RequestsBloc>(),
                  child: RequestDetailsScreen(request: request),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
