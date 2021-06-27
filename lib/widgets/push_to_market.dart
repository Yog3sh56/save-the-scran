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
          ElevatedButton(
            child: Text('Add to Fridge'),
            onPressed: onClickedPushtoMarket,
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(                TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  )),
              //padding: MaterialStateProperty.all(EdgeInsetsGeometry.infinity),
              minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width/1.5,MediaQuery.of(context).size.width/5)),
              backgroundColor: MaterialStateProperty.all(Colors.deepPurpleAccent[700]) ,
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius:BorderRadius.all(Radius.circular(50)),
              ))
            )
          ),
            
          
          const SizedBox(height: 40, width: 0),
        ],
      );
}
