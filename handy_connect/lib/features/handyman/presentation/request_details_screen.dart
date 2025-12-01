import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handy_connect/features/handyman/domain/models/service_request.dart';
import 'package:handy_connect/features/handyman/presentation/bloc/requests_bloc.dart';

class RequestDetailsScreen extends StatelessWidget {
  final ServiceRequest request;

  const RequestDetailsScreen({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Customer:', request.customerName),
            _buildDetailRow('Issue:', request.issueDescription),
            _buildDetailRow(
              'Preferred Time:',
              request.preferredTime.toDate().toString(),
            ),
            _buildDetailRow(
              'Status:',
              request.status.toString().split('.').last.toUpperCase(),
            ),
            const Spacer(),
            if (request.status == RequestStatus.pending)
              _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.read<RequestsBloc>().add(
                UpdateRequestStatusEvent(
                  request.requestId,
                  RequestStatus.rejected,
                ),
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              context.read<RequestsBloc>().add(
                UpdateRequestStatusEvent(
                  request.requestId,
                  RequestStatus.accepted,
                ),
              );
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Accept'),
          ),
        ),
      ],
    );
  }
}
