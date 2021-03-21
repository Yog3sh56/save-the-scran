import 'package:flutter/material.dart';

class TextAreaWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClickedCopy;

  const TextAreaWidget({
    @required this.text,
    @required this.onClickedCopy,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Container(
              // color: Colors.blue,
              height: 100,
              width: 5,
              decoration: BoxDecoration(
                  //border: Border.all(),
                  borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  color: Colors.blue[100],
                  border: new Border.all(color: Colors.blue[400], width: 3)),
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.only(left: 45, right: 5, top: 10, bottom: 10),
              alignment: Alignment.center,
              child: SelectableText(
                text.isEmpty ? 'Scan an Image to get Information' : text,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 0),
          IconButton(
            icon: Icon(Icons.copy_rounded, color: Colors.blue[500]),
            color: Colors.grey[100],
            onPressed: onClickedCopy,
          ),
        ],
      );
}
