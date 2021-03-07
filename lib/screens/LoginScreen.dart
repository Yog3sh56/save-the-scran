import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/constants.dart';

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
              decoration: inputDecoration.copyWith(hintText: "Password")
            ),
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
                      final user =
                          await _auth.signInWithEmailAndPassword(email: email, password: password);
                              
                      if (user != null) {
                        print("succesfull login");
                        Navigator.pop(context);
                                  
                                  



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
            child: new Text("Don't have an account? Register here"),
          )
          ],
        ),
      ),
    );
  }
}
