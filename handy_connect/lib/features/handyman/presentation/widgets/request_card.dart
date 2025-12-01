import 'package:flutter/material.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';

class RequestCard extends StatelessWidget {
  final ServiceRequest request;

  const RequestCard({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(request.customerName),
        subtitle: Text(
          request.issueDescription,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              request.status.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                color: _getStatusColor(request.status),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${request.preferredTime.toDate().day}/${request.preferredTime.toDate().month}',
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to Request Details Screen
        },
      ),
    );
  }

  Color _getStatusColor(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.accepted:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
    }
  }
}
