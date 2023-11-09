import 'package:flutter/material.dart';

class journal_entry_view extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
          children: [
            SizedBox(height: 40,),
            _journalTitleDate(),
            SizedBox(height: 5,),
            _username(),
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
                      'Entry is currently private',
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
                    'Sleep score: 6',
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
                    "While I believe I had some dreams last night, I couldn't"
                        " remember any of them upon waking up.  However, I "
                        "think I had a nightmare earlier in the night as I remember"
                        " waking up briefly in the middle of the night.",
                  style: TextStyle(
                    fontSize: 20
                  ),
                ),
              )
            ],
          );
  }

  Row _username() {
    return Row(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                      'bschuman02',
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
                'Journal Entry 9/25/2023',
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
