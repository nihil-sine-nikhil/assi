part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class UserAboutYouSubmittedEvent extends UserEvent {
  final UserModel userModel;
  const UserAboutYouSubmittedEvent(
    this.userModel,
  );
  @override
  List<Object?> get props => [userModel];
}

class EditProfileSubmittedEvent extends UserEvent {
  final UserModel userModel;
  const EditProfileSubmittedEvent(
    this.userModel,
  );
  @override
  List<Object?> get props => [
        userModel,
      ];
}

class UserAboutYouChangedEvent extends UserEvent {
  final String name;
  const UserAboutYouChangedEvent(this.name);
  @override
  List<Object?> get props => [name];
}

class UpdateUserProfile extends UserEvent {
  final UserModel userProfile;

  const UpdateUserProfile(this.userProfile);

  @override
  List<Object> get props => [userProfile];
}

class LoadUserProfile extends UserEvent {
  const LoadUserProfile({this.userID});
  final String? userID;
  @override
  List<Object> get props => [];
}
