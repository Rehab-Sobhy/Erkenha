class Reservation {
  final int id;
  dynamic status;
  dynamic day;
  dynamic time;
  final Place place;
  final Car car;

  Reservation({
    required this.id,
    required this.status,
    required this.day,
    required this.time,
    required this.place,
    required this.car,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      status: json['status'],
      day: json['day'],
      time: json['time'],
      place: Place.fromJson(json['place']),
      car: Car.fromJson(json['car']),
    );
  }
}

class Place {
  final int id;
  dynamic image;
  dynamic webLocation;
  final Map<String, String> name;
  final Map<String, String> location;

  Place({
    required this.id,
    required this.image,
    required this.webLocation,
    required this.name,
    required this.location,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'],
      image: json['image'],
      webLocation: json['webLocation'],
      name: Map<String, String>.from(json['name']),
      location: Map<String, String>.from(json['location']),
    );
  }
}

class Car {
  final int id;
  dynamic carType;
  dynamic carNumber;

  Car({
    required this.id,
    required this.carType,
    required this.carNumber,
  });

  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'],
      carType: json['carType'],
      carNumber: json['carNumber'],
    );
  }
}
