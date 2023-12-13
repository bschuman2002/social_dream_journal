class User {
  final int id;
  final String username;
  final String password;
  List<int> following;
  List<int> followers;

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
      following: following.cast<int>(),
      followers: followers.cast<int>()
    );
  }
}
