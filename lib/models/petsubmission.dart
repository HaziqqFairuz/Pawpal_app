class Petsubmission {
  String? petId;
  String? userId;
  String? petName;
  String? petAge;
  String? petType;
  String? petGender;
  String? petHealth;
  String? category;
  String? description;
  String? postedBy;
  String? adoptionStatus;
  List<String> images = [];

  Petsubmission({
    this.petId,
    this.userId,
    this.petName,
    this.petAge,
    this.petType,
    this.petGender,
    this.petHealth,
    this.category,
    this.description,
    this.postedBy,
    this.adoptionStatus,
    this.images = const [],
  });

  Petsubmission.fromJson(Map<String, dynamic> json) {
    petId = json['pet_id'];
    userId = json['user_id'];
    petName = json['pet_name'];
    petAge = json['pet_age'];
    petType = json['pet_type'];
    petGender = json['pet_gender'];
    petHealth = json['pet_health'];
    category = json['category'];
    description = json['description'];
    postedBy = json['posted_by'];
    adoptionStatus = json['adoption_status'] ?? "Available";

    if (json["images"] != null) {
      images = json["images"].toString().split(',');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pet_id'] = petId;
    data['user_id'] = userId;
    data['pet_name'] = petName;
    data['pet_age'] = petAge;
    data['pet_type'] = petType;
    data['pet_gender'] = petGender;
    data['pet_health'] = petHealth;
    data['category'] = category;
    data['description'] = description;
    data['posted_by'] = postedBy;
    data['adoption_status'] = adoptionStatus;
    data['images'] = images;
    return data;
  }
}
