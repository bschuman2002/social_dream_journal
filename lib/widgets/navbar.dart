import 'package:flutter/material.dart';
import 'package:social_dream_journal/views/graph_view.dart';
import 'package:social_dream_journal/views/home_view.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key, required this.pageIndex});

  final int pageIndex;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentPageIndex = 0;
  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomeView(),
      const HomeView(), // Change this to journal
      const GraphView(), // Change this to trends
      const HomeView() // Change this to social
    ];
    return NavigationBar(
      destinations: const <Widget>[
        NavigationDestination(icon: Icon(Icons.home_outlined, color: Colors.white,), label: 'Home'),
        NavigationDestination(
            icon: Icon(Icons.edit_square), label: "Journal Entries"),
        NavigationDestination(icon: Icon(Icons.trending_up), label: "Trends"),
        NavigationDestination(icon: Icon(Icons.group), label: "Social")
      ],
      onDestinationSelected: (int index) {
        setState(() {
          currentPageIndex = index;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (_) => pages[currentPageIndex]));
        });
      },
      selectedIndex: currentPageIndex,
    );
  }
}
