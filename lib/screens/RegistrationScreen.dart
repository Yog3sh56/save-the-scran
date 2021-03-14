import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:save_the_scran/constants.dart';
import 'package:save_the_scran/models/Item.dart';
import 'package:save_the_scran/screens/FridgeScreen.dart';
import 'package:save_the_scran/screens/LoginScreen.dart';



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
  String email,password,passwordRepeat,uid;

  void addMockItems(String uid){
    List<String> items = ["yoghurt","milk","bread","cheese","lasagna","pizza"];
    for (var i in items){
      Item item = Item(uid,i);
      _firestore.collection("items").add({"ownerid":uid,"name":i,"buyDate":item.buyDate,"expiryDate":item.expiry,"inCommunity":false});
    }
  }

  //build
  @override
  Widget build(BuildContext context) {
    return Scaffold(

       appBar: AppBar(
        
        backgroundColor: Color(0xFF00E676),
        title: Text("Community Market", style: TextStyle(color: Colors.white)),
      ),

      backgroundColor: Colors.white,
      body: SingleChildScrollView(
              child: Padding(
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
                decoration: inputDecoration.copyWith(hintText: "Repeat Password")
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
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                                email: email, password: password);
                        if (newUser != null) {
                          print("succesfull registration");
                          uid = _auth.currentUser.uid;

                          addMockItems(uid);

                          print(uid);
                          Navigator.popAndPushNamed(context, FridgeScreen.id);
                        }
                      } catch (e) {
                        print(e);
                      }
                      
                      Navigator.pop(context);
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
                      child:Text("Already have an account? Login",textAlign: TextAlign.center),
                      onTap: () {
                        Navigator.popAndPushNamed(context, LoginScreen.id);
                      }
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
