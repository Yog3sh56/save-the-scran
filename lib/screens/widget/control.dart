import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;
  final VoidCallback onClickedClear;

  const ControlsWidget({
    @required this.onClickedPickImage,
    @required this.onClickedScanText,
    @required this.onClickedClear,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RaisedButton(
        color: Color(0xFF82B1FF),
        onPressed: onClickedPickImage,
        child:Text('Pick Image'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),


  ),
      const SizedBox(width: 12),
      RaisedButton(
        color: Color(0xFF82B1FF),
        onPressed: onClickedScanText,
        child: Text('Scan'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      const SizedBox(width: 12),
      RaisedButton(
        color: Color(0xFF82B1FF),
        onPressed: onClickedClear,
        child: Text('Clear'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      const SizedBox(width: 12),
      // RaisedButton(
      // onPressed: onClickedClear,
      // child: Text('Pull to Market'),
      // )

    ],
  );
}