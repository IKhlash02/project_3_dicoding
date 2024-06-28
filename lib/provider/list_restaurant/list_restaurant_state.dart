// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'list_restaurant_bloc.dart';

class RestaurantState {
  final ResultState state;
  final List<RestaurantElement>? listRestaurant;
  final String? message;

  RestaurantState({
    required this.state,
    this.listRestaurant,
    this.message,
  });
}
