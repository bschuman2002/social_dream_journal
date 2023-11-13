class User {
  final int id;
  final String username;
  final String password;
  List<User> following;
  List<User> followers;

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.following,
      required this.followers});

  factory User.fromJson(Map<String, dynamic> json) {
    final List<dynamic> following = json['following'];
    final List<dynamic> followers = json['followers'];
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      following: following.cast<User>(),
      followers: followers.cast<User>()
    );
  }
}
