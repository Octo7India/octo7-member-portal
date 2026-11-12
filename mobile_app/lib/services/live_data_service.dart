import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/supabase_config.dart';
import 'auth_service.dart';

/// Reads member-owned data through the same authenticated OCTO7 Edge Function
/// actions used by the web member portal. No service-role key is shipped here.
class LiveDataService {
  LiveDataService._();
  static final LiveDataService instance = LiveDataService._();

  Future<Map<String, dynamic>> _call(String action, [Map<String, dynamic> payload = const {}]) async {
    if (!SupabaseConfig.isConfigured) {
      throw StateError('OCTO7 connection is not configured in this app build.');
    }
    final token = await AuthService.instance.sessionToken;
    if (token == null || token.isEmpty) {
      throw StateError('Please log in to view your OCTO7 account data.');
    }
    final response = await Supabase.instance.client.functions.invoke(
      'octo7-api',
      body: {'action': action, ...payload},
      headers: {'Authorization': 'Bearer $token'},
    );
    final data = response.data;
    if (response.status < 200 || response.status >= 300 || data is! Map) {
      throw Exception('OCTO7 $action request failed (${response.status}).');
    }
    final result = Map<String, dynamic>.from(data);
    if (result['success'] == false || result['error'] != null) {
      throw Exception(result['error']?.toString() ?? result['message']?.toString() ?? 'OCTO7 $action request failed.');
    }
    return result;
  }

  /// Web portal's authenticated profile/dashboard action.
  Future<Map<String, dynamic>> fetchMemberProfile() => _call('me');

  /// Web portal's member-specific genealogy action.
  Future<Map<String, dynamic>> fetchGenealogy({String? rootMemberId}) =>
      _call('my_genealogy', rootMemberId == null ? {} : {'root_member_id': rootMemberId});

  /// Finds vacant positions across the selected member's downline, matching the website.
  Future<List<Map<String, dynamic>>> fetchVacantPositions(String rootMemberId) async {
    final result = await _call('find_vacant_positions', {
      'root_member_id': rootMemberId,
      'limit': 500,
    });
    final raw = result['vacant_positions'];
    if (raw is! List) return [];
    return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }

  /// Web portal's published product catalog action.
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final result = await _call('get_products');
    final raw = result['products'] ?? result['data'] ?? [];
    if (raw is! List) throw const FormatException('Invalid OCTO7 products response.');
    return raw.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
  }

  /// Reconstructs the exact parent_id/side/depth node shape used by the web portal.
  static Map<String, dynamic>? buildGenealogyTree(dynamic rawNodes) {
    if (rawNodes is! List) return null;
    final nodes = rawNodes.whereType<Map>().map((n) => Map<String, dynamic>.from(n)).toList();
    final map = <String, Map<String, dynamic>>{};
    for (final node in nodes) {
      node['left'] = null;
      node['right'] = null;
      map[(node['id'] ?? '').toString()] = node;
    }
    final roots = nodes.where((n) => int.tryParse('${n['depth']}') == 0).toList();
    if (roots.isEmpty) return null;
    final root = map[(roots.first['id'] ?? '').toString()];
    if (root == null) return null;
    for (final node in nodes) {
      if (int.tryParse('${node['depth']}') == 0) continue;
      final parent = map[(node['parent_id'] ?? '').toString()];
      if (parent == null) continue;
      final side = (node['side'] ?? '').toString().toLowerCase();
      final child = map[(node['id'] ?? '').toString()];
      if (side == 'left') parent['left'] = child;
      if (side == 'right') parent['right'] = child;
    }
    return root;
  }
}
