//FirebaseMLApi text recognise
import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:intl/intl.dart';

class FirebaseMLApi {
  static Future<List<DateTime>> recogniseText(File imageFile) async {
    //check if there is a image or not
    if (imageFile == null) {
      return null;
    } else {
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer = FirebaseVision.instance.textRecognizer();
      try {
        final visionText = await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final dates = extractText(visionText);

        return dates;
      } catch (error) {
        return null;
      }
    }
  }

  static extractText(VisionText visionText) {
    String text = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = text + word.text + ' ';
        }
        text = text + '\n';
      }
    }
    return extractDates(text);
  }

  static extractDates(String readText) {
    RegExp regDate1 = RegExp(
        r"\d?\d[/?|\s?|.?]\d?\d[/?|\s?|.?]\d?\d?\d\d"); //matches n|nn/n|nn/nnnn|nn
    RegExp regDate2 =
        RegExp(r"\d\d?[/?|\s?|.?]\d?\d?\d\d"); //matches n|nn/nn|nnnn
    RegExp regDate3 = RegExp(
        r"\d?\d?\d?\d?[/?|\s?|.?][a-zA-Z][a-zA-Z][a-zA-Z][/?|\s?|.?]\d?\d?\d?\d?");
    List<Iterable<RegExpMatch>> matches = [
      regDate1.allMatches(readText),
      regDate2.allMatches(readText),
      regDate3.allMatches(readText)
    ];
    List<DateTime> possibleDates = [];

    List<String> possibleFormats;
    for (var iterable in matches) {
      for (var regMatch in iterable) {
        String match = regMatch.group(0);

        if (match.contains(r'[a-zA-Z]')) {
          possibleFormats = [
            'MMM yy',
            'MMM/yy',
            'MMM.yy',
            'MMM yyyy',
            'MMM.yyyy',
            'MMM/yyyy',
            'yy MMM ',
            'yy/MMM ',
            'yy.MMM ',
            'yyyy MMM ',
            'yyyy/MMM ',
            'yyyy.MMM ',
            'dd MMM yy',
            'dd/MMM/yy',
            'dd.MMM.yy',
            'dd MMM yyyy',
            'dd/MMM/yyyy',
            'dd.MMM.yyyy',
          ];
        } else {
          possibleFormats = [
            'dd MM yyyy',
            'dd/MM/yyyy',
            'dd.MM.yyyy',
            'd.M.yyyy',
            'dd.M.yyyy',
            'MM yyyy',
            'MM/yyyy',
            'MM.yyyy',
            'MM/yy',
            'MM.yy',
            'MM.yyyy',
            'yyyy MM dd',
            'yyyy/MM/dd',
            'yyyy.MM.dd',
            'yy MM dd',
            'yy/MM?dd',
            'yy.MM.dd',
            'yy MM',
            'yy/MM',
            'yy.MM',
          ];
        }
        for (var format in possibleFormats) {

          try {
            DateTime date = DateFormat(format).parse(match);
            if (date.isBefore(DateTime(2000))) {
              date = DateTime(date.year + 2000, date.month, date.day);
            }
            possibleDates.add(date);
          } catch (FormatException) {
            //print("$match was not a a valid date");          
            }
        }
      }
    }

    return possibleDates;

    //Iterable<RegExpMatch> matches = exp.allMatches(str);
  }
}
