import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/constants.dart';
import 'package:email_validator/email_validator.dart';

import 'package:save_the_scran/screens/RegistrationScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email, password;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent[200],
          // title: Text("Login", style: TextStyle(color: Colors.black)),
          elevation: 0,
        ),
        backgroundColor: Colors.greenAccent[200],
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(25, 50, 25, 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 200.0,
                  child: Image.asset('images/heartLogo.png'),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextField(
                    style: TextStyle(color: Colors.black),
                    cursorColor: Color(0xFFFF4081),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: inputDecoration.copyWith(
                        fillColor: Colors.white.withOpacity(0.5),
                        filled: true,
                        prefixIcon: Icon(Icons.person),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Color(0xFFc2075e), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Color(0xFFc2075e), width: .5)),
                        hintText: 'Enter your email')),
                SizedBox(
                  height: 8.0,
                ),
                TextField(
                    style: TextStyle(color: Colors.black),
                    obscureText: true,
                    textAlign: TextAlign.center,
                    obscuringCharacter: "*",
                    onChanged: (value) {
                      password = value;
                    },
                    decoration: inputDecoration.copyWith(
                        fillColor: Colors.white.withOpacity(0.5),
                        filled: true,
                        prefixIcon: Icon(Icons.lock),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Color(0xFFc2075e), width: 2.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: Color(0xFFc2075e), width: .5)),
                        hintText: "Password")),
                SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Material(
                    color: Color(0xFFFF4081),
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    elevation: 5.0,
                    child: MaterialButton(
                      onPressed: () async {
                        try {
                          if (email.isEmpty ||
                              !EmailValidator.validate(email)) {
                            showAlert("Please type in valid email");
                          } else {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);

                            if (user != null) {
                              print("succesfull login");
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                            }
                          }
                        } on FirebaseAuthException catch (e) {
                          switch (e.code) {
                            case "user-not-found":
                              {
                                showAlert(
                                    "No account exists associated with provided email.");
                              }
                              break;
                            case "wrong-password":
                              {
                                showAlert("Password Invalid. Try again.");
                              }
                              break;
                          }
                        } catch (e) {
                          print(e);
                        }
                      },
                      minWidth: 200.0,
                      height: 42.0,
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                new GestureDetector(
                  onTap: () {
                    Navigator.popAndPushNamed(context, RegistrationScreen.id);
                  },
                  child: Text("Don't have an account? Register here",
                      textAlign: TextAlign.center),
                )
              ]),
        ),
      );

  void showAlert(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              content: Container(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                ),
              ),
              elevation: 24.0,
              actions: <Widget>[
                new TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .pop(); // dismisses only the dialog and returns nothing
                  },
                  child: new Text('OK'),
                ),
              ]);
        });
  }
}
