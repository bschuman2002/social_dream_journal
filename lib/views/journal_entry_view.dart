import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:social_dream_journal/viewmodels/user_view_model.dart';

import '../models/journal_entry.dart';
import '../viewmodels/journal_entry_list_view_model.dart';
import '../widgets/navbar.dart';

class journal_entry_view extends StatelessWidget {
  JournalEntryViewModel entry;

  journal_entry_view({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: buildAppBar(context),
          body: SingleChildScrollView(
              child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              _journalTitleDate(),
              SizedBox(
                height: 5,
              ),
              _username(context),
              SizedBox(
                height: 40,
              ),
              _entryText(),
              SizedBox(
                height: 40,
              ),
              _sleepScore(),
              SizedBox(
                height: 100,
              ),
              PrivacySwitch(privacy: entry.privacy, entry: entry),
            ],
          )),
          bottomNavigationBar: const NavBar(pageIndex: 0),
        ));
  }

  Column _shareEntry() {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: Text(
                  'Entry is currently ${entry.privacy ? "public" : "private"}',
                  style: TextStyle(fontSize: 16)),
            )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 40,
          width: 340,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(143, 148, 251, 1),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              //Logic for sharing entry
              //Should be just changing the variable
            },
            child: const Text('Share Entry with Friends',
                style: TextStyle(fontSize: 25)),
          ),
        )
      ],
    );
  }

  Row _sleepScore() {
    return Row(
      children: [
        Padding(
            padding: const EdgeInsets.only(left: 40.0),
            child: Text('Sleep score: ${entry.sleepScore}',
                style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationColor: Colors.white,
                    fontSize: 20)))
      ],
    );
  }

  Column _entryText() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40.0, right: 5.0),
          child: Text(
            '${entry.text}',
            style: TextStyle(fontSize: 20),
          ),
        )
      ],
    );
  }

  Row _username(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40.0),
          child: Text(
              Provider.of<UserProvider>(context).getUsernameById(entry.userId),
              style: TextStyle(
                  color: Colors.grey,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.grey,
                  fontSize: 16)),
        )
      ],
    );
  }

  Center _journalTitleDate() {
    return Center(
      child: Text(
          'Journal Entry ${DateFormat('MM/dd/yyyy').format(entry.date)}',
          style: TextStyle(fontSize: 29, fontWeight: FontWeight.w600)),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
    );
  }

  BottomAppBar buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.blue, // Customize the color as needed.
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(
                  context); // Navigate back when the back button is pressed.
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Add entry logic goes here.
            },
          ),
        ],
      ),
    );
  }
}

class PrivacySwitch extends StatefulWidget {
  bool privacy;
  JournalEntryViewModel entry;

  PrivacySwitch({super.key, required this.privacy, required this.entry});

  @override
  State<PrivacySwitch> createState() => _PrivacySwitchState();
}

class _PrivacySwitchState extends State<PrivacySwitch> {
  late bool privacy;

  @override
  void initState() {
    super.initState();
    privacy = widget.privacy;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Padding(
        padding: const EdgeInsets.only(left: 40.0),
        child: Text('Entry is currently ${privacy ? "public" : "private"}',
            style: const TextStyle(fontSize: 16)),
      ),
      Switch(
        // This bool value toggles the switch.
        value: privacy,
        activeColor: Colors.blueAccent,
        onChanged: (bool value) {
          // This is called when the user toggles the switch.
          Provider.of<JournalListProvider>(context, listen: false)
              .UpdatePrivacy(widget.entry, value);
          setState(() {
            privacy = value;
          });
        },
      )
    ]);
  }
}
