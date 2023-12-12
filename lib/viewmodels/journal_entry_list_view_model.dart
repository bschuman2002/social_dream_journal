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
  List<JournalEntryViewModel> currentUserFollowingList = [];

  UserViewModel get userViewModel => _userViewModel!;
  List<JournalEntryViewModel> get userJournalViewModels => _userJournalViewModels;
  List<JournalEntryViewModel> get allEntries => _allEntries;
  UserViewModel get currentUser => _userViewModel!;
  List<JournalEntryViewModel> get followingList => currentUserFollowingList;


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

    for(JournalEntryViewModel entry in _allEntries) {
      if(currentUser.following.contains(entry.userId) && entry.privacy == true) {
        currentUserFollowingList.add(entry);
      }
    }

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

  void logOut() {
    currentUserFollowingList = [];
  }

  List<JournalEntryViewModel> getUsersEntries(int id) {
    List<JournalEntryViewModel> entries = [];

    for(JournalEntryViewModel entry in _allEntries) {
      if(entry.userId == id && entry.privacy == true) {
        entries.add(entry);
      }
    }

    return entries;
  }

  void updateFollowingList(int UserID, bool? isFollowing) {
    if(isFollowing != null) {
    if (isFollowing) {
      for (JournalEntryViewModel entry in _allEntries) {
        if (entry.userId == UserID && entry.privacy == true) {
          followingList.add(entry);
        }
      }
    } else {
      for (JournalEntryViewModel entry in _allEntries) {
        if (entry.userId == UserID) {
          followingList.remove(entry);
        }
      }
    }
  }

    notifyListeners();
  }

  void UpdatePrivacy(JournalEntryViewModel entry, privacy) {
    entry.privacy = privacy;

    notifyListeners();
  }

}