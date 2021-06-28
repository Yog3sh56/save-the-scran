import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:save_the_scran/utils/DatabaseHandler.dart';
import 'package:save_the_scran/widgets/push_to_market.dart';

import '../constants.dart';

class AddItemScreen extends StatefulWidget {
  static const id = "add_item";

  AddItemScreen({Key key}) : super(key: key);

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  String itemName = "";

  DateTime _expiry = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
        centerTitle: true,

        // backgroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
            gradient: LinearGradient(
              colors: [Colors.greenAccent[200], Colors.greenAccent[200]],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),

        title:
            Text('Add Food to Fridge', style: TextStyle(color: Colors.black)),

        elevation: 4,
      ),
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            child: Column(
              children: [
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 50),
                    width: 250,
                    height: 200,
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                          colorFilter: new ColorFilter.mode(
                              Colors.white.withOpacity(0.4), BlendMode.dstATop),
                          image: AssetImage('images/orange.png'),
                          fit: BoxFit.contain),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  cursorColor: Color(0xFFc2075e),
                  decoration: inputDecoration.copyWith(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              BorderSide(color: Color(0xFFc2075e), width: .5)),
                      labelText: "Product Name"),
                  onChanged: (name) {
                    setState(() {
                      itemName = name;
                    });
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                    child: Text(_expiry.toString().split(" ")[0]),
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        )),
                        minimumSize: MaterialStateProperty.all(Size(
                            MediaQuery.of(context).size.width / 2,
                            MediaQuery.of(context).size.width / 6)),
                        backgroundColor: MaterialStateProperty.all(Color(0xFFc2075e)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ))),
                    onPressed: () {
                      DatePicker.showDatePicker(context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime: DateTime(2030, 6, 7),
                          theme: DatePickerTheme(
                              headerColor: Color(0xFFc2075e),
                              backgroundColor: Colors.greenAccent[200],
                              itemStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22),
                              doneStyle:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          onConfirm: (date) {
                        print('confirm $date');
                        setState(() {
                          _expiry = date;
                        });
                      },
                          currentTime: _expiry != null ? _expiry : DateTime.now(),
                          locale: LocaleType.en);
                    }),
                const SizedBox(height: 16),
                PushtoMarketWidget(
                  onClickedPushtoMarket: () => DbHandler.pushtoMarket(
                      FirebaseAuth.instance,
                      FirebaseFirestore.instance,
                      itemName,
                      null,
                      _expiry,
                      context),
                ),
              ],
            ),
        ),
      ),
    );
  }
}
