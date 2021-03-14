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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF00E676),
        title: Text("Community Market", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Colors.white,
<<<<<<< HEAD
      body: SingleChildScrollView(
              child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
=======
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
>>>>>>> 75ab9ae4f65b99dfe3a442344d302c9ad92bf40b
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
<<<<<<< HEAD
              style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration:
                    inputDecoration.copyWith(hintText: 'Enter your email')),
=======
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      inputDecoration.copyWith(hintText: 'Enter your email')),
>>>>>>> 75ab9ae4f65b99dfe3a442344d302c9ad92bf40b
              SizedBox(
                height: 8.0,
              ),
              TextField(
<<<<<<< HEAD
                style: TextStyle(color: Colors.black),
                obscureText: true,
                textAlign: TextAlign.center,
                obscuringCharacter: "*",
                onChanged: (value) {
                  password = value;
                },
                decoration: inputDecoration.copyWith(hintText: "Password")
              ),

              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        final user =
                            await _auth.signInWithEmailAndPassword(email: email, password: password);
                                
                        if (user != null) {
                          print("succesfull login");
                          Navigator.pop(context);
=======
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  obscuringCharacter: "*",
                  onChanged: (value) {
                    password = value;
                  },
                  decoration: inputDecoration.copyWith(hintText: "Password")),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        if (email.isEmpty || !EmailValidator.validate(email)) {
                          showAlert("Please type in valid email");
                        } else {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: email, password: password);

                          if (user != null) {
                            print("succesfull login");
                            Navigator.pop(context);
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
>>>>>>> 75ab9ae4f65b99dfe3a442344d302c9ad92bf40b
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
<<<<<<< HEAD
                child:Text("Don't have an account? Register here",textAlign: TextAlign.center),
            )
            ],
          ),
        ),
=======
                child: Text("Don't have an account? Register here",
                    textAlign: TextAlign.center),
              )
            ]),
>>>>>>> 75ab9ae4f65b99dfe3a442344d302c9ad92bf40b
      ),
    );
  }

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
                new FlatButton(
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
