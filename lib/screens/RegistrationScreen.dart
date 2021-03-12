import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/constants.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/FridgeScreen.dart';
import 'package:email_validator/email_validator.dart';

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

  void addMockItems(String uid) {
    List<String> items = [
      "yoghurt",
      "milk",
      "bread",
      "cheese",
      "lasagna",
      "pizza"
    ];
    for (var i in items) {
      Item item = Item(uid, i);
      _firestore.collection("items").add({
        "ownerid": uid,
        "name": i,
        "buyDate": item.buyDate,
        "expiryDate": item.expiry
      });
    }
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                    //removed registration as to not create too many users during testin
                    try {
                      if (email.isEmpty || !EmailValidator.validate(email)) {
                        showAlert("Please type in valid email");
                      } else if (password.isEmpty) {
                        showAlert("Please enter valid password");
                      } else if (passwordRepeat.isEmpty) {
                        showAlert("Please type your password again to confirm");
                      } else if (password != passwordRepeat) {
                        showAlert("The passwords do not match.");
                      } else {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);

                        if (newUser != null) {
                          print("succesfull registration");
                          uid = _auth.currentUser.uid;

                          //create fridge for user
                          print(uid);
                          Navigator.popAndPushNamed(context, FridgeScreen.id);
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
          ],
        ),
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
