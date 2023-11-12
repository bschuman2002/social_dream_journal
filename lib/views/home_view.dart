import 'package:flutter/material.dart';
import 'package:social_dream_journal/views/create_journal_entry_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      const SizedBox(height: 50),
      _homeTitle(context),
      const SizedBox(height: 10),
      const Row(children: [
        Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Recent Entries', style: TextStyle(fontSize: 25)))
      ]),
      const SizedBox(height: 15),
      _buildJournalEntries(),
    ]));
  }

  Row _homeTitle(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text('Home',
              style: TextStyle(color: Colors.black, fontSize: 30))),
      Column(children: [
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
      ])
    ]);
  }

  Padding _buildJournalEntries() {
    return Padding(
        padding: const EdgeInsets.only(left: 25),
        child: Column(children: [
          _buildJournalEntry("Today", "Private",
              "I had a dream today about being chased through a busy city I"),
          const SizedBox(height: 10),
          _buildJournalEntry("Yesterday", "Public",
              "I had a lot of dreams last night, but I can't seem to remember"),
          const SizedBox(height: 10),
          _buildJournalEntry(
              "Sep. 27", "Private", "I didn't have any dreams last night.")
        ]));
  }

  Column _buildJournalEntry(String dateStr, String privacy, String text) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(dateStr,
            style: const TextStyle(
                color: Colors.black,
                decoration: TextDecoration.underline,
                fontSize: 35)),
        Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(privacy,
                style: const TextStyle(color: Colors.black, fontSize: 15)))
      ]),
      const SizedBox(height: 5),
      Row(children: [
        Flexible(
            child: Text(text,
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis)))
      ])
    ]);
  }
}
