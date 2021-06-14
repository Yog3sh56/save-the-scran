import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:save_the_scran/screens/RecognitionScreen.dart';

import 'package:image_gallery_saver/image_gallery_saver.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  static const String id = "picture_screen";

  final CameraDescription camera;

  //final String title = 'Scran goods recognition';

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  XFile image;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          backgroundColor: Colors.greenAccent[200],
          title: Text('Add food to your fridge',
              style: TextStyle(color: Colors.black))),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.

      body: Stack(children: [
        Positioned(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.

                return CameraPreview(_controller);
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Positioned(
          bottom: 0,
          child: GestureDetector(
            child: Container(
              height: 140,
              width: MediaQuery.of(context).size.width,
              child: Icon(
                Icons.camera,
                size: 30,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.greenAccent[200], Colors.greenAccent[200]],
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                ),
              ),
            ),
            onTap: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Attempt to take a picture and get the file `image`
                // where it was saved.
                image = await _controller.takePicture();

                final result = await ImageGallerySaver.saveFile(image?.path);
                print('result:$result');
                if (result) {
                  print('Failed to save！');
                } else {
                  print('Save successfully!');
                }
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DisplayRecognition(image),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

class DisplayRecognition extends StatelessWidget {
  final result;

  const DisplayRecognition(this.result);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
        title: Text("Recognition"),
        backgroundColor: Colors.greenAccent[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const SizedBox(height: 25),
            TextRecognitionWidget(carryoverImage: result),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
