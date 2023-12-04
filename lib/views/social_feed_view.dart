import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_list_view_model.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:social_dream_journal/viewmodels/user_view_model.dart';
import 'package:social_dream_journal/views/profile_view.dart';
import 'package:social_dream_journal/views/search_view.dart';

import '../widgets/navbar.dart';

class SocialFeed extends StatelessWidget {
  const SocialFeed({super.key});


  String formatJournalDate(DateTime date) {
    final now = DateTime.now();
    if (now.year == date.year &&
        now.month == date.month &&
        now.day == date.day) {
      return 'Today';
    } else if (now
        .subtract(Duration(days: 1))
        .year == date.year &&
        now
            .subtract(Duration(days: 1))
            .month == date.month &&
        now
            .subtract(Duration(days: 1))
            .day == date.day) {
      return 'Yesterday';
    } else {
      return DateFormat('MMMM d, yyyy').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
      List<JournalEntryViewModel> followingList = Provider.of<JournalListProvider>(context)
          .followingList
          .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: _FloatingActionButton(context),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _titleBar(),
            SizedBox(height: 30,),
            Expanded(
              child: _listOfEntries(followingList,),
            ),

        ],

        ),
        bottomNavigationBar: NavBar(pageIndex: 3,),
      );
  }

  FloatingActionButton _FloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color.fromRGBO(143, 148, 251, 1),
      heroTag: "search",
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => searchView()),
        );
      },
      child: Icon(Icons.search, size: 36, color: Colors.white,),
      hoverElevation: 50,
    );
  }


  Row _titleBar() {
    return Row(
              children:[
                _FeedTitle(),
              ]
          );
  }

  Container _FeedTitle() {
    return Container(
          padding: EdgeInsets.only(top: 60.0, left: 20.0, right: 16.0),
          child: Text(
            'Feed',
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

  ListView buildListView(List<JournalEntryViewModel> followingList) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: followingList.length < 4 ? followingList.length : 4,
      itemBuilder: (context, index) {
        final journalEntry = followingList[index];

        return ListTile(
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      profileView(userId: journalEntry.userId)
                  ),
                );
              },
                child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(Provider.of<UserProvider>(context).getUsernameById(journalEntry.userId),
                            style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontSize: 25)),
                        Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(formatJournalDate(journalEntry.date),
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