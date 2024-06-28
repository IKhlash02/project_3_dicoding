import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'scheduling_event.dart';
part 'scheduling_state.dart';

class SchedulingBloc extends Bloc<SchedulingEvent, SchedulingState> {
  SchedulingBloc() : super(SchedulingInitial()) {
    on<SchedulingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
