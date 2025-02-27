import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  void loginPopup(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Login"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  Navigator.pop(context); // Close popup
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  Navigator.pop(context); // Close popup on failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Login failed: $e")),
                  );
                }
              },
              child: const Text("Login"),
            ),
          ],
        );
      },
    );
  }

  void signupPopup(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign Up"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
                  Navigator.pop(context); // Close popup
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  Navigator.pop(context); // Close popup on failure
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Signup failed: $e")),
                  );
                }
              },
              child: const Text("Sign Up"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication')),
      body: Stack(
        children: [
          Positioned.fill(
            child: Center(
              // Centers the scaled image
              child: FractionallySizedBox(
                widthFactor: 1.2, // 120% of the screen width
                heightFactor: 1.2, // 120% of the screen height
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.amberAccent.withOpacity(0.7), BlendMode.srcATop),
                  child: Image.asset(
                    'assets/dragon.png',
                    fit: BoxFit
                        .contain, // Ensures the image scales while maintaining aspect ratio
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.email),
                  label: const Text("Sign in with Email"),
                  onPressed: () => loginPopup(context), // Open login popup
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.person_add),
                  label: const Text("Sign Up"),
                  onPressed: () => signupPopup(context), // Open signup popup
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
