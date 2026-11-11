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

  /// Checks the locally stored token against the server before showing any
  /// authenticated screen. A rejected/expired/revoked token is removed.
  /// Network/server failures surface so a temporary outage does not silently
  /// erase a potentially valid session.
  Future<bool> validateSession() async {
    final token = await sessionToken;
    if (token == null || token.isEmpty) return false;

    final response = await _client.functions.invoke(
      'octo7-api',
      body: const {'action': 'dashboard'},
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.status == 401 || response.status == 403) {
      await _storage.delete(key: _tokenKey);
      return false;
    }
    if (response.status < 200 || response.status >= 300) {
      throw Exception('Could not verify your OCTO7 session (${response.status}).');
    }

    final data = response.data;
    if (data is! Map) {
      throw const FormatException('Invalid session verification response.');
    }
    final result = Map<String, dynamic>.from(data);
    if (result['success'] == true) return true;

    await _storage.delete(key: _tokenKey);
    return false;
  }

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

  /// Calls an existing OCTO7 member API action using the current opaque member session.
  Future<Map<String, dynamic>> invokeMemberAction(
    String action, [Map<String, dynamic> payload = const {}]
  ) async {
    final token = await sessionToken;
    if (token == null || token.isEmpty) {
      throw StateError('Your OCTO7 session has expired. Please log in again.');
    }
    final response = await _client.functions.invoke(
      'octo7-api',
      body: {'action': action, ...payload},
      headers: {'Authorization': 'Bearer $token'},
    );
    final data = response.data;
    if (response.status < 200 || response.status >= 300 || data is! Map) {
      throw Exception('OCTO7 request failed (${response.status}). Please try again.');
    }
    final result = Map<String, dynamic>.from(data);
    if (result['success'] == false || result['error'] != null) {
      throw Exception(result['error']?.toString() ?? result['message']?.toString() ?? 'Request failed.');
    }
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
