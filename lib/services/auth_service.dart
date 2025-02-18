import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  //sign in with email and password
  Future<AuthResponse> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  //sign up with email and password

  Future<AuthResponse> signUpWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabaseClient.auth.signUp(email: email, password: password);
  }

  //sign out

  Future<void> signOut() async {
    return await _supabaseClient.auth.signOut();
  }

  //get user email

  String? getCurrentUserEmail() {
    final session = _supabaseClient.auth.currentSession;
    return session?.user.email ?? "No logged-in user";
  }

  //sign in with Google

  //sign up with Google
}
