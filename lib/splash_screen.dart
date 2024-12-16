import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

import 'assets/home_screen/home_screen.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _checkInternetConnectionAndProceed();
  }

  // Check for internet connection and show dialog if unavailable
  Future<void> _checkInternetConnectionAndProceed() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    // Check connectivity type
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      print('Connected via Mobile Data');
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      print('Connected via WiFi');
    } else {
      print('No internet connection');
      _showNoInternetDialog();
      return; // Exit the function if no connection
    }

    // Check if the internet is actually working
    bool isInternetAvailable = await _checkInternetAvailability();
    if (isInternetAvailable) {
      _proceedToNextScreen();
    } else {
      // Internet connection is present but no access, show a message
      _showNoInternetDialog();
    }
  }

  // Verify actual internet availability
  Future<bool> _checkInternetAvailability() async {
    try {
      print('Attempting to check internet availability...');
      final response = await http.get(Uri.parse('https://www.google.com')).timeout(Duration(seconds: 5));

      if (response.statusCode == 200) {
        print('Internet is available.');
        return true;
      } else {
        print('No internet access detected, status code: ${response.statusCode}');
        return false;
      }
    } on TimeoutException catch (_) {
      print('TimeoutException: No internet access or request timed out.');
      return false;
    } catch (e) {
      print('Exception: $e');
      return false;
    }
  }

  // Navigate to the next screen after splash
  void _proceedToNextScreen() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    });
  }

  // Show no internet connection dialog
  void _showNoInternetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black87, // Dark background color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0), // Rounded corners for modern look
        ),
        title: Text(
          'No Internet Connection',
          style: TextStyle(
            color: Colors.white, // Title text color
            fontWeight: FontWeight.bold, // Title font weight
          ),
        ),
        content: Text(
          'Please connect to the internet and try again.',
          style: TextStyle(color: Colors.grey[300]), // Content text color (lighter grey)
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Exit the app if there is no internet connection
              exit(0);
            },
            child: Text(
              'OK',
              style: TextStyle(
                color: Colors.white, // White color for the button (neutral)
                fontWeight: FontWeight.bold, // Button font weight
              ),
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 12.0), // Increased padding for buttons
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Color(0xFF000000),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Centered logo with increased size
            Center(
              child: SizedBox(
                width: 500, // Increased width
                height: 100, // Increased height
                child: Image.asset(
                  'lib/assets/images/official_logo.png',
                  fit: BoxFit.contain, // Adjust as needed for your layout
                ),
              ),
            ),
            // Loading animation at the bottom
            Positioned(
              bottom: 30.0,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Lottie.asset(
                  'lib/assets/animated_icon/loading-anim.json',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


