import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Uses OCTO7's existing server-side credential verifier. The server returns
/// a short-lived opaque session token; the password is never stored locally.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'octo7_session_token';

  SupabaseClient get _client {
    if (!SupabaseConfig.isConfigured) {
      throw StateError('OCTO7 Supabase connection is not configured.');
    }
    return Supabase.instance.client;
  }

  Future<String?> get sessionToken => _storage.read(key: _tokenKey);
  Future<bool> get hasSession async => (await sessionToken)?.isNotEmpty == true;

  Future<Map<String, dynamic>> signIn({
    required String identifier,
    required String password,
  }) async {
    final response = await _client.functions.invoke(
      'octo7-api',
      body: {
        'action': 'member_login',
        'identifier': identifier.trim(),
        'identifier_type': 'member_id',
        'password': password,
      },
      headers: {'Authorization': 'Bearer ${SupabaseConfig.anonKey}'},
    );
    final data = response.data;
    if (response.status < 200 || response.status >= 300 || data is! Map) {
      throw Exception('OCTO7 login request failed. Please try again.');
    }
    final result = Map<String, dynamic>.from(data);
    if (result['success'] != true) {
      throw Exception(result['error']?.toString() ?? 'Invalid login details.');
    }
    final token = result['session_token']?.toString();
    if (token == null || token.isEmpty) {
      throw const FormatException('The server did not return a login session.');
    }
    await _storage.write(key: _tokenKey, value: token);
    return result;
  }

  Future<void> signOut() async {
    final token = await sessionToken;
    if (token != null && token.isNotEmpty && SupabaseConfig.isConfigured) {
      try {
        await _client.functions.invoke(
          'octo7-api',
          body: const {'action': 'logout'},
          headers: {'Authorization': 'Bearer $token'},
        );
      } finally {
        await _storage.delete(key: _tokenKey);
      }
    } else {
      await _storage.delete(key: _tokenKey);
    }
  }
}
