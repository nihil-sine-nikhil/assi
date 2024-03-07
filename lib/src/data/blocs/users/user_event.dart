part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserEventFetchAll extends UserEvent {
  @override
  List<Object> get props => [];
}

class UserEventUpdate extends UserEvent {
  final UserModel userModel;
  const UserEventUpdate({required this.userModel});

  @override
  List<Object> get props => [userModel];
}

class UserEventAddUser extends UserEvent {
  final UserModel userModel;
  const UserEventAddUser({required this.userModel});

  @override
  List<Object> get props => [userModel];
}

class UserEventInit extends UserEvent {
  @override
  List<Object> get props => [];
}
