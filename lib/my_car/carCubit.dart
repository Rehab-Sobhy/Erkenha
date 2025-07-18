import 'package:dio/dio.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parking_4/constants/apiKey.dart';
import 'package:parking_4/constants/cachHelper.dart';
import 'package:parking_4/my_car/carStates.dart';

import 'package:parking_4/parkCar/reservation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarCubit extends Cubit<CarStates> {
  CarCubit() : super(CarInitial());

  final Dio _dio = Dio();

  List<Map<String, dynamic>> cars = [];

  List<dynamic> orders = [];
  List<Reservation> reservations = [];
  bool isLoading = true;

  // Get Auth Token
  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  // Add Car
  Future<void> addCar(Map<String, dynamic> carData) async {
    final token = await getAuthToken();
    emit(AddCarLoading());
    try {
      final response = await _dio.post(
        '$baseUrl/api/cars-users',
        data: carData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(AddCarSuccess('Car added successfully: ${response.data}'));
      } else {
        emit(AddCarFailed(
            'Failed to add car. Status Code: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AddCarFailed(error.toString()));
    }
  }

  // Update Car
  Future<void> updateCar(int id, Map<String, dynamic> carData) async {
    final token = await getAuthToken();
    emit(UpdateCarLoading());
    try {
      final response = await _dio.post(
        '$baseUrl/api/cars-users/update/$id',
        data: carData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );
      emit(UpdateCarSuccess('Car updated successfully: ${response.data}'));
    } catch (error) {
      emit(UpdateCarFailed(error.toString()));
    }
  }

  bool _carsLoaded = false;
  // Fetch Cars
  bool get isCarsLoaded => _carsLoaded;

  Future<void> fetchCars({bool forceRefresh = false}) async {
    if (_carsLoaded && !forceRefresh) {
      emit(GetCarSuccess(cars));
      return;
    }

    emit(GetCarLoading());

    final token = await getAuthToken();
    try {
      final response = await _dio.get(
        '$baseUrl/api/cars-users',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": CacheHelper.getData(key: "language"),
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (response.statusCode == 200) {
        cars = List<Map<String, dynamic>>.from(response.data['data']);
        _carsLoaded = true;
        emit(GetCarSuccess(cars));
      } else {
        emit(GetCarFailed("فشل في تحميل السيارات"));
      }
    } catch (e) {
      emit(GetCarFailed("خطأ أثناء تحميل السيارات: $e"));
    }
  }

  Future<void> deleteCar(int carId) async {
    emit(DeleteCarLoading()); // تحميل
    final token = await getAuthToken();

    try {
      final response = await Dio().delete(
        '$baseUrl/api/cars-users/$carId',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (response.statusCode == 200) {
        cars = List.from(cars)..removeWhere((car) => car['id'] == carId);

        emit(GetCarSuccess(cars)); // الآن سيتم إعادة بناء الواجهة تلقائيًا
        emit(DeleteCarSuccess("تم حذف السيارة بنجاح"));
      } else {
        emit(DeleteCarFailed("فشل في حذف السيارة"));
      }
    } catch (e) {
      emit(DeleteCarFailed("خطأ أثناء حذف السيارة: $e"));
    }
  }

  // Fetch Orders
  Future<void> fetchOrders() async {
    final token = await getAuthToken();
    try {
      final response = await Dio().get(
        '$baseUrl/api/orders',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": CacheHelper.getData(key: "language"),
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (response.statusCode == 200) {
        orders = response.data['data'];
        // You can emit a state if you want to show orders in UI
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  // Fetch Reservations
  Future<List<Reservation>> fetchReservations() async {
    final token = await getAuthToken();
    try {
      final response = await Dio().get(
        '$baseUrl/api/reservations',
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      print(response.data); // Check the response data to ensure it's correct

      // Check if response data is a list
      if (response.data is List) {
        List<dynamic> dataList = response.data;
        // Map the dataList to Reservation objects
        reservations = dataList
            .map((json) => Reservation.fromJson(json as Map<String, dynamic>))
            .toList();
        return reservations;
      } else if (response.data is Map<String, dynamic> &&
          response.data['data'] is List) {
        // If data is in a map and the actual data is under the 'data' key
        List<dynamic> dataList = response.data['data'];
        reservations = dataList
            .map((json) => Reservation.fromJson(json as Map<String, dynamic>))
            .toList();
        print("test $reservations");
        return reservations;
      } else {
        print('Unexpected data format');
        return [];
      }
    } catch (e) {
      print('Error fetching reservations: $e');
      return [];
    }
  }
}
