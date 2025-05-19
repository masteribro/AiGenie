import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static Future<String> getResponse(String prompt) async {
    const apiKey = 'AIzaSyACGxJoQv_fudrQ4a1Nw8NV56dB_zH9Rw8';

    final response = await http.post(
      Uri.parse("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey"),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "contents": [{
          "parts":[{"text": prompt}]
        }]
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