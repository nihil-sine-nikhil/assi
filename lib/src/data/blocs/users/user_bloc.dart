import 'dart:io';

import 'package:assignment/src/data/models/firestore_response_models/generic_response_model.dart';
import 'package:assignment/src/domain/repos.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/firestore_response_models/users_list_response_model.dart';
import '../../models/users_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEventFetchAll>((event, emit) async {
      emit(UserStateLoading());
      UsersListResponse response = await firebaseServices.fetchUsersList();
      if (response.status) {
        emit(UserStateLoaded(response));
      } else {
        emit(UserStateError(response));
      }
    });
    on<UserEventUpdate>((event, emit) async {
      emit(UserStateLoading());
      CustomResponse response = await firebaseServices.updateUserDetails(
          userModel: event.userModel, profilePic: event.profilePic);

      if (response.status) {
        serverRepo.sendFCMNotification(
            title: 'User details updated',
            message:
                " ${event.userModel.firstName}'s details is updated successfully.");
        emit(UserStateUpdateSuccesful(response));
      } else {
        emit(UserStateUpdateFailed(response));
      }
    });
    on<UserEventAddUser>((event, emit) async {
      emit(UserStateLoading());

      CustomResponse response = await firebaseServices.addNewUser(
          userModel: event.userModel, profilePic: event.profilePic);

      if (response.status) {
        serverRepo.sendFCMNotification(
            title: 'New User Added',
            message:
                '${event.userModel.firstName} is added to your user list.');
        emit(UserStateUpdateSuccesful(response));
      } else {
        emit(UserStateUpdateFailed(response));
      }
    });
    on<UserEventUpdateLoginAccess>((event, emit) async {
      emit(UserStateLoading());

      CustomResponse response = await firebaseServices.disableUsersLoginAccess(
          documentIds: event.documentIDs, grantAccess: event.grantAccess);

      if (response.status) {
        emit(UserStateUpdateSuccesful(response));
      } else {
        emit(UserStateUpdateFailed(response));
      }
    });
  }
}
