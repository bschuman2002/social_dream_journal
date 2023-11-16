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
    "text": "I found myself in the backyard of my childhood home, surrounded by "
        "lush greenery and the familiar sights of my youth. The air felt crisp, "
        "and there was a gentle breeze. As I walked towards the old oak tree, "
        "I noticed a peculiar door embedded in its trunk.",
    "sleepScore": 6,
    "privacy": "true"
  };

  Map<String, dynamic> jsonEntry2 = {
    "id": 2,
    "userID": 1,
    "date": "2023-11-11T08:00:00Z",
    "text": "In this dream, I found myself navigating through a bustling city"
        " that seemed both futuristic and slightly dystopian.",
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
        ChangeNotifierProvider<JournalListProvider>(create: (context) {
          JournalListProvider appProvider = JournalListProvider();

          appProvider.initialize(currentUser, allEntries);

          return appProvider;
        }),
        ChangeNotifierProvider<UserProvider>(create: (context) {
          UserProvider userProvider = UserProvider();

          userProvider.initialize(currentUser, allUsers);

          return userProvider;
        })
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          home: HomeView(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          )),
    );
  }
}
