import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  DatabaseBloc() : super(DatabaseInitial()) {
    on<DatabaseEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
