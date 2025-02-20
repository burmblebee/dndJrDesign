import 'package:flutter/material.dart';
import 'package:login_screen/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();

  Future<void> _handleGoogleSignIn() async {
    final userCredential = await _googleSignInProvider.signInWithGoogle();
    if (userCredential != null) {
      print("Google Sign-In Successful: ${userCredential.user?.displayName}");
      // Navigate to next screen (e.g., home screen)
    } else {
      print("Google Sign-In Canceled");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: ElevatedButton.icon(
          icon: Image.asset('assets/google_logo.png', height: 24), // Ensure asset exists
          label: const Text("Sign in with Google"),
          onPressed: _handleGoogleSignIn,
        ),
      ),
    );
  }
}
