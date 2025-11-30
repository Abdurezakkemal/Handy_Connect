import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_connect/providers/requests_provider.dart';
import 'package:handy_connect/widgets/request_card.dart';
import 'package:intl/intl.dart';

class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempId = "user-8283-not-real-id";
    final requests = ref.watch(getRequestsProvider(tempId));
    return requests.when(
      data: (data) {
        if (data.isEmpty) {
          return Center(child: Text("No Requests"));
        }
        return ListView.builder(
          padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final currentItem = data[index];
            return RequestCard(
              name: currentItem.handymenName,
              role: currentItem.service,
              description: currentItem.description,
              status: currentItem.status,
              dateTime: DateFormat.yMMMd().add_jm().format(
                currentItem.time.toLocal(),
              ),
            );
          },
        );
      },

      error: (error, _) => Center(child: SelectableText(error.toString())),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
