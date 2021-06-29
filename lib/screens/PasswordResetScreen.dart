import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PasswordResetScreen extends StatefulWidget {
  State<StatefulWidget> createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: Colors.greenAccent[200],
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Image.asset(
                "images/email-mail-sent.png",
                width: 100,
                height: 100,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(18)),
                  color: Colors.greenAccent[200]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Text(
              "Type your email below and we will send a reset link",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
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
                          borderSide:
                              BorderSide(color: Color(0xFFc2075e), width: .5)),
                      hintText: 'Enter your email')),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                color: Color(0xFFc2075e),
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () async {
                    if (email.isEmpty || !EmailValidator.validate(email)) {
                      showAlert("Please Enter a valid email.");
                    } else {
                      FirebaseAuth auth = FirebaseAuth.instance;
                      try {
                        await auth.sendPasswordResetEmail(email: email);
                        showAlert(
                            "A reset link has been sent to your email, you can now go back to login page.");
                      } on FirebaseAuthException catch (e) {
                        print(e.code);
                        if (e.code == "user-not-found") {
                          showAlert(
                              "There is no user record corresponding to provided email, please provide a valid email");
                        }
                      } catch (e) {
                        print(e);
                      }
                    }
                  },
                  textColor: Colors.white,
                  height: 42,
                  minWidth: MediaQuery.of(context).size.width,
                  child: Text(
                    "Send Link",
                    style: TextStyle(fontWeight: FontWeight.bold),
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
                  style: TextStyle(fontWeight: FontWeight.bold),
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
