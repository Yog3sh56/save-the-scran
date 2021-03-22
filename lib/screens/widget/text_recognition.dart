import 'dart:io';

import 'package:camera/camera.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:save_the_scran/constants.dart';
import 'package:save_the_scran/screens/widget/text_area.dart';
import 'package:save_the_scran/screens/widget/push_to_market.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_the_scran/utils/FirebaseMLApi.dart';

import 'control.dart';

class TextRecognitionWidget extends StatefulWidget {
  final result;
  const TextRecognitionWidget({
    Key key,
    this.result,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() =>
      _TextRecognitionWidgetState(result);
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String text = '';
  String itemName = "";
  XFile result;
  File image;
  DateTime _expiry = DateTime.now();

  _TextRecognitionWidgetState(this.result);

  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Expanded(child: buildImage()),
            const SizedBox(height: 16),
            ControlsWidget(
              onClickedPickImage: pickImage,
              onClickedScanText: scanText,
              onClickedClear: clear,
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            TextField(
              decoration: inputDecoration.copyWith(helperText: "item name"),
              onChanged: (value) {
                itemName = value;
              },
            ),
            ElevatedButton(
                child: Text(_expiry.toString().split(" ")[0]),
                onPressed: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(),
                      maxTime: DateTime(2030, 6, 7),
                      theme: DatePickerTheme(
                          headerColor: Colors.orange,
                          backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          doneStyle:
                              TextStyle(color: Colors.white, fontSize: 16)),
                      onConfirm: (date) {
                    print('confirm $date');
                    setState(() {
                      _expiry = date;
                    });
                  }, currentTime: DateTime.now(), locale: LocaleType.fr);
                }),
            PushtoMarketWidget(
              onClickedPushtoMarket: pushtoMarket,
            ),
          ],
        ),
      );

  Widget buildImage() => Container(
        child: image != null
            ? Image.file(image)
            : result != null
                ? Icon(Icons.photo_size_select_actual,
                    size: 160, color: Colors.blue[300])
                : Image.file(File(result.path)),
      );

  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    //final file = await ImagePicker().getImage(source: ImageSource.camera);
    setImage(File(file.path));
  }

  Future scanText() async {
    /*showDialog(
      context: context,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
    */

    final dates = await FirebaseMLApi.recogniseText(image);
    final expiry = dates?.elementAt(0);
    setDate(expiry);

    //Navigator.of(context).pop();
  }

  //conect with Leon's Market
  void pushtoMarket() async {
    if (_auth.currentUser == null) return;
    if (itemName.isEmpty) return;

    _firestore.collection("items").add({
      "ownerid": _auth.currentUser.uid,
      "name": itemName,
      "buyDate": DateTime.now(),
      "expiryDate": _expiry,
      "inCommunity": false
    });
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void clear() {
    setImage(null);
    setText('');
  }

  void copyToClipboard() {
    if (text.trim() != '') {
      FlutterClipboard.copy(text);
    }
  }

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }

  void setText(String newText) {
    setState(() {
      text = newText;
    });
  }

  void setDate(DateTime expiry) {
    setState(() {
      _expiry = expiry;
    });
  }
}
