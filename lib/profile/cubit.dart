import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:parking_4/constants/apiKey.dart';

import 'package:parking_4/constants/cachHelper.dart';
import 'package:parking_4/profile/profileStates.dart';
import 'package:parking_4/profile/profile_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  dynamic user;
  Future<void> fetchUserData({bool forceRefresh = false}) async {
    // If already loaded and not forced, do nothing
    if (state is UserLoaded && !forceRefresh) return;

    final token = await getAuthToken();

    if (token == null) {
      emit(UserError("User is not logged in or token is missing"));
      return;
    }

    emit(UserLoading());

    try {
      var response = await Dio().get(
        '$baseUrl/api/user',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": CacheHelper.getData(key: "language") ?? "en",
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        user = UserModel.fromJson(response.data);
        emit(UserLoaded(user));
      } else {
        emit(UserError(
            "Failed to load user data. Status: ${response.statusCode}"));
      }
    } catch (e) {
      emit(UserError("Error fetching user data: $e"));
    }
  }

  Future<void> updateUserData(String name, String phone, String email) async {
    final token = await getAuthToken();

    if (name.isEmpty || phone.isEmpty || email.isEmpty) {
      emit(UpdateFaild("pleaseFillAllFields".tr()));
      return;
    }

    emit(UserUpstaeLoading());

    try {
      var response = await Dio().post(
        '$baseUrl/api/update',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Accept-Language": CacheHelper.getData(key: "language"),
          },
          validateStatus: (status) => status != null && status < 600,
        ),
        data: {
          "name": name.trim(),
          "phone": phone.trim(),
          "email": email.trim(),
        },
      );

      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        UserModel updatedUserModel = UserModel.fromJson(response.data);
        emit(UserUpdateLoaded(updatedUserModel));
      } else {
        emit(UpdateFaild("${response.data}")); // General failure message
      }
    } catch (e) {
      if (e is DioException) {
        // Extract the error message from response
        final errorData = e.response?.data;
        if (errorData != null && errorData is Map<String, dynamic>) {
          String errorMessage =
              "pleaseTryAgain".tr(); // Default error message in Arabic

          if (errorData.containsKey('message')) {
            errorMessage = errorData['message'];
          }

          emit(UpdateFaild(errorMessage));
          return;
        }
      }
      emit(UpdateFaild("pleaseTryAgain".tr()));
    }
  }

  Future<void> deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("token");

    if (token == null) {
      emit(UserError("Authentication token not found"));
      return;
    }

    emit(UserLoading()); // Show loading state

    try {
      var response = await Dio().delete(
        '$baseUrl/api/delete',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      print("Response Data: ${response.data}"); // Debugging

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");
        emit(UserDeleted()); // Emit deleted state
      } else {
        emit(UserError("Failed to delete user: ${response.data}"));
      }
    } catch (e) {
      emit(UserError("Error: $e"));
    }
  }

  Future<void> LogOut() async {
    Future<String?> getAuthToken() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString("token");
    }

    final token = await getAuthToken();
    emit(UserLoading());
    try {
      var response = await Dio().post(
        '$baseUrl/api/logout',
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
          },
          validateStatus: (status) => status != null && status < 600,
        ),
      );

      print("Response Data: ${response.data}"); // Debugging

      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove("token");

        if (response.data is String) {
          // If the response is a String, decode it into a Map
          response.data = jsonDecode(response.data);
        }

        if (response.data is Map<String, dynamic>) {
          UserModel user = UserModel.fromJson(response.data);
          emit(UserLoaded(user));
        } else {
          emit(UserError("Unexpected response format"));
        }
      } else {
        emit(UserError("Failed to load user data"));
      }
    } catch (e) {
      emit(UserError("Error: $e"));
    }
  }

  Future<String?> getAuthToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}
