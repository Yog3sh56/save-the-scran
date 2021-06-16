import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:save_the_scran/constants.dart';
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

  //variables to store
  String email, password, passwordRepeat, uid;

  //build
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.grey.withOpacity(0.3),
          backgroundColor: Colors.greenAccent[200],
          // title: Text("Register", style: TextStyle(color: Colors.black)),
          elevation: 0,
        ),
        backgroundColor: Colors.greenAccent[200],
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(25, 30, 25, 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Image.asset('images/heartLogo.png'),
              ),
              SizedBox(
                height: 30.0,
              ),
              TextField(
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                decoration: inputDecoration.copyWith(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide:
                          BorderSide(color: Color(0xFFc2075e), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Color(0xFFc2075e), width: .5)),
                    fillColor: Colors.white.withOpacity(0.5),
                    filled: true,
                    hintText: 'Enter your email',
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.person,
                    )),
              ),
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
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Color(0xFFc2075e), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Color(0xFFc2075e), width: .5)),
                      fillColor: Colors.white.withOpacity(0.5),
                      filled: true,
                      hintText: "Password",
                      prefixIcon: Icon(Icons.lock))),
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
                  decoration: inputDecoration.copyWith(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            BorderSide(color: Color(0xFFc2075e), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Color(0xFFc2075e), width: .5)),
                      fillColor: Colors.white.withOpacity(0.5),
                      filled: true,
                      hintText: "Repeat Password",
                      prefixIcon: Icon(Icons.lock))),
              SizedBox(
                height: 5.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Color(0xFFc2075e),
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
                            Navigator.popUntil(
                                context, (route) => route.isFirst);
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
              SizedBox(height: MediaQuery.of(context).size.height *0.08,),
              Column(
                children: [
                  Text(
                    "Sign up with your Socials",
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(20)),
                            color: Colors.white),
                        height: 40,
                        width: 40,
                        child: IconButton(
                            onPressed: () async {
                              // function to allow sign in with google credentials


                              // Trigger the authentication flow
                              final GoogleSignInAccount googleUser =
                              await GoogleSignIn().signIn();

                              // Obtain the auth details from the request
                              final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;

                              // Create a new credential
                              final credential =
                              GoogleAuthProvider.credential(
                                accessToken: googleAuth.accessToken,
                                idToken: googleAuth.idToken,
                              );
                              final user = FirebaseAuth.instance
                                  .signInWithCredential(credential);


                              if (user != null) {
                                print("succesfull login");

                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }
                            },
                            icon: SvgPicture.asset(
                              "assets/icons/Google.svg",
                              width: 30,
                              height: 30,
                            )),
                      ),
                      IconButton(
                          onPressed: () async {


                            // Trigger the sign-in flow
                            final AccessToken result =
                            await FacebookAuth.instance.login();

                            // Create a credential from the access token
                            final facebookAuthCredential =
                            FacebookAuthProvider.credential(result.token);
                            try{
                              // Once signed in, return the UserCredential
                              final user = await FirebaseAuth.instance
                                  .signInWithCredential(facebookAuthCredential);

                              if (user != null) {
                                print("succesfull login");

                                Navigator.popUntil(
                                    context, (route) => route.isFirst);
                              }}
                            on FirebaseAuthException catch (e){
                              if (e.code == "account-exists-with-different-credential"){
                                showAlert("Account already exists with different credentials, please use email or Google sign in.");
                              }
                            }

                          }
                          ,
                          icon: SvgPicture.asset("assets/icons/Facebook.svg",
                              width: 30,
                              height: 30,
                              color: Color(0xff4267B2))),
                    ],
                  ),

                ],
              ),
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
