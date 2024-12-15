import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/chat_screen.dart';
import 'services/openai_service.dart';
import 'viewmodels/chat_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Get API key from environment variables
  final apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
  if (apiKey.isEmpty) {
    throw Exception('OPENAI_API_KEY not found in .env file');
  }

  runApp(MyApp(prefs: prefs, apiKey: apiKey));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final String apiKey;

  const MyApp({
    Key? key,
    required this.prefs,
    required this.apiKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatViewModel(
        OpenAIService(apiKey),
        prefs,
      ),
      child: MaterialApp(
        title: 'ChatGPT Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: const ChatScreen(),
      ),
    );
  }
}
