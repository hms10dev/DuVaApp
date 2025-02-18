import 'package:duva_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authService = AuthService();
  //logout button pressed
  void logout() async {
    await authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to DuVa,  $currentEmail"),
        actions: [
          //logout button
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
    );
  }
}
