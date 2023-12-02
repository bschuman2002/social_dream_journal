import 'package:flutter/cupertino.dart';
import 'package:social_dream_journal/models/user.dart';

class UserViewModel {
  final User user;

  UserViewModel({required this.user});

  int get id {
    return user.id;
  }

  String get username {
    return user.username;
  }

  String get password {
    return user.password;
  }

  List<User> get following {
    return user.following;
  }

  List<User> get followers {
    return user.followers;
  }
}

class UserProvider extends ChangeNotifier {
  List<UserViewModel> _allUsers = [];
  UserViewModel? _currentUser;

  void initialize(User currentUser, List<User> allUsers) {
    _currentUser = UserViewModel(user: currentUser);
    allUsers.map((user) => _allUsers.add(UserViewModel(user: user))).toList();

    notifyListeners();
  }

  void changeCurrentUser(User newUser) {
    _currentUser = UserViewModel(user: newUser);

    notifyListeners();
  }

  String getUsernameById(int userId) {
    // Find the user with the given ID and return the username
    UserViewModel? user = _allUsers.firstWhere((user) => user.id == userId, orElse: () => UserViewModel(user: User(id: 0, username: 'error', password: "error", following: [], followers: [])) );
    return user?.username ?? 'Unknown'; // Return 'Unknown' if the user is not found
  }
}
