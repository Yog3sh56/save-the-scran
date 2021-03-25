import 'package:flutter/material.dart';

class PushtoMarketWidget extends StatelessWidget {
  final VoidCallback onClickedPushtoMarket;

  PushtoMarketWidget({
    @required this.onClickedPushtoMarket,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            color: Color(0xFF82B1FF),
            onPressed: onClickedPushtoMarket,
            child: Text('Push to Market'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          const SizedBox(height: 40, width: 0),
        ],
      );
}
