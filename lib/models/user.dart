class User {
  final int id;
  final String username;
  final String password;
  final List<User> following;
  final List<User> followers;

  User(
      {required this.id,
      required this.username,
      required this.password,
      required this.following,
      required this.followers});
}
