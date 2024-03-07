class CustomResponse {
  final bool status;
  final String msg;
  CustomResponse({
    required this.status,
    required this.msg,
  });

  @override
  String toString() => 'Status: $status, Msg: $msg,  ';
}
