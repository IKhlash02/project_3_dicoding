import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:project_1/common/result_state.dart';
import 'package:project_1/common/ui_state.dart';
import 'package:project_1/data/model/restaurant_detail.dart';

import '../../data/api/api_service.dart';

part 'restaurant_detail_event.dart';
part 'restaurant_detail_state.dart';

class RestaurantDetailBloc
    extends Bloc<RestaurantDetailEvent, UiState> {
  final ApiService apiService;

  RestaurantDetailBloc({required this.apiService})
      : super(const Loading()) {

    on<FetchDetailRestaurant>(_onFetchDetailRestaurant);
  }

  Future<dynamic> _onFetchDetailRestaurant(
      FetchDetailRestaurant event, Emitter<UiState> emit) async {
    try {

      emit(const Loading());

      final restaurant = await apiService.detailRestaurant(event.id);

      emit(Success<RestaurantDetail>(restaurant));
      debugPrint("apiNilai: $emit");
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

      emit(Error(errorMessage));
    }
  }
}
