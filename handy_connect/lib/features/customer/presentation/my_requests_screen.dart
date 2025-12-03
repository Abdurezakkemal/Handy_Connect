import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/customer/presentation/bloc/my_requests_bloc.dart';
import 'package:handy_connect/features/handyman/presentation/widgets/request_card.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    debugPrint('MyRequestsScreen - Auth State: ${authState.runtimeType}');

    String uid;
    if (authState is Authenticated) {
      uid = authState.user.uid;
      debugPrint('MyRequestsScreen - Using Authenticated UID: $uid');
    } else if (authState is AuthenticatedWithUserType) {
      uid = authState.user.uid;
      debugPrint(
        'MyRequestsScreen - Using AuthenticatedWithUserType UID: $uid',
      );
    } else {
      debugPrint('MyRequestsScreen - Error: User is not authenticated');
      // Return an error widget or handle unauthenticated state
      return const Scaffold(
        body: Center(child: Text('Please sign in to view your requests')),
      );
    }

    return BlocProvider(
      create: (_) {
        debugPrint(
          'MyRequestsScreen - Creating MyRequestsBloc and dispatching FetchMyRequests',
        );
        return locator<MyRequestsBloc>()..add(FetchMyRequests(uid));
      },
      child: const MyRequestsView(),
    );
  }
}

class MyRequestsView extends StatelessWidget {
  const MyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyRequestsBloc, MyRequestsState>(
      listener: (context, state) {
        if (state is MyRequestsError) {
          debugPrint('MyRequestsView - Error: ${state.message}');
        } else if (state is MyRequestsLoaded) {
          debugPrint(
            'MyRequestsView - Loaded ${state.requests.length} requests',
          );
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<MyRequestsBloc>().add(const BackButtonPressed());
              // Use GoRouter to navigate to the home screen
              context.go('/customer_home');
            },
          ),
          title: const Text('My Requests'),
        ),
        body: BlocBuilder<MyRequestsBloc, MyRequestsState>(
          builder: (context, state) {
            debugPrint('MyRequestsView - Current state: ${state.runtimeType}');

            if (state is MyRequestsLoading) {
              debugPrint('MyRequestsView - Loading requests...');
              return const Center(child: CircularProgressIndicator());
            } else if (state is MyRequestsError) {
              debugPrint('MyRequestsView - Error state: ${state.message}');
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is MyRequestsLoaded) {
              debugPrint(
                'MyRequestsView - Loaded ${state.requests.length} requests',
              );
              if (state.requests.isEmpty) {
                debugPrint('MyRequestsView - No requests found');
                return const Center(child: Text('No requests found'));
              }
              return ListView.builder(
                itemCount: state.requests.length,
                itemBuilder: (context, index) {
                  final request = state.requests[index];
                  debugPrint(
                    'MyRequestsView - Rendering request: ${request.requestId}',
                  );
                  return RequestCard(
                    request: request,
                    onTap: () {
                      // TODO: Navigate to request details screen
                      // You'll need to implement this navigation based on your app's routing
                      debugPrint('Tapped on request: ${request.requestId}');
                    },
                  );
                },
              );
            }
            debugPrint('MyRequestsView - Unknown state: $state');
            return const Center(child: Text('Unknown state'));
          },
        ),
      ),
    );
  }
}
