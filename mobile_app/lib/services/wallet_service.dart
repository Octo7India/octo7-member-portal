import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';

/// Reads the signed-in member's dashboard through OCTO7's authenticated
/// Edge Function. The app never reads wallet tables or holds a service key.
class WalletService {
  WalletService._();

  static final WalletService instance = WalletService._();

  Future<Map<String, dynamic>> fetchDashboard() async {
    if (!SupabaseConfig.isConfigured) {
      throw StateError('OCTO7 connection is not configured in this app build.');
    }

    final client = Supabase.instance.client;
    if (client.auth.currentSession == null) {
      throw StateError('Please log in to view your OCTO7 wallet.');
    }

    final response = await client.functions.invoke(
      'octo7-api',
      body: const {'action': 'dashboard'},
    );

    final data = response.data;
    if (response.status < 200 || response.status >= 300) {
      throw Exception('OCTO7 dashboard request failed (${response.status}).');
    }
    if (data is! Map) {
      throw const FormatException('Unexpected OCTO7 dashboard response.');
    }
    if (data['success'] != true) {
      throw Exception(data['error']?.toString() ?? 'Could not load wallet.');
    }

    return Map<String, dynamic>.from(data);
  }
}
