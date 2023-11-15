import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/models/journal_entry.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_list_view_model.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:social_dream_journal/views/journal_entry_view.dart';

import '../widgets/navbar.dart';

class create_journal_entry_view extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _create_journal_entry_view();
  }
}

class _create_journal_entry_view extends State<create_journal_entry_view> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController _Textcontroller = TextEditingController();
  TextEditingController _sleepscore = TextEditingController();
  bool checkboxValue = false;

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
            ),
            _title(),
            _dateInput(context),
            _dreamDetails(),
            SizedBox(
              height: 10,
            ),
            _sleepScoreTitle(),
            _sleepScore(),
            _checkbox(),
            _submit(),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(pageIndex: 0),
    );
  }

  Padding _checkbox() {
    return Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 15),
            child: Row(
                children: [
              Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: checkboxValue,
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxValue = value!;
                    });
                  },
                ),
                Text(
                  checkboxValue
                      ? 'This Dream will be Public'
                      : 'This Dream will be Private',
                ),
              ],
            )
                ]
            ),
          );
  }

  Padding _sleepScoreTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text("Sleep Score", style: TextStyle(color: Colors.deepPurpleAccent))
        ],
      ),
    );
  }

  Padding _sleepScore() {
    return Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 60, bottom: 20),
        child: TextField(
          controller: _sleepscore,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter a number between 1 and 10',
          ),
        ));
  }

  ElevatedButton _submit() {
    return ElevatedButton(
      onPressed: () {
        JournalEntry newEntry = JournalEntry(
            id: Provider.of<JournalListProvider>(context, listen: false).allEntries.length + 1,
            userId: Provider.of<JournalListProvider>(context, listen: false).currentUser.id,
            date: DateTime.parse(dateInput.text),
            privacy: checkboxValue,
            sleepScore: int.parse(_sleepscore.text),
            text: _Textcontroller.text);
        Provider.of<JournalListProvider>(context, listen: false).addEntry(newEntry);
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => journal_entry_view(entry: JournalEntryViewModel(journalEntry: newEntry))),
          );
      },
      child: Text("Submit Dream"),
    );
  }

  Padding _dreamDetails() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        controller: _Textcontroller,
        minLines: 4,
        maxLines: 10,
        keyboardType: TextInputType.multiline,
        decoration: InputDecoration(
            hintText: "Enter your dream's details",
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            )),
      ),
    );
  }

  Container _dateInput(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(15),
        height: MediaQuery.of(context).size.width / 3,
        child: Center(
            child: TextField(
          controller: dateInput,
          //editing controller of this TextField
          decoration: InputDecoration(
              icon: Icon(Icons.calendar_today), //icon of text field
              labelText: "Enter Date" //label text of field
              ),
          readOnly: true,
          //set it true, so that user will not able to edit text
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2100));

            if (pickedDate != null) {
              print(
                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              print(
                  formattedDate); //formatted date output using intl package =>  2021-03-16
              setState(() {
                dateInput.text =
                    formattedDate; //set output date to TextField value.
              });
            } else {}
          },
        )));
  }

  Row _title() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Text("New Journal Entry",
              style: TextStyle(
                fontSize: 29,
                fontWeight: FontWeight.w600,
              )),
        )
      ],
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      // actions: [
      //   IconButton(
      //       onPressed: () {
      //         Navigator.pop(context);
      //       },
      //       icon: Icon(Icons.arrow_back))
      // ],
    );
  }
}


