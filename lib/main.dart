import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:save_the_scran/screens/LoginScreen.dart';
import 'package:save_the_scran/screens/ProfileScreen.dart';
import 'package:save_the_scran/screens/RegistrationScreen.dart';
import 'screens/FridgeScreen.dart';
import 'screens/CommunityMarket.dart';
import 'screens/TakePictureScreen.dart';
import 'chat/ChatContactsScreen.dart';
import 'screens/ScranWelcomeScreen.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`

  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  await Firebase.initializeApp();
  return runApp(MyApp(firstCamera));
}

class MyApp extends StatelessWidget {
  static const String id = "my_app";
  final camera;

  MyApp(this.camera);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Save the Scran',
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFc2075e),
            ),
          ),
          primaryColor: Color(0xFFc2075e),
          accentColor: Colors.greenAccent[200]),
      home: MyBottomNavigationBar(),
      routes: {
        MyApp.id: (context) => MyApp(context),
        CommunityMarketScreen.id: (context) => CommunityMarketScreen(),
        FridgeScreen.id: (context) => FridgeScreen(),
        ChatContacts.id: (context) => ChatContacts(),
        TakePictureScreen.id: (context) => TakePictureScreen(camera: camera),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        ScranWelcomeScreen.id: (context) => ScranWelcomeScreen(),
      },
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _index = 0;
  final List<Widget> _children = [
    FridgeScreen(),
    CommunityMarketScreen(),
    ChatContacts(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _children[_index],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          onTap: onTappedBar,
          currentIndex: _index,
          items: [
            BottomNavigationBarItem(
              label: 'Fridge',
              icon: Icon(Icons.kitchen),
            ),
            BottomNavigationBarItem(
              label: 'Market',
              icon: Icon(Icons.storefront),
            ),
            BottomNavigationBarItem(
              label: 'Saviours',
              icon: Icon(Icons.chat),
            ),
          ],
        ));
  }
}
