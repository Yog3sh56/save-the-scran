import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;
  final VoidCallback onClickedBar;

  const ControlsWidget({
    @required this.onClickedPickImage,
    @required this.onClickedScanText,
    @required this.onClickedBar,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      RaisedButton(
        color: Color(0xFFff79af),
        onPressed: onClickedPickImage,
        child:Text('Pick Image'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),


  ),
      const SizedBox(width: 12),
      RaisedButton(
        color: Color(0xFFff79af),
        onPressed: onClickedScanText,
        child: Text('Scan'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      const SizedBox(width: 12),
      RaisedButton(
        color: Color(0xFFff79af),
        onPressed: onClickedBar,
        child: Text('BarScan'),
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