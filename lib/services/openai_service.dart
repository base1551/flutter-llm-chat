import 'package:dio/dio.dart';

class OpenAIService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://api.openai.com/v1';
  final String _apiKey;

  OpenAIService(this._apiKey) {
    _dio.options.baseUrl = _baseUrl;
    _dio.options.headers = {
      'Authorization': 'Bearer $_apiKey',
      'Content-Type': 'application/json',
    };
  }

  Future<String> sendMessage(String message) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': 'gpt-4', // Changed from gpt-3.5-turbo to gpt-4
          'messages': [
            {'role': 'user', 'content': message}
          ],
        },
      );

      if (response.statusCode == 200) {
        return response.data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to get response from OpenAI');
      }
    } catch (e) {
      throw Exception('Error communicating with OpenAI: $e');
    }
  }
}
