part of 'users_bloc.dart';

@immutable
abstract class UsersEvent {}

class UsersEventFetchAll extends UsersEvent {}

class UsersEventInit extends UsersEvent {}
