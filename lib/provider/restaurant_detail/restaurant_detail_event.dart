part of 'restaurant_detail_bloc.dart';

abstract class RestaurantDetailEvent {}

class FetchDetailRestaurant extends RestaurantDetailEvent{
  final String id;

  FetchDetailRestaurant({required this.id});

}
