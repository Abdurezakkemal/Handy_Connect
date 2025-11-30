class RequestsModel {
  final String requesterID;
  final String handymenName;
  final String handymenID;
  final String service;
  final String description;
  final String status;
  final DateTime time;

  RequestsModel({
    required this.requesterID,
    required this.handymenName,
    required this.handymenID,
    required this.service,
    required this.description,
    required this.status,
    required this.time,
  });

  factory RequestsModel.fromJson(Map<String, dynamic> json) {
    return RequestsModel(
      requesterID: json['requesterID'] as String,
      handymenName: json['handymenName'] as String,
      handymenID: json['handymenID'] as String,
      service: json['service'] as String,
      description: json['description'] as String,
      status: json['status'] as String,
      time: DateTime.parse(json['time'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requesterID': requesterID,
      'handymenName': handymenName,
      'handymenID': handymenID,
      'service': service,
      'description': description,
      'status': status,
      'time': time.toIso8601String(),
    };
  }
}
