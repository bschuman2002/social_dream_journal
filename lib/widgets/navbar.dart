import 'package:flutter/material.dart';

NavigationBar buildNavBar() {
  return NavigationBar(destinations: const <Widget>[
    NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
    NavigationDestination(
        icon: Icon(Icons.edit_square), label: "Journal Entries"),
    NavigationDestination(icon: Icon(Icons.trending_up), label: "Trends"),
    NavigationDestination(icon: Icon(Icons.group), label: "Social")
  ]);
}
