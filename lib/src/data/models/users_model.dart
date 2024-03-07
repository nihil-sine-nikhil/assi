class UserModel {
  String? documentID;
  final String lastName;
  final String firstName;
  final String email;
  final String phone;
  final String team;
  final bool canLogin;
  final String role;
  final String profilePic;
  dynamic createdOn;
  dynamic updatedOn;
  UserModel({
    this.documentID,
    required this.lastName,
    required this.firstName,
    required this.canLogin,
    required this.role,
    required this.email,
    required this.phone,
    required this.team,
    this.updatedOn,
    required this.profilePic,
    this.createdOn,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      lastName: map['lastName'],
      canLogin: map['canLogin'],
      firstName: map['firstName'],
      profilePic: map['profilePic'],
      role: map['role'],
      email: map['email'],
      phone: map['phone'],
      team: map['team'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'lastName': lastName,
      'firstName': firstName,
      'canLogin': canLogin,
      'profilePic': profilePic,
      'role': role,
      'email': email,
      'team': team,
      'phone': phone,
    };
  }
}
