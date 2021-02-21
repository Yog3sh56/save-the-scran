import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'fridge/FridgeScreen.dart';
import 'market/CommunityMarket.dart';
import 'chat/ChatContacts.dart';
import 'camera/TakePictureScreen.dart';


void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  return runApp(MyApp(firstCamera));
}

class MyApp extends StatelessWidget{
  final camera;
  MyApp(this.camera);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Save the Scran',
      home: MyBottomNavigationBar(),
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      // initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FridgeScreen widget.
        // '/': (context) => MyBottomNavigationBar(),
        // When navigating to the "/market" route, build the SecondScreen widget.
        '/market': (context) => CommunityMarketScreen(),
        '/fridge': (context) => FridgeScreen(),
        '/chat': (context) => ChatContacts(),
        '/camera': (context) => TakePictureScreen(camera: camera),
      },
    );
  }
}




class MyBottomNavigationBar extends StatefulWidget{
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

  void onTappedBar(int index){
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      body: _children[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF00E676),
        selectedItemColor: Color(0xFFFF4081),
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        onTap: onTappedBar,
        currentIndex: _index,
        items: [
          BottomNavigationBarItem(
            title: Text('Fridge'),
            icon: Icon(Icons.kitchen),
          ),
          BottomNavigationBarItem(
            title: Text('Market'),
            icon: Icon(Icons.storefront),
          ),
          BottomNavigationBarItem(
            title: Text('Saviours'),
            icon: Icon(Icons.chat),
          ),
        ],
      )
      );
  }
}
