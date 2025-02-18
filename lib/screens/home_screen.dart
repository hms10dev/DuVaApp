import 'package:duva_app/screens/dua_discovery_screen.dart';
import 'package:duva_app/screens/dua_vault_screen.dart';
import 'package:duva_app/screens/settings_screen.dart';
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

  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    Center(child: Text("Salaam, and Welcome to DuVa!")),
    DuaVaultScreen(),
    DuaDiscoveryScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome to DuVa,  $currentEmail"),
        actions: [
          IconButton(onPressed: logout, icon: Icon(Icons.logout_outlined)),
        ],
      ),
      body: _screens[_selectedIndex], // Change screen based on index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color.fromARGB(255, 228, 138, 110),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: "Vault"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Discovery"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}
