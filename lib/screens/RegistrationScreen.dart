import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/constants.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:email_validator/email_validator.dart';
import 'LoginScreen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //firebase instances
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  //variables to store
  String email, password, passwordRepeat, uid;

  //build
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey.withOpacity(0.3),
          title: Text("Register", style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.white,
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
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration:
                      inputDecoration.copyWith(hintText: 'Enter your email')),
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
                  decoration: inputDecoration.copyWith(hintText: "Password")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  textAlign: TextAlign.center,
                  obscuringCharacter: "*",
                  onChanged: (value) {
                    passwordRepeat = value;
                  },
                  decoration:
                      inputDecoration.copyWith(hintText: "Repeat Password")),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      //removed registration as to not create too many users during testin
                      try {
                        if (email.isEmpty || !EmailValidator.validate(email)) {
                          showAlert("Please type in valid email");
                        } else if (password.isEmpty) {
                          showAlert("Please enter valid password");
                        } else if (passwordRepeat.isEmpty) {
                          showAlert(
                              "Please type your password again to confirm");
                        } else if (password != passwordRepeat) {
                          showAlert("The passwords do not match.");
                        } else {
                          final newUser =
                              await _auth.createUserWithEmailAndPassword(
                                  email: email, password: password);
                          if (newUser != null) {
                                Navigator.popUntil(context, (route) => route.isFirst);
                          }
                        }
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case "email-already-in-use":
                            {
                              showAlert(
                                  "Provided email is associated with different account. Try different email");
                            }
                            break;
                          case "weak-password":
                            {
                              showAlert(
                                  "The password has to be atleast 6 characters. Try different password");
                            }

                          // addMockItems(uid);

                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  child: Text("Already have an account? Login",
                      textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.popAndPushNamed(context, LoginScreen.id);
                  }),
            ],
          ),
        ),
      );

  void showAlert(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              contentPadding: EdgeInsets.all(15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(32))),
              content: Text(
                message,
                textAlign: TextAlign.center,
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
