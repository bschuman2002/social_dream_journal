
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

  List<int> get following {
    return user.following;
  }

  List<int> get followers {
    return user.followers;
  }
}

class UserProvider extends ChangeNotifier {
  List<UserViewModel> _allUsers = [];
  UserViewModel? _currentUser;
  List<int> following = [];

  List<int> get followingList => following;

  void initialize(User currentUser, List<User> allUsers) {
    _currentUser = UserViewModel(user: currentUser);
    allUsers.map((user) => _allUsers.add(UserViewModel(user: user))).toList();

    notifyListeners();
  }

  void changeCurrentUser(UserViewModel newUser) {
    _currentUser = newUser;

    notifyListeners();
  }

  void addUser(String enteredUsername, String enteredPassword) {
    int maxId = 1;
    for(UserViewModel user in _allUsers) {
      if(maxId < user.id) {
        maxId = user.id;
      }
    }
    User newUser = User(id: maxId + 1, username: enteredUsername, password: enteredPassword, following: [], followers: []);

    _allUsers.add(UserViewModel(user: newUser));
    notifyListeners();
  }

  bool usernameExists(String enteredUsername) {
    for (UserViewModel user in _allUsers) {
      if (user.username == enteredUsername) {
        return true;
      }
    }
    return false;
  }

  bool? followingUser(int id) {
    return _currentUser?.following.contains(id);
  }

  void handleFollowUnfollow(int userID) {
      if(_currentUser?.following.contains(userID) == true) {
          followingList.remove(userID);
      } else {
          followingList.add(userID);
      }

      notifyListeners();
  }

  String getUsernameById(int userId) {
    // Find the user with the given ID and return the username
    UserViewModel? user = _allUsers.firstWhere((user) => user.id == userId, orElse: () => UserViewModel(user: User(id: 0, username: 'error', password: "error", following: [], followers: [])) );
    return user?.username ?? 'Unknown'; // Return 'Unknown' if the user is not found
  }

  UserViewModel? checkCredentialsLogin(String enteredUsername, String enteredPassword) {
    for (UserViewModel user in _allUsers) {
      if (user.username == enteredUsername && user.password == enteredPassword) {
        // Credentials match
        changeCurrentUser(user);
        return user;
      }
    }
    // No matching user found
    return null;
  }

}
