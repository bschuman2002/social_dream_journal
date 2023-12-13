import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/models/user.dart';
import 'package:social_dream_journal/viewmodels/journal_entry_list_view_model.dart';
import 'package:social_dream_journal/viewmodels/user_view_model.dart';
import 'package:social_dream_journal/views/profile_view.dart';
import 'package:social_dream_journal/widgets/navbar.dart';

class searchView extends StatefulWidget {
  List<UserViewModel> allUsers;

  searchView({required this.allUsers});

  @override
  State<searchView> createState() => _SearchViewState(display_list: allUsers);
}

class _SearchViewState extends State<searchView> {
  late List<UserViewModel> display_list;

  _SearchViewState({required this.display_list});

  @override
  void initState() {
    super.initState();
    display_list = List.from(widget.allUsers);
  }

  void updateList(String value, BuildContext context) {
    setState(() {
      display_list = Provider.of<UserProvider>(context, listen: false)
          .allUsers
          .where((element) =>
              element.username!.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    display_list.remove(
        Provider.of<JournalListProvider>(context, listen: false).currentUser);
    return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Search For a User",
                    style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                SizedBox(height: 20.0),
                TextField(
                  onChanged: (value) => updateList(value, context),
                  style: TextStyle(),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white54,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: "Username",
                    prefixIcon: Icon(Icons.search),
                    prefixIconColor: Colors.purple.shade900,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount:
                            display_list.length > 4 ? 5 : display_list.length,
                        itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileView(
                                          userId: display_list[index].id,
                                          isFollowingUser:
                                              Provider.of<UserProvider>(context)
                                                      .followingUser(
                                                          display_list[index]
                                                              .id) ==
                                                  true)),
                                );
                              },
                              title: Text(
                                display_list[index].username,
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(Provider.of<UserProvider>(context)
                                      .followingList
                                      .contains(display_list[index].id)
                                  ? "Following"
                                  : ""),
                            )))
              ],
            ),
          ),
          bottomNavigationBar: NavBar(
            pageIndex: 3,
          ),
        ));
  }
}
