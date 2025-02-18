import 'package:duva_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // get auth service
  final authService = AuthService();

  //textControllers

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  //sign up button

  void signUp() async {
    //prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // check that passwords match

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Password don't match")));
      return;
    }

    //attempt login
    try {
      await authService.signUpWithEmailPassword(email, password);
      //pop the register page
      Navigator.pop(context);
    } on AuthException catch (e) {
      if (e.message.contains("Email not confirmed")) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Please confirm your email before logging in."),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
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
          //confirm password
          TextField(
            controller: _confirmPasswordController,
            decoration: const InputDecoration(labelText: "Confirm Password"),
            obscureText: true,
          ),

          const SizedBox(height: 12),

          //button
          ElevatedButton(onPressed: signUp, child: const Text("Sign Up")),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
