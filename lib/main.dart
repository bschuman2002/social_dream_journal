import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/models/journal_entry.dart';
import 'package:social_dream_journal/viewmodels/user_view_model.dart';
import 'package:social_dream_journal/views/home_view.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_list_view_model.dart';
import 'package:social_dream_journal/models/user.dart';
import 'package:social_dream_journal/views/login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Example User
  User defaultUser = User(
      id: 1,
      username: "johnDoe1",
      password: "123",
      following: [],
      followers: []);
  List<User> allUsers = [];
  allUsers.add(defaultUser);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  User defaultUser = User(
      id: 1,
      username: "johnDoe1",
      password: "123",
      following: [],
      followers: []);

  MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
        // Replace the Future with your logic to load the JSON file
        future: Future.wait([loadEntryData(), loadUserData()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              // Handle error case
              return Center(child: Text('Error loading data'));
            }

            // Handle the loaded data
            List<Map<String, dynamic>>? entriesJson =
                snapshot.data?[0] as List<Map<String, dynamic>>?;

            List<Map<String, dynamic>>? usersJson =
                snapshot.data?[1] as List<Map<String, dynamic>>?;

            if (entriesJson != null && usersJson != null) {
              List<JournalEntry> entries = entriesJson
                  .map((entry) => JournalEntry.fromJson(entry))
                  .toList();

              List<User> allUsers = usersJson
                .map((user) => User.fromJson(user))
                .toList();

              return MultiProvider(
                providers: [
                  ChangeNotifierProvider<JournalListProvider>(
                    create: (context) {
                      JournalListProvider appProvider = JournalListProvider();
                      appProvider.initialize(
                          defaultUser, entries); // Use the loaded entries
                      return appProvider;
                    },
                  ),
                  ChangeNotifierProvider<UserProvider>(
                    create: (context) {
                      UserProvider userProvider = UserProvider();
                      userProvider.initialize(defaultUser, allUsers);
                      return userProvider;
                    },
                  ),
                ],
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: LoginView(),
                  theme: ThemeData(
                    colorScheme:
                        ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                    useMaterial3: true,
                  ),
                ),
              );
            } else {
              // Handle the case where data is null or empty
              return Center(child: Text('No data available'));
            }
          } else {
            // Show a loading indicator
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>?> loadEntryData() async {
    try {
      // Load the content of the JSON file from the 'assets' folder
      String jsonData =
          await rootBundle.loadString("assets/data/journal_entries.json");

      // Parse the JSON data
      List<Map<String, dynamic>> entries =
          jsonDecode(jsonData).cast<Map<String, dynamic>>();
      ;
      return entries;
    } catch (e) {
      print('Error loading JSON data: $e');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>?> loadUserData() async {
    try {
      String userData =
      await rootBundle.loadString("assets/data/users.json");

      List<Map<String, dynamic>> users =
          jsonDecode(userData).cast<Map<String, dynamic>>();
      return users;
    } catch (e) {
      print('Error loading JSON data: $e');
      return null;
    }
  }
}
