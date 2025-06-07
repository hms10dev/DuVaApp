import 'package:duva_app/screens/home_screen.dart';
import 'package:duva_app/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  AuthGateState createState() => AuthGateState();
}

class AuthGateState extends State<AuthGate> {
  Session? _session;

  @override
  void initState() {
    super.initState();

    // Listen for auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((authEvent) {
      setState(() {
        _session = authEvent.session;
      });
    });

    // Get initial session state
    _session = Supabase.instance.client.auth.currentSession;
  }

  @override
  Widget build(BuildContext context) {
    return _session != null ? const HomeScreen() : const LoginScreen();
  }
}
