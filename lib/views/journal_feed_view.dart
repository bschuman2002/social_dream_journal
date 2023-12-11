import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_view_model.dart';
import 'package:social_dream_journal/widgets/navbar.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_list_view_model.dart';
import 'journal_entry_view.dart';
import 'package:table_calendar/table_calendar.dart';

class JournalFeedView extends StatelessWidget {
  const JournalFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.jpg'),
                  fit: BoxFit.cover)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _journalLogPageTitle(),
            const SizedBox(height: 20),
            const Expanded(child: ToggleView()),
          ])),
      bottomNavigationBar: const NavBar(pageIndex: 1),
    );
  }

  Row _journalLogPageTitle() {
    return Row(
      children: [
        Container(
            padding: const EdgeInsets.only(top: 60.0, left: 20.0, right: 16.0),
            child: const Text(
              'Journal Entry Log',
              style: TextStyle(color: Colors.white, fontSize: 30),
            ))
      ],
    );
  }
}

class ToggleView extends StatefulWidget {
  const ToggleView({super.key});

  @override
  State<ToggleView> createState() => _ToggleViewState();
}

class _ToggleViewState extends State<ToggleView> {
  final List<bool> _selectedIcon = <bool>[true, false];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(children: [
        Container(
            padding: const EdgeInsets.only(left: 20.0, right: 16.0),
            child: ToggleButtons(
              direction: Axis.horizontal,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.purple[600],
              selectedColor: Colors.white,
              fillColor: Colors.purple[200],
              color: Colors.purple[400],
              isSelected: _selectedIcon,
              children: const [
                Icon(Icons.list_alt_sharp, size: 65),
                Icon(Icons.calendar_month, size: 65)
              ],
              onPressed: (int index) {
                setState(() {
                  // The button that is tapped is set to true, and the others to false.
                  for (int i = 0; i < _selectedIcon.length; i++) {
                    _selectedIcon[i] = i == index;
                  }
                });
              },
            )),
      ]),
      _selectedIcon[0] ? const JournalListView() : const JournalCalendarView(),
    ]);
  }
}

class JournalListView extends StatelessWidget {
  const JournalListView({super.key});

  @override
  Widget build(BuildContext context) {
    List<JournalEntryViewModel> userEntries =
        Provider.of<JournalListProvider>(context).userJournalViewModels.toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return Expanded(child: _listOfEntries(userEntries));
  }
}

class JournalCalendarView extends StatefulWidget {
  const JournalCalendarView({super.key});

  @override
  State<JournalCalendarView> createState() => JournalCalendarViewState();
}

class JournalCalendarViewState extends State<JournalCalendarView> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  List<JournalEntryViewModel> _selectedEvents = [];

  @override
  Widget build(BuildContext context) {
    List<JournalEntryViewModel> userEntries =
        Provider.of<JournalListProvider>(context).userJournalViewModels.toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    return Expanded(
        child: Column(children: [
      TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: _focusedDay,
        headerStyle: const HeaderStyle(formatButtonVisible: false),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            _selectedEvents = _getEventsForDay(selectedDay, userEntries);
          });
        },
        eventLoader: (day) {
          return _getEventsForDay(day, userEntries);
        },
      ),
      Expanded(child: _listOfEntries(_selectedEvents))
    ]));
  }

  List<JournalEntryViewModel> _getEventsForDay(
      DateTime day, List<JournalEntryViewModel> userEntries) {
    return userEntries.where((entry) => isSameDay(entry.date, day)).toList();
  }
}

String formatJournalDate(DateTime date) {
  final now = DateTime.now();
  if (now.year == date.year && now.month == date.month && now.day == date.day) {
    return 'Today';
  } else if (now.subtract(const Duration(days: 1)).year == date.year &&
      now.subtract(const Duration(days: 1)).month == date.month &&
      now.subtract(const Duration(days: 1)).day == date.day) {
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

Padding _listOfEntries(List<JournalEntryViewModel> userEntries) {
  return Padding(
    padding: const EdgeInsets.only(top: 0),
    child: userEntries.isEmpty
        ? const Center(
            child: Text('No journal entries yet.'),
          )
        : buildListView(userEntries),
  );
}

ListView buildListView(List<JournalEntryViewModel> userEntries) {
  return ListView.builder(
    scrollDirection: Axis.vertical,
    itemCount: userEntries.length,
    itemBuilder: (context, index) {
      final journalEntry = userEntries[index];

      return ListTile(
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          journal_entry_view(entry: journalEntry)),
                );
              },
              child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(formatJournalDate(journalEntry.date),
                          style: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              fontSize: 25)),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(formatPrivacy(journalEntry.privacy),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 15)),
                      )
                    ],
                  )),
            ),

            const SizedBox(height: 4),
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Text(journalEntry.text,
                    style: const TextStyle(
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
