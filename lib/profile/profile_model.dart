class UserModel {
  dynamic name;
  dynamic email;

  dynamic phone;
  dynamic address;
  dynamic image;
  dynamic profilePhotoUrl;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.image,
    this.profilePhotoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      image: json['image'],
      profilePhotoUrl: json['profile_photo_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "phone": phone,
      "address": address,
      "image": image,
      "profile_photo_url": profilePhotoUrl,
    };
  }
}
