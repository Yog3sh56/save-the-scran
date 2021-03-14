import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:save_the_scran/screens/TakePictureScreen.dart';
import 'package:save_the_scran/screens/widget/text_area.dart';
import 'package:save_the_scran/screens/widget/push_to_market.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../TakePictureScreen.dart';
import 'control.dart';

class TextRecognitionWidget extends StatefulWidget {
  const TextRecognitionWidget({
    Key key,
  }) : super(key: key);

  @override
  _TextRecognitionWidgetState createState() => _TextRecognitionWidgetState();
}

class _TextRecognitionWidgetState extends State<TextRecognitionWidget> {
  String text = '';
  File image;

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
        TextAreaWidget(
          text: text,
          onClickedCopy: copyToClipboard,
        ),
        const SizedBox(height: 16),
        PushtoMarketWidget(
          onClickedPushtoMarket: pushtoMarket,
        ),
      ],
    ),
  );

  Widget buildImage() => Container(
    child: image != null
        ? Image.file(image)
        : Icon(Icons.photo_size_select_actual, size: 160, color: Colors.blue[300]),
  );

  Future pickImage() async {
    final file = await ImagePicker().getImage(source: ImageSource.gallery);
    //final file = await ImagePicker().getImage(source: ImageSource.camera);
    setImage(File(file.path));
  }

  Future scanText() async {
    showDialog(
      context: context,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );

    final text = await FirebaseMLApi.recogniseText(image);
    setText(text);

    Navigator.of(context).pop();
  }


  //conect with Leon's Market
  Future pushtoMarket() async {

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
}