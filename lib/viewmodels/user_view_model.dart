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
