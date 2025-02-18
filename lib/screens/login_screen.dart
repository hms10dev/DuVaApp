import 'package:duva_app/screens/register_screen.dart';
import 'package:duva_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // get auth service
  final authService = AuthService();

  //textControllers

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //login button pressed
  void login() async {
    //prepare data
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email and password cannot be empty")),
      );
      return;
    }

    //attempt login..
    try {
      await authService.signInWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  //Built Login Screen UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 50),
        children: [
          //email
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
          ),
          //password
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: "Password"),
            obscureText: true,
          ),

          const SizedBox(height: 12),

          //button
          ElevatedButton(onPressed: login, child: const Text("Login")),

          const SizedBox(height: 12),

          GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                ),
            child: Center(
              child: Text("Salaam ! Don't have an account? Sign Up"),
            ),
          ),
        ],
      ),
    );
  }
}
