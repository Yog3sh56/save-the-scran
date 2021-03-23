//Barcode recognize
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:save_the_scran/utils/OpenFoodApi.dart';

class FirebaseBarcodeApi {
  static Future<String> recogniseBar(File imageFile) async {
    //check if there is a image or not
    if (imageFile == null) {
      return 'No selected image';
    } else {
      FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(imageFile);
      BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
      try {
        final barCodes = await barcodeDetector.detectInImage(ourImage);
        if (barCodes.length==0)return "no barcode found";
        String rawBarcode = barCodes[0].rawValue;
        await barcodeDetector.close();
        //String barcode_text = JsonEncoder().convert(barCodes);

        //print("barcode text is $barcode_text");
        final foodname = await OpenFoodApi.getProduct(rawBarcode);
        return foodname;
        //final text = "Product name:"+foodname;

        //return text.isEmpty ? 'No text found in the image' : text;
      } catch (error) {
        return error.toString();
      }
    }
  }

}
