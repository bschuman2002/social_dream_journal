import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/models/journal_entry.dart';
import 'package:social_dream_journal/viewmodels/user_view_model.dart';
import 'package:social_dream_journal/views/home_view.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_list_view_model.dart';
import 'package:social_dream_journal/models/user.dart';

void main() {
  //Example journal data
  Map<String, dynamic> jsonEntry = {
    "id": 1,
    "userID": 1,
    "date": "2023-11-12T08:00:00Z",
    "text": "Last night, I dreamt that I was flying over a magical landscape",
    "sleepScore": 6,
    "privacy": "true"
  };

  Map<String, dynamic> jsonEntry2 = {
    "id": 2,
    "userID": 1,
    "date": "2023-11-11T08:00:00Z",
    "text": "Last night, I had a very weird dream",
    "sleepScore": 7,
    "privacy": "false"
  };

  JournalEntry journalEntry = JournalEntry.fromJson(jsonEntry);
  JournalEntry journalEntry2 = JournalEntry.fromJson(jsonEntry2);

  List<JournalEntry> journalEntries = [];
  journalEntries.add(journalEntry);
  journalEntries.add(journalEntry2);

  //Example User
  User currUser = User(
      id: 1,
      username: "johnDoe1",
      password: "123",
      following: [],
      followers: []);
  List<User> allUsers = [];
  allUsers.add(currUser);
  runApp(MyApp(
      currentUser: currUser, allEntries: journalEntries, allUsers: allUsers));
}

class MyApp extends StatelessWidget {
  final User currentUser;
  final List<JournalEntry> allEntries;
  final List<User> allUsers;

  MyApp(
      {required this.currentUser,
      required this.allEntries,
      required this.allUsers});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<JournalListProvider>(create: (context) {
          JournalListProvider appProvider = JournalListProvider();

          appProvider.initialize(currentUser, allEntries);

          return appProvider;
        }),
        Provider<UserProvider>(create: (context) {
          UserProvider userProvider = UserProvider();

          userProvider.initialize(allUsers);

          return userProvider;
        })
      ],
      child: MaterialApp(
          home: HomeView(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          )),
    );
  }
}
