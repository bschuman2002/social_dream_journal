import 'package:flutter/cupertino.dart';
import 'package:social_dream_journal/models/journal_entry.dart';

class JournalEntryViewModel {
  final JournalEntry journalEntry;

  JournalEntryViewModel({required this.journalEntry});

  int get id {
    return journalEntry.id;
  }

  int get userId {
    return journalEntry.userId;
  }

  DateTime get date {
    return journalEntry.date;
  }

  bool get privacy {
    return journalEntry.privacy;
  }

  void set privacy(bool priv) {
    journalEntry.privacy = priv;
  }

  int get sleepScore {
    return journalEntry.sleepScore;
  }

  String get text {
    return journalEntry.text;
  }
}

