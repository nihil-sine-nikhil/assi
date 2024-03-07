import 'package:assignment/src/domain/repos.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../models/firestore_response_models/users_list_response_model.dart';
import '../../models/users_model.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  List<UserModel> users = <UserModel>[];
  bool init = false;
  UsersBloc() : super(UsersInitial()) {
    on<UsersEvent>((event, emit) async {
      if (event is UsersEventInit) {
        if (!init) {
          init = true;
          add(UsersEventFetchAll());
        }
      }
      if (event is UsersEventFetchAll) {
        emit(UsersStateFetching());
        UsersListResponse response = await firebaseServices.fetchUsersList();
        if (response.status) {
          users = response.usersList;

          emit(UsersStateLoaded());
        } else {
          emit(UsersStateError());
        }
      }
    });
  }
}
