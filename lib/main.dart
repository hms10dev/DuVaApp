import 'package:duva_app/services/auth_gate.dart';
import 'package:duva_app/utils/environment.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const supabaseUrl = Environment.supabaseUrl;
  const supabaseAnonKey = Environment.supabaseAnonKey;
  assert(
    supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty,
    'SUPABASE_URL and SUPABASE_ANON_KEY must be provided',
  );
  await Supabase.initialize(anonKey: supabaseUrl, url: supabaseAnonKey);
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
