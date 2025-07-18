import 'package:parking_4/categories/model.dart';
import 'package:parking_4/home/homeScreenModel.dart';

abstract class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeDataSuccess extends HomeStates {
  final List<HomeScreenModel> categories;
  final List<HomeScreenModel> places;

  HomeDataSuccess(this.categories, this.places);
}

class HomeDataError extends HomeStates {
  final String error;

  HomeDataError(this.error);
}

class CategoriesLoadingState extends HomeStates {}

class CategoriesSuccess extends HomeStates {
  final List<CategoryModel> category;

  CategoriesSuccess(this.category);
}

class CategoryError extends HomeStates {
  final String error;

  CategoryError(this.error);
}
