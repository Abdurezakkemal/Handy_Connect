class User {
  final String email;
  final String experience;
  final String location;
  final String name;
  final String phone;
  final String profilePhoto;
  final String profilePhotoUrl;
  final String serviceType;
  final Map<String, dynamic> socialLinks;
  final String uid;
  final String userType;

  User({
    required this.email,
    required this.experience,
    required this.location,
    required this.name,
    required this.phone,
    required this.profilePhoto,
    required this.profilePhotoUrl,
    required this.serviceType,
    required this.socialLinks,
    required this.uid,
    required this.userType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      experience: json['experience'] ?? '',
      location: json['location'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
      profilePhotoUrl: json['profilePhotoUrl'] ?? '',
      serviceType: json['serviceType'] ?? '',
      socialLinks: Map<String, dynamic>.from(json['socialLinks'] ?? {}),
      uid: json['uid'] ?? '',
      userType: json['userType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'experience': experience,
      'location': location,
      'name': name,
      'phone': phone,
      'profilePhoto': profilePhoto,
      'profilePhotoUrl': profilePhotoUrl,
      'serviceType': serviceType,
      'socialLinks': socialLinks,
      'uid': uid,
      'userType': userType,
    };
  }
}
