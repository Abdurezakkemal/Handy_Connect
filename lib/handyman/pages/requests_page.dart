import 'package:flutter/material.dart';

import '../handyman_bloc.dart';
import '../models/request_item.dart';

class RequestsPage extends StatefulWidget {
  final HandymanBloc bloc;

  const RequestsPage({super.key, required this.bloc});

  @override
  State<RequestsPage> createState() => _RequestsPageState();
}

class _RequestsPageState extends State<RequestsPage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 18.0,
              vertical: 18.0,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.build, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Service Requests',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manage your bookings',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _tabIndex = 0),
                    child: StreamBuilder<List<RequestItem>>(
                      stream: widget.bloc.requestsStream,
                      builder: (context, snap) {
                        final list = snap.data ?? [];
                        final pending = list
                            .where((r) => r.status == RequestStatus.pending)
                            .length;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 18,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: _tabIndex == 0
                                ? Colors.black
                                : Colors.transparent,
                          ),
                          child: Text(
                            'Pending ($pending)',
                            style: TextStyle(
                              color: _tabIndex == 0
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _tabIndex = 1),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 18,
                        ),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'All Requests',
                          style: TextStyle(
                            color: _tabIndex == 1
                                ? Colors.black
                                : Colors.black54,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 36),

          Expanded(
            child: StreamBuilder<List<RequestItem>>(
              stream: widget.bloc.requestsStream,
              builder: (context, snapshot) {
                final requests = snapshot.data ?? [];
                if (requests.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: const Icon(
                          Icons.assignment,
                          size: 46,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'No requests yet',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Pending requests will appear here',
                        style: TextStyle(color: Colors.black45),
                      ),
                      const SizedBox(height: 80),
                    ],
                  );
                }

                final visible = requests
                    .where(
                      (r) => _tabIndex == 0
                          ? r.status == RequestStatus.pending
                          : true,
                    )
                    .toList();

                if (visible.isEmpty) {
                  return Center(
                    child: Text(
                      _tabIndex == 0 ? 'No pending requests' : 'No requests',
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(18),
                  itemBuilder: (context, idx) {
                    final r = visible[idx];
                    return ListTile(
                      tileColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: CircleAvatar(child: Text(r.customerName[0])),
                      title: Text(r.customerName),
                      subtitle: Text(r.service),
                      trailing: Text(
                        r.status == RequestStatus.pending
                            ? 'Pending'
                            : r.status == RequestStatus.accepted
                            ? 'Accepted'
                            : 'Rejected',
                      ),
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              RequestDetailsPage(bloc: widget.bloc, request: r),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: visible.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// we embed details page below for convenience
class RequestDetailsPage extends StatefulWidget {
  final HandymanBloc bloc;
  final RequestItem request;

  const RequestDetailsPage({
    super.key,
    required this.bloc,
    required this.request,
  });

  @override
  State<RequestDetailsPage> createState() => _RequestDetailsPageState();
}

class _RequestDetailsPageState extends State<RequestDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final r = widget.request;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  CircleAvatar(child: Text(r.customerName[0])),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r.customerName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(r.service),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: const Text('No extra details provided yet.'),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await widget.bloc.updateRequestStatus(
                        r.id,
                        RequestStatus.rejected,
                      );
                      if (mounted) navigator.pop();
                    },
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final navigator = Navigator.of(context);
                      await widget.bloc.updateRequestStatus(
                        r.id,
                        RequestStatus.accepted,
                      );
                      if (mounted) navigator.pop();
                    },
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
