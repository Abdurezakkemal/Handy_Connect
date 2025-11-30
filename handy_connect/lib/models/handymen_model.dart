class HandymenModel {
  final String id;
  final String name;
  final String service;
  final String location;
  final String description;
  final String image;
  final Map socialMedia;

  HandymenModel({
    required this.id,
    required this.name,
    required this.service,
    required this.location,
    required this.description,
    required this.image,
    required this.socialMedia,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'service': service,
      'location': location,
      'description': description,
      'socialMedia': socialMedia,
      'image': image,
    };
  }

  factory HandymenModel.fromJson(Map<String, dynamic> json) {
    return HandymenModel(
      id: json['id'],
      name: json['name'],
      service: json['service'],
      location: json['location'],
      description: json['description'],
      image: json['image'],
      socialMedia: json['socialMedia'],
    );
  }
}
