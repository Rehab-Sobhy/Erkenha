import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:parking_4/constants/apiKey.dart';

// Define the states
abstract class NotificationState {}

class NotificationLoadingState extends NotificationState {}

class NotificationSuccessState extends NotificationState {
  final List<dynamic> notifications;
  NotificationSuccessState(this.notifications);
}

class NotificationErrorState extends NotificationState {
  final String errorMessage;
  NotificationErrorState(this.errorMessage);
}

// Define the Cubit
class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationLoadingState());

  // Fetch notifications from the API
  Future<void> fetchNotifications() async {
    try {
      emit(NotificationLoadingState()); // Show loading state

      // Replace with your actual API endpoint
      var response = await Dio().get('$baseUrl/api/notifications');

      if (response.statusCode == 200) {
        emit(NotificationSuccessState(response.data['data'])); // Success state
      } else {
        emit(NotificationErrorState('Failed to fetch notifications'));
      }
    } catch (e) {
      emit(NotificationErrorState('Error: $e')); // Error state
    }
  }
}
