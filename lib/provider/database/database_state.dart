part of 'database_bloc.dart';

@immutable
sealed class DatabaseState {}

final class DatabaseInitial extends DatabaseState {}
