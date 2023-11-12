import 'package:flutter/material.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:social_dream_journal/viewmodels/user_view_model.dart';
import 'package:social_dream_journal/models/user.dart';
import 'package:social_dream_journal/models/journal_entry.dart';



class JournalListProvider extends ChangeNotifier {
  UserViewModel? _userViewModel;
  List<JournalEntryViewModel> _userJournalViewModels = [];
  List<UserViewModel> _allUsers = [];
  List<JournalEntryViewModel> _allEntries = [];

  UserViewModel get userViewModel => _userViewModel!;
  List<JournalEntryViewModel> get userJournalViewModels => _userJournalViewModels;
  List<JournalEntryViewModel> get allEntries => _allEntries;
  UserViewModel get currentUser => _userViewModel!;

  void initialize(User currentUser, List<JournalEntry> allEntries, List<User> allUsers) {
    _userViewModel = UserViewModel(user: currentUser);

    allUsers.map((user) => _allUsers.add(UserViewModel(user: user))).toList();
    allEntries.map((entry) => _allEntries.add(JournalEntryViewModel(journalEntry: entry))).toList();

    _userJournalViewModels = allEntries
        .where((entry) => entry.userId == currentUser.id)
        .map((entry) => JournalEntryViewModel(journalEntry: entry))
        .toList();


    // Notify listeners after initializing the view models
    notifyListeners();
  }

  String getUsernameById(int userId) {
    // Find the user with the given ID and return the username
    UserViewModel? user = _allUsers.firstWhere((user) => user.id == userId, orElse: () => UserViewModel(user: User(id: 0, username: 'error', password: "error", following: [], followers: [])) );
    return user?.username ?? 'Unknown'; // Return 'Unknown' if the user is not found
  }

   void addEntry(JournalEntry newEntry) {
    JournalEntryViewModel newEntryViewModel = JournalEntryViewModel(journalEntry: newEntry);
    _allEntries.add(newEntryViewModel);

    if (newEntry.userId == currentUser.id) {
      _userJournalViewModels.add(newEntryViewModel);
    }

    // Notify listeners after adding the entry
    notifyListeners();
  }
}