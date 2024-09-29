import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSignInScreen extends StatefulWidget {
  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  SharedPreferences? prefs;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/fitness.body.read',
      'https://www.googleapis.com/auth/fitness.activity.read',
      'https://www.googleapis.com/auth/fitness.nutrition.read',
      'https://www.googleapis.com/auth/fitness.sleep.read',
    ],
  );

  GoogleSignInAccount? _currentUser;
  bool _isSignedIn = true;

  @override
  void initState() {
    super.initState();
    _initializeSharedPreferences();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        _handleSendToken();
      }
    });
    try {
      _googleSignIn.signInSilently();
    } catch (error) {
      _isSignedIn = false;
    }
  }

  Future<void> _initializeSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      print("Sign in successful");
    } catch (error) {
      print("Sign in failed: $error");
      Fluttertoast.showToast(msg: "Sign in failed. Please try again.");
    }
  }

  Future<void> _handleSendToken() async {
    if (_currentUser == null) return;

    try {
      final GoogleSignInAuthentication auth =
          await _currentUser!.authentication;

      if (auth.accessToken == null) {
        Fluttertoast.showToast(msg: "Failed to obtain access token.");
        return;
      }

      // Save the token to SharedPreferences
      if (prefs != null) {
        await prefs!.setString('token', auth.accessToken!);
      } else {
        print("SharedPreferences not initialized.");
      }

      // Prepare the JSON payload
      Map<String, String> payload = {
        "token": auth.accessToken!,
        "email": _currentUser!.email,
      };

      // Send the POST request
      final response = await http.post(
        Uri.parse('https://f0f4-188-146-118-195.ngrok-free.app/data'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "Token sent successfully.");
        // Navigate to HomeScreen
        Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
      } else {
        print("Failed to send token. Status code: ${response.statusCode}");
        Fluttertoast.showToast(msg: "Failed to send token.");
      }
    } catch (e) {
      print("Error sending token: $e");
      Fluttertoast.showToast(msg: "An error occurred while sending the token.");
    }
  }

  @override
  Widget build(BuildContext context) {
    // wait for isSignedIn to be false, then show google button
    // else show loading indicator
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ElevatedButton(
            onPressed: _handleSignIn,
            child: const Text('Sign in with Google'),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
