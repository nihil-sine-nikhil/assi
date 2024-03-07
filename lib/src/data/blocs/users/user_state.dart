part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UserInitial extends UserState {
  @override
  List<Object> get props => [];
}

class UserStateFetching extends UserState {
  @override
  List<Object> get props => [];
}

class UserStateLoading extends UserState {
  @override
  List<Object> get props => [];
}

class UserStateLoaded extends UserState {
  const UserStateLoaded(this.usersListResponse);

  final UsersListResponse usersListResponse;
  @override
  List<Object> get props => [usersListResponse];
}

class UserStateUpdateSuccesful extends UserState {
  const UserStateUpdateSuccesful(this.customResponse);

  final CustomResponse customResponse;
  @override
  List<Object> get props => [customResponse];
}

class UserStateUpdateFailed extends UserState {
  const UserStateUpdateFailed(this.customResponse);

  final CustomResponse customResponse;
  @override
  List<Object> get props => [customResponse];
}

class UserStateError extends UserState {
  const UserStateError(this.usersListResponse);
  final UsersListResponse usersListResponse;

  @override
  List<Object> get props => [usersListResponse];
}
