import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_1/data/api/api_service.dart';
import 'package:project_1/data/model/restaurant_element.dart';

import '../common/result_state.dart';

class ListRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  ListRestaurantProvider({required this.apiService}) {
    _fechtListrestaurant();
  }

  String _message = "";
  late List<RestaurantElement> _listRestaurant;
  late ResultState _state;

  String get message => _message;

  List<RestaurantElement> get result => _listRestaurant;

  ResultState get state => _state;

  Future<dynamic> _fechtListrestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final restaurant = await apiService.listRestaurant();
      if (restaurant.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = "Empty Data";
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
