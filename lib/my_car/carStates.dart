abstract class CarStates {}

class CarInitial extends CarStates {}

class AddCarSuccess extends CarStates {
  final String message;
  AddCarSuccess(this.message);
}

class AddCarFailed extends CarStates {
  final String error;
  AddCarFailed(this.error);
}

class AddCarLoading extends CarStates {}

class UpdateCarSuccess extends CarStates {
  final String message;
  UpdateCarSuccess(this.message);
}

class UpdateCarFailed extends CarStates {
  final String error;
  UpdateCarFailed(this.error);
}

class UpdateCarLoading extends CarStates {}

class GetCarLoading extends CarStates {}

class GetCarSuccess extends CarStates {
  final List<Map<String, dynamic>> cars;
  GetCarSuccess(this.cars);
}

class GetCarFailed extends CarStates {
  final String error;
  GetCarFailed(this.error);
}

class DeleteCarLoading extends CarStates {}

class DeleteCarSuccess extends CarStates {
  final String message;
  DeleteCarSuccess(this.message);
}

class DeleteCarFailed extends CarStates {
  final String error;
  DeleteCarFailed(this.error);
}
