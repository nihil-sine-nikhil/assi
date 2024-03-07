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
      UsersListResponse response = await firebaseServices.fetchUsersList();
      if (response.status) {
        emit(UserStateLoaded(response));
      } else {
        emit(UserStateError(response));
      }
    });
    on<UserEventUpdate>((event, emit) async {
      CustomResponse response =
          await firebaseServices.updateUserDetails(userModel: event.userModel);

      if (response.status) {
        emit(UserStateUpdateSuccesful(response));
      } else {
        emit(UserStateUpdateFailed(response));
      }
    });
    on<UserEventAddUser>((event, emit) async {
      CustomResponse response =
          await firebaseServices.addNewUser(userModel: event.userModel);

      if (response.status) {
        emit(UserStateUpdateSuccesful(response));
      } else {
        emit(UserStateUpdateFailed(response));
      }
    });
  }
}
