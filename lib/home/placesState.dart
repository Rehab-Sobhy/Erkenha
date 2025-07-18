abstract class PlacesState {}

class PlacesInitialState extends PlacesState {}

class PlacesLoadingState extends PlacesState {}

class GetPlacesSuccess extends PlacesState {
  final List<dynamic> places;
  GetPlacesSuccess(this.places);
}

class PlacesError extends PlacesState {
  final String message;
  PlacesError(this.message);
}
