import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:parking_4/constants/apiKey.dart';

import 'package:parking_4/parkCar/barkStates.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkCarCubit extends Cubit<ParkCarState> {
  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  ParkCarCubit() : super(ParkCarInitial());

  final Dio _dio = Dio();

  // Buy parking
  Future<void> buyParking({
    required int? placeid,
    required int? carId,
    required String? day,
    required String? time,
    BuildContext? context,
  }) async {
    final token = await getAuthToken();
    emit(ParkCarLoading());

    try {
      print('Place ID: $placeid');
      print('Car ID: $carId');
      print('Day: $day');
      print('Time: $time');

      if (placeid == null || carId == null || day == null || time == null) {
        emit(ParkCarFailed('One or more required fields are missing.'));
        print('Error: One or more required fields are missing.');
        return;
      }

      FormData formData = FormData.fromMap({
        "place_id": placeid,
        "car_id": carId,
        "day": day,
        "time": time,
      });

      final response = await _dio.post(
        '$baseUrl/api/reservations',
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Rejec": "application/json",
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(ParkCarSuccess('Car added successfully: ${response.data}'));
      } else if (response.data is Map && response.data['status'] == 'failed') {
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("thereisparkinginsametimewiththesamecar".tr()),
            ),
          );
        }
        emit(ParkCarFailed('thereisparkinginsametimewiththesamecar'.tr()));
      } else {
        emit(ParkCarFailed(
            'Server error ${response.statusCode}: ${response.data}'));
      }
    } catch (error) {
      print('Caught error: $error');
      emit(ParkCarFailed(error.toString()));
    }
  }

  // Reject parking
  Future<void> rejectParking(dynamic id) async {
    final token = await getAuthToken();
    emit(RejecParkingLoading());

    try {
      final response = await _dio.post(
        '$baseUrl/api/reservations/$id/cancel',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      print('Reject response: ${response.statusCode} | ${response.data}');

      emit(RejecParkingSuccess('Car reservation cancelled: ${response.data}'));
    } catch (error) {
      print('Reject error: $error');
      emit(RejecParkingFailed(error.toString()));
    }
  }
}
