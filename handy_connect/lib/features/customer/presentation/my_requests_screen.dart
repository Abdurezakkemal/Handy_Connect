import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/core/locator.dart';
import 'package:handy_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:handy_connect/features/customer/presentation/bloc/my_requests_bloc.dart';
import 'package:handy_connect/features/handyman/presentation/widgets/request_card.dart';

class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final String uid = authState is Authenticated
        ? authState.user.uid
        : (authState as AuthenticatedWithUserType).user.uid;

    return BlocProvider(
      create: (_) => locator<MyRequestsBloc>()..add(FetchMyRequests(uid)),
      child: const MyRequestsView(),
    );
  }
}

class MyRequestsView extends StatelessWidget {
  const MyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: BlocBuilder<MyRequestsBloc, MyRequestsState>(
        builder: (context, state) {
          if (state is MyRequestsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MyRequestsLoaded) {
            if (state.requests.isEmpty) {
              return const Center(child: Text('No requests found.'));
            }
            return ListView.builder(
              itemCount: state.requests.length,
              itemBuilder: (context, index) {
                final request = state.requests[index];
                return RequestCard(request: request);
              },
            );
          } else if (state is MyRequestsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
