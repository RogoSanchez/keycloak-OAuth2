class UserModel {
  final String id;
  final String username;
  final String? email;

  UserModel({required this.id, required this.username, this.email});

  static UserModel fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['sub'] as String? ?? '',
      email: map['email'] as String?,
      username:
          map['preferred_username'] as String? ?? map['name'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email)';
  }
}
