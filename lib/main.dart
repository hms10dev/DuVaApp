import 'package:duva_app/services/auth_gate.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5zaHpkd2JobnRnY2h0eWFjbm1pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0NTI1NTAsImV4cCI6MjA1NTAyODU1MH0._bzKFx9ftSqjOlfG_PCqtKUGSDuRm5r9n7cwc935GbM",
    url: "https://nshzdwbhntgchtyacnmi.supabase.co",
  );
  await Hive.initFlutter();
  await Hive.openBox('duas');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
