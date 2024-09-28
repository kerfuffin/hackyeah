import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GoogleSignInScreen(),
    );
  }
}

class GoogleSignInScreen extends StatefulWidget {
  @override
  _GoogleSignInScreenState createState() => _GoogleSignInScreenState();
}

class _GoogleSignInScreenState extends State<GoogleSignInScreen> {
  // Configure the GoogleSignIn instance with the required scopes.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/fitness.body.read',
      'https://www.googleapis.com/auth/fitness.activity.read',
      'https://www.googleapis.com/auth/fitness.nutrition.read',
      'https://www.googleapis.com/auth/fitness.sleep.read',
    ],
  );

  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      setState(() {
        _currentUser = account;
      });
    });
    // _googleSignIn
    //     .signInSilently(); // Automatically try to sign in the user if previously authenticated.
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
      Fluttertoast.showToast(
          msg: "toast messag loged in",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      Navigator.pushNamed(context, '/home');
      print("Sign in successful");
    } catch (error) {
      print("Sign in failed: $error");
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.disconnect();
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    GoogleSignInAccount? user = _currentUser;
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Fit Sign In'),
        actions: <Widget>[
          if (user != null)
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: _handleSignOut,
            )
        ],
      ),
      body: Center(
        child: user != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ListTile(
                    leading: GoogleUserCircleAvatar(
                      identity: user,
                    ),
                    title: Text(user.displayName ?? ''),
                    subtitle: Text(user.email),
                  ),
                  ElevatedButton(
                    onPressed: _handleSignOut,
                    child: Text('SIGN OUT'),
                  ),
                ],
              )
            : ElevatedButton(
                onPressed: _handleSignIn,
                child: Text('SIGN IN WITH GOOGLE'),
              ),
      ),
    );
  }
}
