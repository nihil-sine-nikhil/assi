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
  File? profilePic;
  UserEventUpdate({required this.userModel, this.profilePic});

  @override
  List<Object> get props => [userModel];
}

class UserEventAddUser extends UserEvent {
  final UserModel userModel;
  File? profilePic;
  UserEventAddUser({required this.userModel, this.profilePic});

  @override
  List<Object> get props => [userModel];
}

class UserEventInit extends UserEvent {
  @override
  List<Object> get props => [];
}

class UserEventUpdateLoginAccess extends UserEvent {
  final List<String> documentIDs;
  final bool grantAccess;
  UserEventUpdateLoginAccess({
    required this.documentIDs,
    required this.grantAccess,
  });

  @override
  List<Object> get props => [documentIDs, grantAccess];
}
