import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_llm_chat/main.dart';
import 'package:flutter_llm_chat/services/api_key_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    // モックのApiKeyServiceを作成
    final mockApiKeyService = ApiKeyService(
      SupabaseClient('mock-url', 'mock-key'),
    );

    await tester.pumpWidget(MyApp(
      prefs: prefs,
      apiKeyService: mockApiKeyService,
      initialApiKey: 'test-api-key',
      userId: 'test-user-id',
    ));
  });
}
