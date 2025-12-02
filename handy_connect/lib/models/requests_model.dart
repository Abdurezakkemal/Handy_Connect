class RequestsModel {
  final String customerId;
  final String customerName;
  final String handymanId;
  // final String handymenName;
  // final String service;
  final String issueDescription;
  final String status;
  final DateTime createdAt;
  final DateTime preferredTime;

  RequestsModel({
    required this.customerId,
    required this.customerName,
    required this.handymanId,
    // required this.service,
    required this.issueDescription,
    required this.status,
    required this.createdAt,
    required this.preferredTime,
  });

  factory RequestsModel.fromJson(Map<String, dynamic> json) {
    return RequestsModel(
      customerId: json['customerId'] as String,
      customerName: json['customerName'] as String,
      handymanId: json['handymanId'] as String,
      // service: json['service'] as String,
      issueDescription: json['issueDescription'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      preferredTime: DateTime.parse(json['preferredTime'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'handymanId': handymanId,
      // 'service': service,
      'issueDescription': issueDescription,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'preferredTime': preferredTime.toIso8601String(),
    };
  }
}
