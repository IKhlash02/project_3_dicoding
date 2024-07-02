import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:project_1/common/result_state.dart';
import 'package:project_1/data/api/api_service.dart';
import 'package:project_1/data/model/restaurant_element.dart';

part 'list_restaurant_event.dart';
part 'list_restaurant_state.dart';

class ListRestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final ApiService apiService;

  ListRestaurantBloc({
    required this.apiService,
  }) : super(RestaurantState(state: ResultState.loading)) {

    on<FetchListRestaurant>(_onFetchListRestaurant);
  }

  Future<void> _onFetchListRestaurant(
      FetchListRestaurant event, Emitter<RestaurantState> emit) async {
    try {
      emit(RestaurantState(state: ResultState.loading));

      final restaurant = await apiService.listRestaurant();

      if (restaurant.isEmpty) {
        emit(RestaurantState(state: ResultState.noData));
      } else {
        emit(RestaurantState(
            state: ResultState.hasData, listRestaurant: restaurant));
      }
    } catch (e) {
      String errorMessage = "An error occurred";

      if (e is SocketException) {
        errorMessage = "No internet connection";
      } else if (e is TimeoutException) {
        errorMessage = "Request timed out";
      } else if (e is FormatException) {
        errorMessage = "Invalid data format";
      }

      emit(RestaurantState(state: ResultState.error, message: errorMessage));
    }
  }
}
