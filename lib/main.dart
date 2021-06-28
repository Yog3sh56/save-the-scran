import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:save_the_scran/screens/AddItemScreen.dart';
import 'package:save_the_scran/screens/ChooseAddMethod.dart';
import 'package:save_the_scran/screens/LoginScreen.dart';
import 'package:save_the_scran/screens/ProfileScreen.dart';
import 'package:save_the_scran/screens/RegistrationScreen.dart';
import 'package:save_the_scran/utils/LocationWrap.dart';
import 'package:save_the_scran/utils/NotificationsService.dart';
import 'screens/News/NewsScreen.dart';
import 'screens/FridgeScreen.dart';
import 'screens/CommunityMarket.dart';
import 'screens/TakePictureScreen.dart';
import 'chat/ChatContactsScreen.dart';
import 'screens/ScranWelcomeScreen.dart';

void main() async {

  final firstCamera = await init();

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
      // home: OnboardingScreen(),
      routes: {
        MyApp.id: (context) => MyApp(context),
        // MyApp.id: (context) => MyBottomNavigationBar(),
        CommunityMarketScreen.id: (context) => CommunityMarketScreen(),
        FridgeScreen.id: (context) => FridgeScreen(),
        ChatContacts.id: (context) => ChatContacts(),
        TakePictureScreen.id: (context) => TakePictureScreen(camera: camera),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        ScranWelcomeScreen.id: (context) => ScranWelcomeScreen(),
        ChooseAddMethod.id: (context) => ChooseAddMethod(),
        AddItemScreen.id: (context) => AddItemScreen(),
        NewsScreen.id: (context) => NewsScreen()
      },
    );
  }
}

class MyBottomNavigationBar extends StatefulWidget {
  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  // @override
  // void initState(){
  //   super.initState();
  //   goToOnboarding(context);
  // }
  // // goToOnboarding(context);
  //
  // void goToOnboarding(context) => Navigator.of(context).pushReplacement(
  //   MaterialPageRoute(builder:(_) => OnboardingScreen()),
  // );

  int _currentIndex = 0;
  final List<Widget> _children = [
    FridgeScreen(),
    NewsScreen(),
    ChooseAddMethod(),
    CommunityMarketScreen(),
    ChatContacts(),
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: _children[_currentIndex],
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            onTabTapped(2);
          },
          tooltip: "Add Food",
          child: Icon(Icons.add_circle_rounded,
              color: Colors.greenAccent[200], size: 55),
          elevation: 0.5,
          backgroundColor: Colors.white,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 14,
          unselectedFontSize: 14,
          // onTap: onTappedBar,
          // currentIndex: _index,
          onTap: onTabTapped,
          currentIndex: _currentIndex,

          items: [
            BottomNavigationBarItem(
              label: 'Fridge',
              icon: new Icon(Icons.kitchen),
            ),
            BottomNavigationBarItem(
              label: 'News',
              icon: new Icon(Icons.tv),
            ),
            BottomNavigationBarItem(
                label: 'Add Food',
                icon: new Icon(Icons.add_circle,
                    color: Colors.white.withOpacity(0))),
            BottomNavigationBarItem(
              label: 'Market',
              icon: new Icon(Icons.storefront),
            ),
            BottomNavigationBarItem(
              label: 'Saviours',
              icon: new Icon(Icons.chat),
            ),
          ],
        ));
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}
  Future<CameraDescription> init() async{
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    await Firebase.initializeApp();
    LocationWrap();
    scheduleNotifications();
    return firstCamera;
  }
