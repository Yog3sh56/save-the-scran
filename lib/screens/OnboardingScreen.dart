import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'ScranWelcomeScreen.dart';

class OnboardingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) => SafeArea(
      child: Stack(

        children: <Widget>[
          // Opacity(opacity: 0.9,
          //   child:Container(
          //   decoration: BoxDecoration(
          //     image:DecorationImage(
          //       image:AssetImage('images/Wel0.jpg'),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          //
          //
          // ),),
          Container(
            decoration: BoxDecoration(
              image:DecorationImage(
                image:AssetImage('images/Wel0.jpg'),
                fit: BoxFit.cover,
              ),
            ),


          ),



          IntroductionScreen(
            globalBackgroundColor: Colors.green[200].withOpacity(0.7),
            pages:[
              PageViewModel(
                title: 'Reduce food waste is our main priority.',
                body: 'For our future, save the scran.',
                image: buildImage('images/dish0.png'),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: 'Around 1.3 billion tonnes of food  waste every year.',
                body: '1/3 of the food produced for human consumption goes to waste every year.',
                image: buildImage('images/dish1.png'),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: 'Any chance of some scran?',
                body: 'In Scotland households throw away around 600.000 tonnes of food and drink per year.',
                image: buildImage('images/dish2.png'),
                decoration: getPageDecoration(),
              ),
              PageViewModel(
                title: 'Become a Saviour and help us Save the Scran.',
                body: 'Our app will therefore focus on the prevention of food waste and redistribution of food.',
                image: buildImage('images/dish3.png'),
                decoration: getPageDecoration(),
              )

            ],
            done: Text('Done',style: TextStyle(fontWeight: FontWeight.w600)),
            onDone: () => goToWel(context),
            showSkipButton: true,
            skip: Text('Skip'),
            onSkip: () => goToWel(context),
            next: Icon(Icons.arrow_forward),
            dotsDecorator: getDotDecoration(),
            onChange: (index) => print('Page $index selected'),
            skipFlex: 0,
            nextFlex: 0,
            showNextButton: true,
            skipColor: Colors.black87,
            nextColor: Colors.black87,
            doneColor: Colors.blue[800],
          ),

        ]
      ),

  );
  
  void goToWel(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder:(_) => ScranWelcomeScreen()),
  );

  
  Widget buildImage(String path) =>
      // Center(
      Container(
          child:Image.asset(path,fit: BoxFit.cover,)
      );

      // );

  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Colors.black45,
    activeColor: Colors.blue[800],
    size: Size(10, 10),
    activeSize: Size(23, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );

  PageDecoration getPageDecoration() => PageDecoration(
    titleTextStyle: TextStyle(color: Colors.white ,fontSize: 24,fontWeight: FontWeight.bold),
    bodyTextStyle: TextStyle(color: Colors.black54,fontSize: 20),
    descriptionPadding: EdgeInsets.all(16).copyWith(bottom: 0),
    imagePadding: EdgeInsets.all(24),
      imageAlignment: Alignment.center,

  );
}