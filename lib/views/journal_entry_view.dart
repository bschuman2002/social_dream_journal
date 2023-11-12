import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';

import '../models/journal_entry.dart';
import '../viewmodels/journal_entry_list_view_model.dart';

class journal_entry_view extends StatelessWidget {
  JournalEntryViewModel entry;

  journal_entry_view({required this.entry});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
          children: [
            SizedBox(height: 40,),
            _journalTitleDate(),
            SizedBox(height: 5,),
            _username(context),
            SizedBox(height: 40,),
            _entryText(),
            SizedBox(height: 40,),
            _sleepScore(),
            SizedBox(height: 150,),
            _shareEntry()
          ],
        ),
      bottomNavigationBar: buildBottomAppBar(context),
    );
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
                      style: TextStyle(
                        fontSize: 16
                      )
                    ),
                  )
                ],
              ),
              SizedBox(height: 5,),
              SizedBox(
                height: 40,
                width:340,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),

                  onPressed: () {
                    //Logic for sharing entry
                    //Should be just changing the variable
                  },
                  child: const Text(
                      'Share Entry with Friends',
                      style: TextStyle(
                        fontSize: 25
                      )
                  ),
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
                child:
                  Text(
                    'Sleep score: ${entry.sleepScore}',
                    style: TextStyle(
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      fontSize: 20
                    )
                  )
              )
            ],
          );
  }

  Column _entryText() {
    return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40.0, right:  5.0),
                child: Text(
                    '${entry.text}',
                  style: TextStyle(
                    fontSize: 20
                  ),
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
                      Provider.of<JournalListProvider>(context).getUsernameById(entry.userId),
                      style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.underline,
                          fontSize: 16
                      )
                  ),
              )
            ],
          );
  }

  Center _journalTitleDate() {
    return Center (
            child:
            Text(
                'Journal Entry ${DateFormat('MM/dd/yyyy').format(entry.date)}',
                style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w600
                )
            ),
          );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      actions: [
        IconButton(onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back))
      ],
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
              Navigator.pop(context); // Navigate back when the back button is pressed.
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
