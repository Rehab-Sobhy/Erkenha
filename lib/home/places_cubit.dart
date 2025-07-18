import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:parking_4/constants/apiKey.dart';
import 'package:parking_4/constants/cachHelper.dart';
import 'package:parking_4/home/homeScreenModel.dart';
import 'package:parking_4/home/placesState.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacesCubit extends Cubit<PlacesState> {
  PlacesCubit() : super(PlacesInitialState());

  final Dio _dio = Dio();
  List<HomeScreenModel> places = [];
  bool _dataLoaded = false; // Flag to check if data is already loaded

  Future<String?> getAuthtoken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Function to fetch places only if not already loaded or when forceRefresh is true
  Future<void> fetchPlaces({bool forceRefresh = false}) async {
    if (_dataLoaded && !forceRefresh) {
      emit(GetPlacesSuccess(places)); // If data is already loaded, just emit it
      return;
    }

    final token = await getAuthtoken();
    emit(PlacesLoadingState());

    try {
      final response = await _dio.get(
        "$baseUrl/api/places",
        options: Options(
          headers: {
            "Accept-Language": CacheHelper.getData(key: "language"),
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        var data = response.data['data'];

        if (data == null || data.isEmpty) {
          emit(GetPlacesSuccess([]));
          return;
        }

        places = data.map<HomeScreenModel>((element) {
          return HomeScreenModel.fromJson(element);
        }).toList();
        print("places $places");

        _dataLoaded = true; // Mark data as loaded
        emit(GetPlacesSuccess(places));
      } else {
        emit(PlacesError(
            'Failed to load places. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(PlacesError('Error: $e'));
    }
  }

  void searchPlaces(String query) {
    if (query.isEmpty) {
      emit(GetPlacesSuccess(places)); // Reset to all places
      return;
    }

    final filteredPlaces = places.where((place) {
      return place.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(GetPlacesSuccess(filteredPlaces));
  }

  // Manually force a reload of places data
  Future<void> refreshPlaces() async {
    _dataLoaded = false; // Reset the dataLoaded flag to force fetch
    await fetchPlaces(forceRefresh: true);
  }
}
