class UserModel {
  String? name;
  String? uid;
  dynamic phone;
  dynamic userNumber;
  dynamic createdAt;

  UserModel({
    this.name,
    this.uid,
    this.phone,
    this.userNumber,
    this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      uid: map['uid'] ?? '',
      phone: map['phone'] ?? '',
      userNumber: map['userNumber'] ?? '',
      createdAt: map['createdAt'] ?? '',
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'phone': phone,
      'userNumber': userNumber,
      'createdAt': createdAt,
    };
  }

  UserModel copyWith({
    String? name,
    String? uid,
    dynamic phone,
    dynamic userNumber,
    dynamic createdAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      uid: uid ?? this.uid,
      phone: phone ?? this.phone,
      userNumber: userNumber ?? this.userNumber,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
