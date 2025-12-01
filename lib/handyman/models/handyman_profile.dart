class HandymanProfile {
  String id;
  String fullName;
  String phoneNumber;
  String whatsappNumber;
  String username;
  String serviceType;
  String location;
  String description;

  HandymanProfile({
    required this.id,
    this.fullName = '',
    this.phoneNumber = '',
    this.whatsappNumber = '',
    this.username = '',
    this.serviceType = '',
    this.location = '',
    this.description = '',
  });
}
