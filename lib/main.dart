import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/chat_screen.dart';
import 'screens/settings_screen.dart';
import 'services/openai_service.dart';
import 'services/api_key_service.dart';
import 'viewmodels/chat_view_model.dart';
import 'config/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabaseの初期化
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  final prefs = await SharedPreferences.getInstance();

  // 開発用の仮のユーザーID（後で認証システムと統合）
  const temporaryUserId = 'temp-user-id';

  final apiKeyService = ApiKeyService(Supabase.instance.client);
  final apiKey = await apiKeyService.getApiKey(temporaryUserId);

  runApp(MyApp(
    prefs: prefs,
    apiKeyService: apiKeyService,
    initialApiKey: apiKey,
    userId: temporaryUserId,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final ApiKeyService apiKeyService;
  final String? initialApiKey;
  final String userId;

  const MyApp({
    Key? key,
    required this.prefs,
    required this.apiKeyService,
    required this.initialApiKey,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChatGPT Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: initialApiKey == null
          ? SettingsScreen(
              apiKeyService: apiKeyService,
              userId: userId,
              onApiKeySaved: (apiKey) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => _buildChatScreen(apiKey),
                  ),
                );
              },
            )
          : _buildChatScreen(initialApiKey!),
    );
  }

  Widget _buildChatScreen(String apiKey) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        OpenAIService(apiKey),
        prefs,
      ),
      child: const ChatScreen(),
    );
  }
}
