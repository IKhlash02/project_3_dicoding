part of 'restaurant_detail_bloc.dart';


class RestaurantDetailState {
  final ResultState state;
  final RestaurantDetail? restaurant;
  final String? message;

  RestaurantDetailState({
    required this.state,
    this.restaurant,
    this.message,
  });
}
