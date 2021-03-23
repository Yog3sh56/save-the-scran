import 'dart:io';
import 'package:camera/camera.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:save_the_scran/constants.dart';
import 'package:save_the_scran/screens/widget/push_to_market.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_the_scran/utils/FirebaseBarcodeApi.dart';
import 'package:save_the_scran/utils/FirebaseMLApi.dart';

import 'control.dart';

class TextRecognitionWidget extends StatefulWidget {
  final carryoverImage;
  const TextRecognitionWidget({
    Key key,
    this.carryoverImage,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() =>
      _TextRecognitionWidgetState(carryoverImage);
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  
  String itemName = "";
  File carryoverImage;
  File image;
  DateTime _expiry = DateTime.now();

  _TextRecognitionWidgetState(carryoverImage){
    print(carryoverImage);
    this.carryoverImage = File(carryoverImage.path);
  }
final _controller = TextEditingController();

  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }
  
  void dispose() {
    _controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    //scanText();
    //scanBarcode();
    return Expanded(
        child: Column(
          children: [
            Expanded(child: buildImage()),
            const SizedBox(height: 16),
            ControlsWidget(
              onClickedPickImage: pickImage,
              onClickedScanText: scanText,
              onClickedBar: scanBarcode,
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 16),
            TextField(
              decoration: inputDecoration.copyWith(helperText: "item name"),
              controller: _controller,
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
                  }, currentTime: _expiry!=null ?_expiry:DateTime.now(), locale: LocaleType.en);
                }),
            PushtoMarketWidget(
              onClickedPushtoMarket: pushtoMarket,
            ),
          ],
        ),
      );
  }

  Widget buildImage(){
    
    scanText();
    scanBarcode(); 

    return Container(
        child: image != null
            ? Image.file(image)
            : carryoverImage == null
                ? Icon(Icons.photo_size_select_actual,
                    size: 160, color: Colors.blue[300])
                : Image.file(File(carryoverImage.path)),
      );
  }

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
    if (dates.length == 0)return;
    final expiry = dates?.elementAt(0);
    setDate(expiry);
  }
    Future scanBarcode() async {
      /*
    showDialog(
      context: context,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
    */
    final text = await FirebaseBarcodeApi.recogniseBar(image);
    print("text from barcode is: $text");
    setText(text);
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

  void setImage(File newImage) {
    setState(() {
      image = newImage;
    });
  }

  void setText(String newText) {
    setState(() {
      _controller.text = newText;
      itemName = newText;
    });
  }

  void setDate(DateTime expiry) {
    setState(() {
      _expiry = expiry;
    });
  }
}
