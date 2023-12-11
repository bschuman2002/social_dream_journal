

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
  late bool _privacy;

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
    _privacy = false;
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: "create",
        child: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      'assets/images/background.jpg'
                  ),
                  fit: BoxFit.cover
              )
          ),
          child:Scaffold(
          backgroundColor: Colors.transparent,
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
                privacySwitch(),
                SizedBox(height: 10,),
                _submit(),
              ],
            ),
          ),
          bottomNavigationBar: const NavBar(pageIndex: 0),
        )));
  }

  Padding _checkbox() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 15),
      child: Row(children: [
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
      ]),
    );
  }

  Padding _sleepScoreTitle() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0),
      child: Row(
        children: [
          Text("Sleep Score", style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }

  Padding _sleepScore() {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 60, bottom: 20),
        child: TextField(
          style: TextStyle(color: Colors.white54),
          controller: _sleepscore,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Enter a number between 1 and 10',
            labelStyle: TextStyle(color: Colors.white),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 10),
            )
          ),
        ));
  }

  ElevatedButton _submit() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(143, 148, 251, 1)),
      onPressed: () {
        JournalEntry newEntry = JournalEntry(
            id: Provider.of<JournalListProvider>(context, listen: false)
                    .allEntries
                    .length +
                1,
            userId: Provider.of<JournalListProvider>(context, listen: false)
                .currentUser
                .id,
            date: DateTime.parse(dateInput.text),
            privacy: _privacy,
            sleepScore: int.parse(_sleepscore.text),
            text: _Textcontroller.text);
        Provider.of<JournalListProvider>(context, listen: false)
            .addEntry(newEntry);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => journal_entry_view(
                  entry: JournalEntryViewModel(journalEntry: newEntry))),
        );
      },
      child: Text("Create Dream Entry", style: TextStyle(color: Colors.white),)
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
            hintStyle: TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.white, width: 5)
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
              icon: Icon(Icons.calendar_today, color: Colors.white,), //icon of text field
              labelText: "Enter Date", //label text of field
              labelStyle: TextStyle(color: Colors.white)
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
          backgroundColor: Colors.transparent,
        );
  }

  Row privacySwitch() {
      return Row(children: [
        Padding(
          padding: const EdgeInsets.only(left:25.0,),
          child: Switch(
            value: _privacy,
            activeColor: Colors.blueAccent,
            onChanged: (bool value) {
              setState(() {
                _privacy = value;
              });
            },
          ),
        ),
        SizedBox(width: 5,),
        Text(
            'Entry will be ${_privacy ? "public" : "private"}',
            style: const TextStyle(
                fontSize: 16
            )
        ),
      ]
      );
    }
}


