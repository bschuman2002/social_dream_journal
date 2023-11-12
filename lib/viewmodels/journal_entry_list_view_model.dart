import 'package:flutter/material.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:social_dream_journal/viewmodels/user_view_model.dart';
import 'package:social_dream_journal/models/user.dart';
import 'package:social_dream_journal/models/journal_entry.dart';



class AppProvider extends ChangeNotifier {
  UserViewModel? _userViewModel;
  List<JournalEntryViewModel> _userJournalViewModels = [];

  UserViewModel get userViewModel => _userViewModel!;
  List<JournalEntryViewModel> get userJournalViewModels => _userJournalViewModels;

  void initialize(User currentUser, List<JournalEntry> allEntries) {
    _userViewModel = UserViewModel(user: currentUser);

    _userJournalViewModels = allEntries
        .where((entry) => entry.userId == currentUser.id)
        .map((entry) => JournalEntryViewModel(journalEntry: entry))
        .toList();


    // Notify listeners after initializing the view models
    notifyListeners();
  }
}