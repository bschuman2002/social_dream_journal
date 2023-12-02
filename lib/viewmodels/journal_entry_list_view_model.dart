import 'package:flutter/material.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:social_dream_journal/viewmodels/user_view_model.dart';
import 'package:social_dream_journal/models/user.dart';
import 'package:social_dream_journal/models/journal_entry.dart';



class JournalListProvider extends ChangeNotifier {
  UserViewModel? _userViewModel;
  List<JournalEntryViewModel> _userJournalViewModels = [];
  List<JournalEntryViewModel> _allEntries = [];
  List<JournalEntry> _entriesNotVM = [];

  UserViewModel get userViewModel => _userViewModel!;
  List<JournalEntryViewModel> get userJournalViewModels => _userJournalViewModels;
  List<JournalEntryViewModel> get allEntries => _allEntries;
  UserViewModel get currentUser => _userViewModel!;

  void initialize(User currentUser, List<JournalEntry> allEntries) {
    _userViewModel = UserViewModel(user: currentUser);
    _entriesNotVM = allEntries;
    allEntries.map((entry) => _allEntries.add(JournalEntryViewModel(journalEntry: entry))).toList();

    _userJournalViewModels = allEntries
        .where((entry) => entry.userId == currentUser.id)
        .map((entry) => JournalEntryViewModel(journalEntry: entry))
        .toList();


    // Notify listeners after initializing the view models
    notifyListeners();
  }

  void changeUser(UserViewModel newUser) {
    _userViewModel = newUser;

    _userJournalViewModels = _entriesNotVM
        .where((entry) => entry.userId == currentUser.id)
        .map((entry) => JournalEntryViewModel(journalEntry: entry))
        .toList();

    notifyListeners();
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