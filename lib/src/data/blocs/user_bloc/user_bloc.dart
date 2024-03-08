import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../display/users_model.dart';
import '../../services/auth_services.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late final AuthenticationServices _authServices;

  UserBloc({required AuthenticationServices authServices})
      : _authServices = authServices,
        super(UserInitial()) {
    on<UserAboutYouChangedEvent>((event, emit) {
      if (event.name.isEmpty) {
        emit(UserAboutYouInvalidState());
      } else {
        emit(UserAboutYouValidState());
      }
    });

    on<UpdateUserProfile>((event, emit) {
      emit(UserProfileLoaded(event.userProfile));
    });
  }
}
