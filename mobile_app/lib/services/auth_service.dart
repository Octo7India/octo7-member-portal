import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Supabase authentication wrapper for the mobile app.
///
/// This foundation intentionally supports email/password only. Phone and
/// OCTO7 ID sign-in need a verified, secure account-resolution endpoint so
/// they always authenticate the same existing Supabase user.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  SupabaseClient get _client {
    if (!SupabaseConfig.isConfigured) {
      throw StateError(
        'Supabase is not configured. Provide SUPABASE_URL and '
        'SUPABASE_ANON_KEY at build time.',
      );
    }
    return Supabase.instance.client;
  }

  User? get currentUser =>
      SupabaseConfig.isConfigured ? Supabase.instance.client.auth.currentUser : null;

  Stream<AuthState> get authStateChanges =>
      _client.auth.onAuthStateChange;

  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
    String? emailRedirectTo,
  }) {
    return _client.auth.signUp(
      email: email.trim(),
      password: password,
      emailRedirectTo: emailRedirectTo,
    );
  }

  Future<void> signOut() => _client.auth.signOut();
}
