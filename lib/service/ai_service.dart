import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static Future<String> getResponse(String prompt) async {
    const apiKey = '';

    final response = await http.post(
      Uri.parse('https://api-inference.huggingface.co/models/gpt2'),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "inputs": prompt,
        "parameters": {
          "temperature": 0.5,
          "max_new_tokens": 500,
        }
      }),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result[0]['generated_text'] ?? 'No response';
    } else {
      throw Exception('Error: ${response.statusCode} - ${response.body}');
    }
  }
}