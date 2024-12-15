import 'package:flutter/foundation.dart';
import '../models/message.dart';
import '../services/openai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChatViewModel extends ChangeNotifier {
  final OpenAIService _openAIService;
  final SharedPreferences _prefs;
  List<Message> _messages = [];
  bool _isLoading = false;
  String? _error;

  ChatViewModel(this._openAIService, this._prefs) {
    _loadMessages();
  }

  List<Message> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _loadMessages() {
    final String? savedMessages = _prefs.getString('chat_messages');
    if (savedMessages != null) {
      final List<dynamic> decoded = json.decode(savedMessages);
      _messages = decoded.map((item) => Message.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveMessages() async {
    final String encoded =
        json.encode(_messages.map((m) => m.toJson()).toList());
    await _prefs.setString('chat_messages', encoded);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = Message(text: text, isUser: true);
    _messages.add(userMessage);
    _error = null;
    notifyListeners();
    await _saveMessages();

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _openAIService.sendMessage(text);
      final aiMessage = Message(text: response, isUser: false);
      _messages.add(aiMessage);
      await _saveMessages();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
