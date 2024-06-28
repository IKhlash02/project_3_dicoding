import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'restaurant_detail_event.dart';
part 'restaurant_detail_state.dart';

class RestaurantDetailBloc extends Bloc<RestaurantDetailEvent, RestaurantDetailState> {
  RestaurantDetailBloc() : super(RestaurantDetailInitial()) {
    on<RestaurantDetailEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
