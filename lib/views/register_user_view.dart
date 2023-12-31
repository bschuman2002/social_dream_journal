import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:social_dream_journal/views/home_view.dart';

import '../viewmodels/user_view_model.dart';

class CreateAccount extends StatefulWidget {

  @override
  State<CreateAccount> createState() => _CreateAccount();
}

class _CreateAccount extends State<CreateAccount> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  late bool _usernameExistsError;
  late bool _passwordsMatchError;

  @override
  void initState() {
    _usernameExistsError = false;
    _passwordsMatchError = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeInUp(
                            duration: Duration(seconds: 1),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1200),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 20,
                        top: 40,
                        width: 100,
                        height: 150,
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1300),
                            child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/moon.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeInUp(
                            duration: Duration(milliseconds: 1600),
                            child: Container(
                              margin: EdgeInsets.only(
                                top: 110,
                              ),
                              child: Center(
                                child: Text(
                                  "Create Account",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        _usernameExistsError ? "Username is already in use." : "",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        _passwordsMatchError ? "Password and Confirm Password must match" : "",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  143, 148, 251, 1)))),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    controller: username,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Username",
                                        hintStyle:
                                        TextStyle(color: Colors.grey[700])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: Color.fromRGBO(
                                                  143, 148, 251, 1)))),
                                  child: TextField(
                                    style: TextStyle(color: Colors.black),
                                    controller: password,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                        TextStyle(color: Colors.grey[700])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: TextStyle(color: Colors.black),
                                    onChanged: (value) {
                                      if(!passwordsMatch()) {
                                        setState(() {
                                          _passwordsMatchError = true;
                                        });
                                      } else {
                                        setState(() {
                                          _passwordsMatchError = false;
                                        });
                                      }
                                    },
                                    controller: confirmPassword,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Confirm Password",
                                        hintStyle:
                                        TextStyle(color: Colors.grey[700])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1900),
                          child: GestureDetector(
                              onTap: () {
                                if (Provider.of<UserProvider>(context,
                                    listen: false)
                                    .usernameExists(username.text)) {
                                  setState(() {
                                    _usernameExistsError = true;
                                  });
                                } else if (!passwordsMatch()) {

                                } else {
                                  Provider.of<UserProvider>(context, listen:false)
                                      .addUser(
                                    username.text, password.text
                                  );
                                  Navigator.pop(context);
                                }
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ])),
                                child: Center(
                                  child: Text(
                                    "Create Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ))),
                      SizedBox(
                        height: 70,
                      ),
                      FadeInUp(
                          duration: Duration(milliseconds: 1900),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: LinearGradient(colors: [
                                      Color.fromRGBO(143, 148, 251, 1),
                                      Color.fromRGBO(143, 148, 251, .6),
                                    ])),
                                child: Center(
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )))
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  bool passwordsMatch() {
    if(password.text == confirmPassword.text) {
      return true;
    }
    return false;
  }
}
