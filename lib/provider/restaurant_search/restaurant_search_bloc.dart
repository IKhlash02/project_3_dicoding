import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'restaurant_search_event.dart';
part 'restaurant_search_state.dart';

class RestaurantSearchBloc extends Bloc<RestaurantSearchEvent, RestaurantSearchState> {
  RestaurantSearchBloc() : super(RestaurantSearchInitial()) {
    on<RestaurantSearchEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
