/*
Auth Gate - this will continuously listen for auth state changes.

-----------------------------------

unauthenticated -> Login Page

authenticated -> Profile Page

 */

import 'package:duva_app/screens/home_screen.dart';
import 'package:duva_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //Listen to auth state changes
      stream: Supabase.instance.client.auth.onAuthStateChange,
      //Build the page based on auth state changes
      builder: (context, snapshot) {
        //loading....
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        //check for valid session
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
