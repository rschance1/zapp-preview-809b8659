import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  User? get currentUser => _supabase.auth.currentUser;
  
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: null,
        data: {'email_confirm': false},
      );
      
      // Log detailed information for debugging
      print('Signup response: ${response.user?.id}');
      print('Signup session: ${response.session?.accessToken != null}');
      
      return response;
    } catch (e) {
      print('Signup error details: $e');
      print('Error type: ${e.runtimeType}');
      if (e is AuthException) {
        print('Auth error message: ${e.message}');
        print('Auth error status code: ${e.statusCode}');
      }
      rethrow;
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      print('Signin response: ${response.user?.id}');
      print('Signin session: ${response.session?.accessToken != null}');
      
      return response;
    } catch (e) {
      print('Signin error details: $e');
      print('Error type: ${e.runtimeType}');
      if (e is AuthException) {
        print('Auth error message: ${e.message}');
        print('Auth error status code: ${e.statusCode}');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
  }
}