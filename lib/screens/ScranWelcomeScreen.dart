import 'package:flutter/material.dart';
import 'package:save_the_scran/widgets/RoundedButtonWidget.dart';
import 'LoginScreen.dart';
import 'RegistrationScreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ScranWelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _ScranWelcomeScreenState createState() => _ScranWelcomeScreenState();
}

class _ScranWelcomeScreenState extends State<ScranWelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.greenAccent[200],
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/heartLogo.png'),
                      height: 200.0,
                    ),
                  ),
                  Container(
                    child: TyperAnimatedTextKit(
                      text: ['Save the Scran'],
                      textStyle: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'GoogleFonts.pacifico',
                      ),
                      //just for debug, change it back to false
                      isRepeatingAnimation: false,
                    ),
                    //   child: Text(
                    // 'Save the Scran',
                    // style: TextStyle(
                    //     fontWeight: FontWeight.w700,
                    //     fontFamily: 'GoogleFonts.pacifico',
                    //     fontSize: 35),
                    // )
                  ),
                ],
              ),
              SizedBox(
                height: 40.0,
              ),
              RoundedButton(
                title: 'Log In',
                colour: Color(0xFFFF4081),
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                },
              ),
              RoundedButton(
                title: 'Register',
                colour: Color(0xFFc2075e),
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
