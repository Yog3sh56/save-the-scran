import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:save_the_scran/constants.dart';
import 'package:save_the_scran/widgets/push_to_market.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:save_the_scran/utils/FirebaseBarcodeApi.dart';
import 'package:save_the_scran/utils/FirebaseMLApi.dart';

import '../widgets/control.dart';

class TextRecognitionWidget extends StatefulWidget {
  final carryoverImage;
  const TextRecognitionWidget({
    Key key,
    this.carryoverImage,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() =>
      _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  
  String itemName = "";
  File image;
  DateTime _expiry = DateTime.now();
  bool textHasBeenScanned=false;
  bool barcodeHasBeenScanned=false;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final String text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length,extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Column(
          children: [
            Expanded(child: buildImage()),
            const SizedBox(height: 16),
            TextField(
              cursorColor: Color(0xFFc2075e),
              decoration: inputDecoration.copyWith(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                    BorderSide(color: Color(0xFFc2075e), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                          color: Color(0xFFc2075e), width: .5)),
                  labelText:"Product Name"
              ),
              controller: _controller,
              onChanged: (name) {
                setState((){
                  _controller.text = name;
                });
              },    
              
            ),

            const SizedBox(height: 16),
            
            
            ElevatedButton(
                child: Text(_expiry.toString().split(" ")[0]),
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
                            ControlsWidget(
              onClickedPickImage: pickImage,
              onClickedScanText: scanText,
              onClickedBar: scanBarcode,
            ),
            PushtoMarketWidget(
              onClickedPushtoMarket: pushtoMarket,
            ),
          ],
        ),
      );
  }

  Widget buildImage(){
    
    if (!textHasBeenScanned)scanText();
    if (!barcodeHasBeenScanned)scanBarcode(); 


    
    return Container(
        child: image != null
            ? Image.file(image)
            : widget.carryoverImage == null
                ? Icon(Icons.photo_size_select_actual,
                    size: 160, color: Colors.blue[300])
                : Image.file(File(widget.carryoverImage.path)),
      );
  }

  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    setImage(File(file.path));
  }

  Future scanText() async {
    /*
    showDialog(
      context: context,
      builder: (context)=> CircularProgressIndicator(),
    );
    */
    textHasBeenScanned =true;
    final dates = await FirebaseMLApi.recogniseText(widget.carryoverImage==null?image:File(widget.carryoverImage.path));
    if (dates!=null && dates?.length != 0){
      
      final expiry = dates?.elementAt(0);
      setDate(expiry);

    }
  }
    Future scanBarcode() async {
    barcodeHasBeenScanned=true;
    final text = await FirebaseBarcodeApi.recogniseBar(widget.carryoverImage==null?image:File(widget.carryoverImage.path));
    setText(text);
  }

  //conect with Leon's Market
  void pushtoMarket() async {
    if (_auth.currentUser == null) return;
    if (itemName.isEmpty) return;

    _firestore.collection("items").add({
      "ownerid": _auth.currentUser.uid,
      "name": itemName.isEmpty?"no name":itemName,
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
