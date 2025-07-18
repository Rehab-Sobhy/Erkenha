class CategoryModel {
  final int id;
  final String name;
  final String description;
  final String image;
  final List<PlaceModel> places;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.places,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      places:
          (json['places'] as List).map((e) => PlaceModel.fromJson(e)).toList(),
    );
  }
}

class PlaceModel {
  final int id;
  final String name;
  final String location;
  final String image;
  dynamic weblocation;
  dynamic parkCount;

  PlaceModel(
      {required this.id,
      required this.name,
      required this.location,
      required this.parkCount,
      required this.image,
      required this.weblocation});

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'],
      parkCount: json["available_spots"],
      weblocation: json["webLocation"],
      name: json['name'],
      location: json['location'],
      image: json['image'],
    );
  }
}
