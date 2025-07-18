import 'package:flutter/material.dart';

class HomeScreenModel extends ChangeNotifier {
  final int id;
  String name;
  dynamic description;
  dynamic location;
  dynamic webLocation;
  dynamic parkingsCount;
  final int categoryId;
  dynamic image;

  HomeScreenModel({
    required this.id,
    required this.name,
    this.description,
    required this.location,
    required this.webLocation,
    required this.parkingsCount,
    required this.categoryId,
    required this.image,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) {
    return HomeScreenModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'], // Allow null
      location: json['location'] ?? '',
      webLocation: json['webLocation'] ?? '',
      parkingsCount: json['available_spots'] ?? '0',
      categoryId: json['category_id'] ?? 0,
      image: json['image'] ?? '',
    );
  }

  @override
  String toString() {
    return 'HomeScreenModel{id: $id, name: $name, description: $description, location: $location, webLocation: $webLocation, parkingsCount: $parkingsCount, categoryId: $categoryId, image: $image}';
  }
}
