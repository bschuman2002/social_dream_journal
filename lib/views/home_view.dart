import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/models/journal_entry.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:social_dream_journal/views/create_journal_entry_view.dart';
import 'package:social_dream_journal/widgets/navbar.dart';
import '../viewmodels/journal_entry_list_view_model.dart';
import 'journal_entry_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  String formatJournalDate(DateTime date) {
    final now = DateTime.now();
    if (now.year == date.year &&
        now.month == date.month &&
        now.day == date.day) {
      return 'Today';
    } else if (now.subtract(Duration(days: 1)).year == date.year &&
        now.subtract(Duration(days: 1)).month == date.month &&
        now.subtract(Duration(days: 1)).day == date.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  String formatPrivacy(bool privacy) {
    if (privacy) {
      return 'Public';
    } else {
      return 'Private';
    }
  }

  @override
  Widget build(BuildContext context) {
    List<JournalEntryViewModel> userEntries =
        Provider.of<JournalListProvider>(context).userJournalViewModels
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return Scaffold(
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _homeAndAdd(context),
      SizedBox(height: 30),
      _subtitle(),
      Expanded(
        child: _listOfEntries(userEntries,),
      ),
    ]),
    bottomNavigationBar: const NavBar(pageIndex: 0));
  }

  Row _homeAndAdd(BuildContext context) {
    return Row(children: [
      _homeTitleList(),
      Padding(
          padding: EdgeInsets.only(left: 190.0, top: 60.0),
          child: Column(children: [
            Padding(
                padding: EdgeInsets.only(right: 20),
                child: IconButton(
                  icon: Icon(Icons.add_circle_outline, size: 36),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => create_journal_entry_view()),
                    );
                  },
                )),
            Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text("New Entry", style: TextStyle(fontSize: 20)))
          ]))
    ]);
  }

  Row _subtitle() {
    return Row(
      children: [
        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Recent Entries', style: TextStyle(fontSize: 25)))
      ],
    );
  }

  Container _homeTitleList() {
    return Container(
      padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 16.0),
      child: Text(
        'Home',
        style: TextStyle(color: Colors.black, fontSize: 30),
      ),
    );
  }

  Padding _listOfEntries(List<JournalEntryViewModel> userEntries) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: userEntries.isEmpty
          ? Center(
              child: Text('No journal entries yet.'),
            )
          : buildListView(userEntries),
    );
  }

  ListView buildListView(List<JournalEntryViewModel> userEntries) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: 4,
      itemBuilder: (context, index) {
        final journalEntry = userEntries[index];

        return ListTile(
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => 
                      journal_entry_view(entry: journalEntry)
                  ),
                );
              },
              child: Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatJournalDate(journalEntry.date),
                          style: const TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontSize: 25)),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Text(formatPrivacy(journalEntry.privacy),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15)),
                      )
                    ],
                  )),
              ),

              SizedBox(height: 4),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text('${journalEntry.text}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      )),
                )
              ])
              // Add other details you want to display
            ],
          ),
        );
      },
    );
  }
}
