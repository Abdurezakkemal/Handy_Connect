import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:handy_connect/models/requests_model.dart';
import 'package:handy_connect/models/user.dart';
import 'package:handy_connect/providers/requests_provider.dart';

class RequestServicePage extends StatefulWidget {
  final User handyman;

  const RequestServicePage({super.key, required this.handyman});

  @override
  State<RequestServicePage> createState() => _RequestServicePageState();
}

class _RequestServicePageState extends State<RequestServicePage> {
  final TextEditingController issueController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  late DateTime selectedDate;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();

  Future<void> pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    final selected = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    setState(() {
      selectedDate = selected;
      dateTimeController.text =
          "${selected.month}/${selected.day}/${selected.year}  ${time.format(context)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    final messenger = ScaffoldMessenger.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Request Service",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              widget.handyman.name,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Describe your issue *",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextFormField(
                        controller: issueController,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText:
                              "Please describe the problem or service you need...",
                          border: InputBorder.none,
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Please fill out this field.";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Preferred Date & Time *",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: pickDateTime,
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              dateTimeController.text.isEmpty
                                  ? "mm/dd/yyyy --:-- --"
                                  : dateTimeController.text,
                              style: TextStyle(
                                color: dateTimeController.text.isEmpty
                                    ? Colors.grey[400]
                                    : Theme.of(context).colorScheme.onSurface,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "After your request is accepted, you'll be able to contact "
                        "the handyman directly via WhatsApp, Telegram, or phone to "
                        "discuss details and arrange the service.",
                        style: TextStyle(fontSize: 14, height: 1.4),
                      ),
                    ),

                    const SizedBox(height: 30),

                    Consumer(
                      builder: (context, WidgetRef ref, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.onSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });

                                ///Needs modification
                                final request = RequestsModel(
                                  customerId: "user-8283-not-real-id",
                                  handymanId: widget.handyman.uid,
                                  issueDescription: issueController.text,
                                  status: "pending",
                                  preferredTime: selectedDate,
                                  createdAt: DateTime.now(),
                                  customerName: "Some One",
                                );
                                try {
                                  await ref
                                      .read(requestServiceProvider)
                                      .sendBookingRequest(request);
                                  if (mounted) {
                                    messenger.showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.green,
                                        behavior: SnackBarBehavior.floating,
                                        showCloseIcon: true,
                                        content: Text("Request Submitted"),
                                      ),
                                    );
                                  }
                                } catch (e) {
                                  debugPrint(e.toString());
                                  if (mounted) {
                                    messenger.showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        showCloseIcon: true,
                                        content: Text(e.toString()),
                                      ),
                                    );
                                  }
                                } finally {
                                  if (mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                }
                              }
                            },
                            child: Text(
                              "Submit Request",
                              style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.surface,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
