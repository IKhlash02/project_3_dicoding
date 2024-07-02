import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_1/data/api/api_service.dart';
import 'package:project_1/data/model/restaurant_element.dart';

import '../common/result_state.dart';

class RestaurantSearchProvider extends ChangeNotifier {
  final ApiService apiService;
  String _query = "firs search";

  RestaurantSearchProvider({required this.apiService}) {
    _fechtSearchrestaurant(_query);
  }

  void searchRestaurant(String search) {
    if (search.isEmpty) {
      _state = ResultState.noData;
      notifyListeners();

      return;
    }
    _query = search;
    _fechtSearchrestaurant(_query);
  }

  String _message = "";
  late List<RestaurantElement> _listRestaurant;
  late ResultState _state;

  String get message => _message;

  List<RestaurantElement> get result => _listRestaurant;

  ResultState get state => _state;

  Future<dynamic> _fechtSearchrestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurant = await apiService.searchRestaurant(query);
      if (restaurant.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Restaurant not found";
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _listRestaurant = restaurant;
      }
    } catch (e) {
      String errorMessage = "An error occurred";

      // Menyesuaikan pesan error berdasarkan jenis kesalahan yang terjadi
      if (e is SocketException) {
        errorMessage = "No internet connection";
      } else if (e is TimeoutException) {
        errorMessage = "Request timed out";
      } else if (e is FormatException) {
        errorMessage = "Invalid data format";
      }

      _state = ResultState.error;
      notifyListeners();
      return _message = errorMessage;
    }
  }
}
