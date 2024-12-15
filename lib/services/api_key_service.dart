import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class ApiKeyService {
  final SupabaseClient _supabase;

  ApiKeyService(this._supabase);

  Future<String?> getApiKey(String userId) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.apiKeysTable)
          .select('api_key')
          .eq('user_id', userId)
          .maybeSingle();

      return response?['api_key'] as String?;
    } catch (e) {
      print('Error fetching API key: $e');
      return null;
    }
  }

  Future<bool> saveApiKey(String userId, String apiKey) async {
    try {
      await _supabase.from(SupabaseConfig.apiKeysTable).upsert({
        'user_id': userId,
        'api_key': apiKey,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('Error saving API key: $e');
      return false;
    }
  }

  Future<bool> deleteApiKey(String userId) async {
    try {
      await _supabase
          .from(SupabaseConfig.apiKeysTable)
          .delete()
          .eq('user_id', userId);
      return true;
    } catch (e) {
      print('Error deleting API key: $e');
      return false;
    }
  }
}
