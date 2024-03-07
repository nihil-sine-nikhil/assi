import '../users_model.dart';

class UsersListResponse {
  final bool status;
  final String msg;
  final List<UserModel> usersList;
  UsersListResponse({
    required this.status,
    required this.msg,
    required this.usersList,
  });

  @override
  String toString() => 'Status: $status, Msg: $msg, Data: $usersList';
}
