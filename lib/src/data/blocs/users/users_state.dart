part of 'users_bloc.dart';

@immutable
abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersStateFetching extends UsersState {}

class UsersStateLoaded extends UsersState {}

class UsersStateError extends UsersState {}
