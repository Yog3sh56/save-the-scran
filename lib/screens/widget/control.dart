import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;
  final VoidCallback onClickedClear;
  final VoidCallback onClickedBar;

  const ControlsWidget({
    @required this.onClickedPickImage,
    @required this.onClickedScanText,
    @required this.onClickedClear,
    @required this.onClickedBar,
    Key key,
  }) : super(key: key);

  @override
  // Widget build(BuildContext context) => Row(
  Widget build(BuildContext context){
    return Wrap(
        spacing:10,
        runSpacing:30,
        alignment: WrapAlignment.center,
        runAlignment:WrapAlignment.center,
        crossAxisAlignment:WrapCrossAlignment.center,
        verticalDirection:VerticalDirection.down,



    children: [
      RaisedButton(
        color: Color(0xFF82B1FF),
        onPressed: onClickedPickImage,
        child:Text('Pick Image'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),


  ),
      const SizedBox(width: 12,),
      RaisedButton(
        color: Color(0xFF82B1FF),
        onPressed: onClickedScanText,
        child: Text('DateScan'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

      ),
      const SizedBox(width: 12),
      RaisedButton(
        color: Color(0xFF82B1FF),
        onPressed: onClickedBar,
        child: Text('BarScan'),
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
      // RaisedButton(
      // onPressed: onClickedClear,
      // child: Text('Pull to Market'),
      // )

    ],
    );
}
}