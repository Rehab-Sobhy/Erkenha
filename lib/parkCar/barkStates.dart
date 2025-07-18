abstract class ParkCarState {}

class ParkCarInitial extends ParkCarState {}

class ParkCarLoading extends ParkCarState {}

class ParkCarSuccess extends ParkCarState {
  final String message;
  ParkCarSuccess(this.message);
}

class ParkCarFailed extends ParkCarState {
  final String error;
  ParkCarFailed(this.error);
}

class RejecParkingLoading extends ParkCarState {}

class RejecParkingSuccess extends ParkCarState {
  final String message;
  RejecParkingSuccess(this.message);
}

class RejecParkingFailed extends ParkCarState {
  final String error;
  RejecParkingFailed(this.error);
}
