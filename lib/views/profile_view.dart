import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_list_view_model.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';

import '../viewmodels/journal_entry_view_model.dart';
import '../viewmodels/user_view_model.dart';
import '../widgets/navbar.dart';

class ProfileView extends StatefulWidget {
  final int userId;
  bool isFollowingUser;

  ProfileView({required this.userId, required this.isFollowingUser});

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.isFollowingUser;
  }

  @override
  Widget build(BuildContext context) {
    List<JournalEntryViewModel> usersEntries =
        Provider.of<JournalListProvider>(context)
            .getUsersEntries(widget.userId)..sort((a, b) => b.date.compareTo(a.date));
    return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(backgroundColor: Colors.transparent,),
          body: Column(children: [
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: usernameTitle(context),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: _listOfEntries(
                usersEntries,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(35.0), child: _followButton(context))
          ]),
          bottomNavigationBar: NavBar(
            pageIndex: 3,
          ),
        ));
  }

  GestureDetector _followButton(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Provider.of<UserProvider>(context, listen: false)
              .handleFollowUnfollow(widget.userId);
          Provider.of<JournalListProvider>(context, listen: false)
              .updateFollowingList(widget.userId, !isFollowing);
          setState(() {
            isFollowing = !isFollowing;
          });
        },
        child: Container(
          height: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(143, 148, 251, 1),
                Color.fromRGBO(143, 148, 251, .6),
              ])),
          child: Center(
            child: Text(
              isFollowing ? "Unfollow User" : "Follow User",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }

  Text usernameTitle(BuildContext context) {
    return Text(
      "${Provider.of<UserProvider>(context).getUsernameById(widget.userId)}"
      "'s Public Profile",
      style: TextStyle(fontSize: 30),
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
              GestureDetector(
                onTap: () {

                },
                child: Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "Journal Entry ${formatJournalDate(journalEntry.date)}",
                            style: const TextStyle(
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white,
                                fontSize: 25)),
                      ],
                    )),
              ),

              SizedBox(height: 4),
              Column(children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Text('${journalEntry.text}',
                      style: TextStyle(
                        color: Colors.white,
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
      return DateFormat('M/d/y').format(date);
    }
  }
}
