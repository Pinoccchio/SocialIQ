import 'package:camera/camera.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<SocialApp> apps = [
    SocialApp(
      name: 'Facebook',
      iconPath: 'lib/assets/images/facebook.jpg', // You'll need to add this image
      color: Colors.blue,
      action: _launchFacebook,
    ),
    SocialApp(
      name: 'Gallery',
      iconPath: 'lib/assets/images/google-photos.png',
      color: Colors.purple,
      action: _launchGooglePhotos,
    ),
    SocialApp(
      name: 'YouTube',
      iconPath: 'lib/assets/images/youtube.png', // You'll need to add this image
      color: Colors.red,
      action: _launchYouTube,
    ),
    SocialApp(
      name: 'Messages',
      iconPath: 'lib/assets/images/google-messages.jpg',
      color: Colors.green,
      action: _launchMessages,
    ),
    SocialApp(
      name: 'Contacts',
      iconPath: 'lib/assets/images/google-contacts.png',
      color: Colors.orange,
      action: _openContacts,
    ),
    SocialApp(
      name: 'Camera',
      iconPath: 'lib/assets/images/camera.png', // You'll need to add this image
      color: Colors.black,
      action: _launchCamera,
    ),
  ];

  static Future<void> _launchFacebook(BuildContext context) async {
    // Attempt to open the YouTube app directly (both Android and iOS)
    var openAppResult = await LaunchApp.openApp(
      androidPackageName: 'com.facebook.katana', // For Android
      openStore: true, // If app is not installed, open the app store
    );

    // Check the result and provide feedback
    if (openAppResult.runtimeType == bool && openAppResult == true) {
      // The app opened successfully
      print('YouTube app opened successfully');
    } else {
      // If app is not installed, it will redirect to the app store
      Fluttertoast.showToast(
        msg: "YouTube app not found, opening app store...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> _launchYouTube(BuildContext context) async {
    // Attempt to open the YouTube app directly (both Android and iOS)
    var openAppResult = await LaunchApp.openApp(
      androidPackageName: 'com.google.android.youtube', // For Android
      openStore: true, // If app is not installed, open the app store
    );

    // Check the result and provide feedback
    if (openAppResult.runtimeType == bool && openAppResult == true) {
      // The app opened successfully
      print('YouTube app opened successfully');
    } else {
      // If app is not installed, it will redirect to the app store
      Fluttertoast.showToast(
        msg: "YouTube app not found, opening app store...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> _launchMessages(BuildContext context) async {
    // Attempt to open the default messaging app
    var openAppResult = await LaunchApp.openApp(
      androidPackageName: 'com.google.android.apps.messaging', // Default Android messaging app
      iosUrlScheme: 'sms:', // iOS URL scheme for messages
      openStore: true,
    );

    // Check the result and provide feedback
    if (openAppResult.runtimeType == bool && openAppResult == true) {
      // The app opened successfully
      print('Messages app opened successfully');
    } else {
      // If app couldn't be opened, show a toast
      Fluttertoast.showToast(
        msg: "Couldn't open Messages app",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> _launchGooglePhotos(BuildContext context) async {
    // Attempt to open the Google Photos app
    var openAppResult = await LaunchApp.openApp(
      androidPackageName: 'com.google.android.apps.photos',
      iosUrlScheme: 'googlephotos://',
      openStore: true,
    );

    // Check the result and provide feedback
    if (openAppResult.runtimeType == bool && openAppResult == true) {
      // The app opened successfully
      print('Google Photos app opened successfully');
    } else {
      // If app couldn't be opened, show a toast
      Fluttertoast.showToast(
        msg: "Couldn't open Google Photos app",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static Future<void> _openContacts(BuildContext context) async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      try {
        var openAppResult = await LaunchApp.openApp(
          androidPackageName: 'com.google.android.contacts',
          iosUrlScheme: 'contacts://',
          openStore: true,
        );

        if (openAppResult.runtimeType == bool && openAppResult == true) {
          print('Google Contacts app opened successfully');
        } else {

        }
      } catch (e) {
        _showErrorSnackBar(context, 'Error opening Google Contacts: $e');
      }
    } else {
      _showErrorSnackBar(context, 'Permission to access contacts denied');
    }
  }

  static Future<void> _launchCamera(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CameraScreen(camera: firstCamera),
        ),
      );
    } catch (e) {
      _showErrorSnackBar(context, 'Error opening Camera: $e');
    }
  }

  static void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  static void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Pure black background
          Container(
            color: Colors.black, // Set to black
          ),
          // Content
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 40),
                const Text(
                  'Social IQ',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: apps.length,
                    itemBuilder: (context, index) {
                      return _buildAppCard(context, apps[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppCard(BuildContext context, SocialApp app) {
    return GestureDetector(
      onTap: () => app.action(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              app.iconPath,
              width: 40,
              height: 40,
            ),
            const SizedBox(height: 12),
            Text(
              app.name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SocialApp {
  final String name;
  final String iconPath;
  final Color color;
  final Function(BuildContext) action;

  SocialApp({
    required this.name,
    required this.iconPath,
    required this.color,
    required this.action,
  });
}

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera(widget.camera);
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.max,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: CameraPreview(_controller),
                ),
                _buildTopBar(),
                _buildBottomBar(),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator(color: Colors.white));
          }
        },
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        color: Colors.black.withOpacity(0.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            IconButton(
              icon: Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  _isFlashOn = !_isFlashOn;
                });
                _controller.setFlashMode(
                  _isFlashOn ? FlashMode.torch : FlashMode.off,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: Container(
        alignment: Alignment.center,
        child: _buildCaptureButton(),
      ),
    );
  }


  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: () async {
        try {
          await _initializeControllerFuture;
          final image = await _controller.takePicture();
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = path.join(directory.path, '${DateTime.now()}.png');
          await image.saveTo(imagePath);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Picture saved to $imagePath'),
              backgroundColor: Colors.black87,
              behavior: SnackBarBehavior.floating,
            ),
          );
        } catch (e) {
          print(e);
        }
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 5),
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          margin: EdgeInsets.all(5),
        ),
      ),
    );
  }
}


