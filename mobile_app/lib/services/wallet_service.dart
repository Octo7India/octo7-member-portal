import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import 'auth_service.dart';

/// Reads the signed-in member's dashboard through OCTO7's authenticated API.
/// Wallet tables and service-role credentials are never exposed to the app.
class WalletService {
  WalletService._();
  static final WalletService instance = WalletService._();

  Future<Map<String, dynamic>> fetchDashboard() async {
    if (!SupabaseConfig.isConfigured) {
      throw StateError('OCTO7 connection is not configured in this app build.');
    }
    final token = await AuthService.instance.sessionToken;
    if (token == null || token.isEmpty) {
      throw StateError('Please log in to view your OCTO7 wallet.');
    }
    final response = await Supabase.instance.client.functions.invoke(
      'octo7-api',
      body: const {'action': 'me'},
      headers: {'Authorization': 'Bearer $token'},
    );
    final data = response.data;
    if (response.status < 200 || response.status >= 300 || data is! Map) {
      throw Exception('OCTO7 dashboard request failed (${response.status}).');
    }
    final result = Map<String, dynamic>.from(data);
    if (result['success'] != true) {
      throw Exception(result['error']?.toString() ?? 'Could not load wallet.');
    }
    return result;
  }
}
