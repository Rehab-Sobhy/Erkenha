import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:parking_4/categories/model.dart';
import 'package:parking_4/constants/apiKey.dart';

import 'package:parking_4/constants/cachHelper.dart';

import 'package:parking_4/home/homeStates.dart';

class Categorycubit extends Cubit<HomeStates> {
  Categorycubit() : super(HomeInitialState());

  final Dio _dio = Dio();
  List<CategoryModel> categories = [];

  bool _hasLoadedCategories = false;
  Future<void> fetchCategories({bool forceReload = false}) async {
    if (_hasLoadedCategories && !forceReload) {
      emit(CategoriesSuccess(categories));
      return;
    }

    emit(CategoriesLoadingState());

    try {
      final response = await _dio.get(
        "$baseUrl/api/categories",
        options: Options(
          headers: {
            "Accept-Language": CacheHelper.getData(key: "language"),
          },
        ),
      );

      if (response.statusCode == 200) {
        var houses = response.data['data'];
        if (houses == null || houses.isEmpty) {
          print("No categories found.");
          emit(CategoriesSuccess([]));
          return;
        }

        for (var cat in categories) {
          print("Category: ${cat.name}, Desc: ${cat.description}");
        }

        categories = (response.data['data'] as List)
            .map((e) => CategoryModel.fromJson(e))
            .toList();

        _hasLoadedCategories = true;

        emit(CategoriesSuccess(categories));
      } else {
        emit(CategoryError(
            'Failed to load data. Status code: ${response.statusCode}'));
      }
    } catch (e) {
      emit(CategoryError('Error: $e')); // Emit the error state.
    }
  }

  void searchCategories(String query) {
    if (query.isEmpty) {
      emit(CategoriesSuccess(categories));
      return;
    }

    var filteredCategories = categories.where((CategoryModel category) {
      return category.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(CategoriesSuccess(filteredCategories));
  }

  List<PlaceModel> getPlacesByCategoryId(int categoryId) {
    final category = categories.firstWhere(
      (element) => element.id == categoryId,
    );

    if (category.places != null) {
      return category.places;
    }

    return [];
  }
}
